start_time = Sys.time()

using Revise, Hwloc, Distributed
addprocs(4)

@everywhere include("common.jl")

licenses = getproperty.(execute(conn, """SELECT A.spdx FROM gh.licenses A
                                         LEFT JOIN (SELECT spdx, MAX(dtinterval) ~ '2019-01-01' AS done
                                         FROM gh.spdx_queries GROUP BY spdx) B
                                         ON A.spdx = B.spdx
                                         WHERE done is null OR NOT done;
                                      """), :spdx);
login_token = collect((row.login, row.pat) for row ∈ execute(conn, """SELECT login, pat FROM gh.pat LIMIT 26;"""));

for proc ∈ workers()
    idx = [x:x + 1 for x ∈ range(1, length(login_token), step = 2)][proc - 1]
    tokens = [ GitHubPersonalAccessToken(login, token) for (login, token) ∈
               login_token[idx] ]
    expr = :(github_tokens = $tokens)
    Distributed.remotecall_eval(Main, proc, expr)
end

@sync @distributed for spdx ∈ licenses
    println(spdx)
    magic(spdx)
end

all_licenses_done = getproperty.(execute(conn,
                                         """SELECT (SELECT COUNT(*)	FROM gh.spdx_queries WHERE dtinterval ~ '2019-01-01') =
                                                   (SELECT COUNT(*) FROM gh.licenses)
                                                   AS done;
                                         """), :done)[1]

@test all_licenses_done

@everywhere close(conn)

println("Elapsed time: ", Int(ceil((Sys.time() - start_time) / 60)), " minutes")
