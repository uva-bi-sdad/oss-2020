start_time = Sys.time()

using Test, Licenses

using Licenses: execute

conf = ConfParse(joinpath(homedir(), "confs", "config.simple"))
parse_conf!(conf)
const db_usr = retrieve(conf, "db_usr");
const db_pwd = retrieve(conf, "db_pwd");

conn = Connection("host = postgis1 port = 5432 dbname = sdad user = $db_usr password = $db_pwd")
upload_licenses(conn)

lic_count = getproperty.(execute(conn, "SELECT COUNT(*)	FROM gh.licenses;"), :count)[1]

@test lic_count == 88

close(conn)

println("Elapsed time: ", Int(ceil((Sys.time() - start_time) / 60)), " minutes")
