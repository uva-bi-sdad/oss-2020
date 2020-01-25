start_time = Sys.time()

using Distributed
addprocs(13)

using Test, SPDXQueries

using SPDXQueries: execute

conf = ConfParse(joinpath(homedir(), "confs", "config.simple"))
parse_conf!(conf)
const db_usr = retrieve(conf, "db_usr");
const db_pwd = retrieve(conf, "db_pwd");

conn = Connection("host = postgis1 port = 5432 dbname = sdad user = $db_usr password = $db_pwd")

execute(conn, """CREATE TABLE IF NOT EXISTS gh.spdx_queries (
                         spdx text NOT NULL,
                         dtinterval text NOT NULL,
                         count integer NOT NULL,
                         status text NOT NULL,
                         as_of timestamp with time zone NOT NULL
                         );
                         ALTER TABLE gh.spdx_queries OWNER to ncses_oss;
                         COMMENT ON TABLE gh.spdx_queries IS 'This table is a tracker for queries';
                         CREATE INDEX spdx_queries_interval ON gh.spdx_queries (dtinterval);
                         CREATE INDEX spdx_queries_spdx ON gh.spdx_queries (spdx);
                         CREATE INDEX spdx_queries_status ON gh.spdx_queries (status);
                         COMMENT ON COLUMN gh.spdx_queries.spdx IS 'The SPDX license ID';
                         COMMENT ON COLUMN gh.spdx_queries.dtinterval IS 'The time interval for the query';
                         COMMENT ON COLUMN gh.spdx_queries.count IS 'How many results for the query';
                         COMMENT ON COLUMN gh.spdx_queries.status IS 'Whether the query is In Progress, Done, or Error';
                         );
                         """)
has_constraint = getproperty.(execute(conn, "SELECT COUNT(*) FROM pg_constraint WHERE conname = 'spdx_query';"), :count)[1] == 1
if !has_constraint
    execute(conn, "ALTER TABLE gh.spdx_queries ADD CONSTRAINT spdx_query UNIQUE (spdx, dtinterval);")
end
execute(conn, "COMMENT ON CONSTRAINT spdx_query ON gh.spdx_queries IS 'No duplicate for queries';")
licenses = getproperty.(execute(conn, """SELECT spdx FROM gh.licenses ORDER BY spdx;"""), :spdx);
login_token = collect((row.login, row.pat) for row ∈ execute(conn, """SELECT login, pat FROM gh.pat LIMIT 26;"""));

@everywhere include(joinpath("test", "common.jl"))

for proc ∈ workers()
    idx = [x:x + 1 for x ∈ range(1, length(login_token), step = 2)][proc - 1]
    tokens = [ GitHubPersonalAccessToken(login, token) for (login, token) ∈
               login_token[idx] ]
    expr = :(github_tokens = $tokens)
    Distributed.remotecall_eval(Main, proc, expr)
end

@sync @distributed for spdx ∈ licenses
    done = false
    while !done
        done = find_queries(conn, github_tokens, spdx)
    end
end

all_licenses_done = getproperty.(execute(conn,
                                         """SELECT (SELECT COUNT(*)	FROM gh.spdx_queries WHERE dtinterval ~ '2019-01-01') =
                                                   (SELECT COUNT(*) FROM gh.licenses)
                                                   AS done;
                                         """), :done)[1]

@test all_licenses_done

close(conn)

println("Elapsed time: ", Int(ceil((Sys.time() - start_time) / 60)), " minutes")
