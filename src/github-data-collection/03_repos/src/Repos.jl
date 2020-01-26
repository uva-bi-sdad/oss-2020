"""
    Repos

Application for identifying repositories.
"""
module Repos
    using HTTP: Response
    using ConfParser: ConfParse, parse_conf!, retrieve
    using Dates: unix2datetime, DateTime, now, canonicalize, CompoundPeriod, DateFormat, format
    using Diana: Client, GraphQLClient
    using JSON3: JSON3
    using Tables: rowtable
    using TimeZones: ZonedDateTime, TimeZone
    using LibPQ: Connection, execute, prepare
    using Parameters: @unpack
    import Base: isless, show

    """
        response_dtf = dateformat"d u y H:M:S Z"
    HTTP responses require this datetime format.
    """
    const response_dtf = DateFormat("d u y H:M:S Z");
    const github_dtf = "yyyy-mm-ddTHH:MM:SSzzzz";
    const github_endpoint = "https://api.github.com/graphql";
    """
        until::ZonedDateTime
    Until when should the scrapper query data. Currently at `"2019-08-15T00:00:00-04:00"`.
    """
    const until = ZonedDateTime("2020-01-01T00:00:00-00:00",
                                github_dtf)
    """
        find_repos::String
    Queries for finding open-sourced repositories.
    """
    const find_repos = """
        query Search(\$license_created: String!) {
            search(query: \$license_created,
                   type: REPOSITORY) {
            repositoryCount
            }
        }
        """;
    mutable struct GitHubPersonalAccessToken
        client::Client
        id::String
        remaining::Int
        reset::ZonedDateTime
        function GitHubPersonalAccessToken(login::AbstractString, token::AbstractString)
            client = GraphQLClient(github_endpoint,
                                   auth = "bearer $token",
                                   headers = Dict("User-Agent" => login))
            result = client.Query(find_queries_by_license, operationName = "")
            remaining = parse(Int, result.Info["X-RateLimit-Remaining"])
            reset = parse(Int, result.Info["X-RateLimit-Reset"]) |>
                unix2datetime |>
                (dt -> ZonedDateTime(dt, TimeZone("UTC")))
            new(client, login, remaining, reset)
        end
    end
    function show(io::IO, obj::GitHubPersonalAccessToken)
        println(io, "$(obj.id): (remaining: $(obj.remaining))")
    end
    function isless(x::GitHubPersonalAccessToken, y::GitHubPersonalAccessToken)
        if iszero(x.remaining) && !iszero(y.remaining)
            false
        else
            isless(x.reset, y.reset)
        end
    end
    function update!(obj::GitHubPersonalAccessToken)
        if obj.reset ≤ now(TimeZone("UTC"))
            obj.remaining = 5_000
        end
        obj
    end
    """
        binary_search_dt_interval(license::AbstractString,
                                  interval::AbstractString)::data, as_of, created_at
    Given a license and a datetime interval, it will use binary search to find
    a datetime interval with no more than 1,000 results.
    """
    function binary_search_dt_interval(pat::AbstractVector{<:GitHubPersonalAccessToken},
                                       license::AbstractString,
                                       created_at::AbstractString)
        dt_start = match(r".*(?=\.{2})", created_at)
        if isnothing(dt_start)
            dt_start = replace(created_at, r"Z$" => "+00:00") |>
                       (dt -> ZonedDateTime(dt, github_dtf))
        else
            dt_start = match(r".*(?=\.\.)", created_at).match |>
                       (dt -> replace(dt, r"Z$" => "+00:00")) |>
                       (dt -> ZonedDateTime(dt, github_dtf))
        end
        dt_end = match(r"(?<=\.{2}).*", created_at)
        if isnothing(dt_end)
            dt_end = until
        else
            dt_end = match(r"(?<=\.{2}).*", created_at).match |>
                     (dt -> replace(dt, r"Z$" => "+00:00")) |>
                     (dt -> ZonedDateTime(dt, github_dtf))
        end
        foreach(update!, pat)
        sort!(pat)
        next_available = first(pat)
        result = next_available.client.Query(find_queries_by_license,
                                             operationName = "Search",
                                             vars = Dict("license_created" =>
                                                         """license:$license
                                                            archived:false
                                                            fork:false
                                                            mirror:false
                                                            created:$dt_start..$dt_end
                                                         """))
        sleep(rand(0.25:0.15:1.25))
        next_available.remaining -= 1
        as_of = get_as_of(result.Info)
        json = JSON3.read(result.Data)
        @assert(haskey(json, :data))
        data = json.data
        repositoryCount = data.search.repositoryCount
        while repositoryCount > 1_000
            dt_end = dt_start + (dt_end - dt_start) ÷ 2 |>
                     (dt -> format(dt, github_dtf)) |>
                     (dt -> ZonedDateTime(dt, github_dtf))
            foreach(update!, pat)
            sort!(pat)
            next_available = first(pat)
            result = next_available.client.Query(find_queries_by_license,
                                                 operationName = "Search",
                                                 vars = Dict("license_created" =>
                                                             """license:$license
                                                                archived:false
                                                                fork:false
                                                                mirror:false
                                                                created:$dt_start..$dt_end
                                                             """))
            sleep(rand(0.25:0.15:1.25))
            next_available.remaining -= 1
            as_of = get_as_of(result.Info)
            json = JSON3.read(result.Data)
            @assert(haskey(json, :data))
            data = json.data
            repositoryCount = data.search.repositoryCount
        end
        data.search, as_of, "$dt_start..$dt_end"
    end
    """
        get_as_of(response::Response)::String
    
    Returns the zoned date time when the response was returned.
    """
    get_as_of(response::Response) =
        response.headers[findfirst(x -> isequal("Date", x.first),
                                   response.headers)].second[6:end] |>
            (dt -> ZonedDateTime(dt, response_dtf)) |>
            string
    function find_queries(conn::Connection,
                          github_tokens::AbstractVector{<:GitHubPersonalAccessToken},
                          spdx::AbstractString,
                          insert_spdx_queries)
        last_dt = execute(conn, """SELECT dtinterval FROM gh.spdx_queries
                                   WHERE spdx = '$spdx' ORDER BY dtinterval DESC LIMIT 1;
                                """)
        last_dt = getproperty.(last_dt, :dtinterval)
        if isempty(last_dt)
            last_dt = "2007-10-29T14:37:16Z..2019-01-01T00:00:00Z"
        else 
            from_dt = match(r"(?<=\.\.).*", last_dt[1]).match
            from_dt == "2019-01-01T00:00:00+00:00" && return true
            last_dt = "$from_dt..2019-01-01T00:00:00Z"
        end
        data, as_of, created_at = binary_search_dt_interval(github_tokens, spdx, last_dt)
        execute(insert_spdx_queries, (spdx, created_at, data.repositoryCount, "Initiated", as_of))
        occursin(r"2019-01-01", created_at)
    end
    export # ConfParser
        ConfParse, parse_conf!, retrieve,
        # LibPQ
        Connection,
        # SPDXQueries
        GitHubPersonalAccessToken, find_queries
end
