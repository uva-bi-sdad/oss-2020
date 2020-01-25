using SPDXQueries

using SPDXQueries: execute

conf = ConfParse(joinpath(homedir(), "confs", "config.simple"))
parse_conf!(conf)
const db_usr = retrieve(conf, "db_usr");
const db_pwd = retrieve(conf, "db_pwd");

conn = Connection("host = postgis1 port = 5432 dbname = sdad user = $db_usr password = $db_pwd")
