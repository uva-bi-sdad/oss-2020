

usgov_to_graph <- function(df){

  # branch to agency (when agency <> NA)
  branch_agency <- df %>%
    drop_na(agency) %>%
    select(branch, agency) %>%
    rename(from = branch, to = agency) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # branch to subagency (when agency <> NA)
  # only medpac and macpac
  branch_subagency <- df %>%
    filter(is.na(agency)) %>%
    drop_na(subagency) %>%
    select(branch, unique_institution) %>%
    rename(from = branch, to = unique_institution) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # agency to subagency (when agency <> NA & subagency <> NA)
  agency_subagency <- df %>%
    drop_na(agency, subagency) %>%
    select(agency, subagency) %>%
    rename(from = agency, to = subagency) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # branch to institution (when agency = NA)
  branch_institution <- df %>%
    filter(is.na(agency)) %>%
    select(branch, unique_institution) %>%
    rename(from = branch, to = unique_institution) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # agency to institution (when agency <> NA & subagency = NA)
  agency_institution <- df %>%
    drop_na(agency) %>%
    filter(is.na(subagency)) %>%
    select(agency, unique_institution) %>%
    rename(from = agency, to = unique_institution) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # subagency to institution
  subagency_institution <- df %>%
    drop_na(subagency) %>%
    select(subagency, unique_institution) %>%
    rename(from = subagency, to = unique_institution) %>%
    group_by(from, to) %>%
    count() %>% rename(weight = n)

  # bind together as a weighted edgelist
  usgov_edgelist <- bind_rows(branch_agency, branch_subagency, agency_subagency, branch_institution, agency_institution, subagency_institution)

  # convert to network
  usgov_network <- graph_from_data_frame(usgov_edgelist, directed = FALSE)


}
