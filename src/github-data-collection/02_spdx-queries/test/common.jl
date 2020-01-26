filter!(isequal(joinpath(homedir(), ".julia")), DEPOT_PATH);
using Pkg
pkg"activate .."
pkg"instantiate"

using SPDXQueries

using SPDXQueries: execute, prepare

conf = ConfParse(joinpath(homedir(), "confs", "config.simple"))
parse_conf!(conf)
const db_usr = retrieve(conf, "db_usr");
const db_pwd = retrieve(conf, "db_pwd");

conn = Connection("host = postgis1 port = 5432 dbname = sdad user = $db_usr password = $db_pwd")
insert_spdx_queries = prepare(conn, "INSERT INTO gh.spdx_queries VALUES(\$1, \$2, \$3, \$4, \$5) ON CONFLICT ON CONSTRAINT spdx_query DO UPDATE SET count = EXCLUDED.count;")

function magic(spdx::AbstractString)
    done = false
    while !done
        done = find_queries(conn, github_tokens, spdx, insert_spdx_queries)
    end
    done
end
