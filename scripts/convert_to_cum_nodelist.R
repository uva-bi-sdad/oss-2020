

convert_to_cum_nodelist <- function(){

full_nodelist <- nodelist_2008 %>%
  select(-id) %>%
  mutate(login = as.character(login)) %>%
  rename(deg08 = deg_cent,
         wtddeg08 = wtd_deg_cent,
         eigen08 = eigen_cent,
         pgrank08 = page_rank,
         auth08 = auth_score,
         hug08 = hub_score,
         kcore08 = k_core,
         louvain08 = louvain_comm,
         fstgrdy08 = fstgrdy_comm,
         comp08 = component) %>%
  full_join(nodelist_200809, by = "login") %>%
  select(-id) %>%
  rename(deg0809 = deg_cent,
         wtddeg0809 = wtd_deg_cent,
         eigen0809 = eigen_cent,
         pgrank0809 = page_rank,
         auth0809 = auth_score,
         hug0809 = hub_score,
         kcore0809 = k_core,
         louvain0809 = louvain_comm,
         fstgrdy0809 = fstgrdy_comm,
         comp0809 = component) %>%
  full_join(nodelist_200810, by = "login") %>%
  select(-id) %>%
  rename(deg0810 = deg_cent,
         wtddeg0810 = wtd_deg_cent,
         eigen0810 = eigen_cent,
         pgrank0810 = page_rank,
         auth0810 = auth_score,
         hug0810 = hub_score,
         kcore0810 = k_core,
         louvain0810 = louvain_comm,
         fstgrdy0810 = fstgrdy_comm,
         comp0810 = component) %>%
  full_join(nodelist_200811, by = "login") %>%
  select(-id) %>%
  rename(deg0811 = deg_cent,
         wtddeg0811 = wtd_deg_cent,
         eigen0811 = eigen_cent,
         pgrank0811 = page_rank,
         auth0811 = auth_score,
         hug0811 = hub_score,
         kcore0811 = k_core,
         louvain0811 = louvain_comm,
         fstgrdy0811 = fstgrdy_comm,
         comp0811 = component) %>%
  full_join(nodelist_200812, by = "login") %>%
  select(-id) %>%
  rename(deg0812 = deg_cent,
         wtddeg0812 = wtd_deg_cent,
         eigen0812 = eigen_cent,
         pgrank0812 = page_rank,
         auth0812 = auth_score,
         hug0812 = hub_score,
         kcore0812 = k_core,
         louvain0812 = louvain_comm,
         fstgrdy0812 = fstgrdy_comm,
         comp0812 = component) %>%
  full_join(nodelist_200813, by = "login") %>%
  select(-id) %>%
  rename(deg0813 = deg_cent,
         wtddeg0813 = wtd_deg_cent,
         eigen0813 = eigen_cent,
         pgrank0813 = page_rank,
         auth0813 = auth_score,
         hug0813 = hub_score,
         kcore0813 = k_core,
         louvain0813 = louvain_comm,
         fstgrdy0813 = fstgrdy_comm,
         comp0813 = component) %>%
  full_join(nodelist_200814, by = "login") %>%
  select(-id) %>%
  rename(deg0814 = deg_cent,
         wtddeg0814 = wtd_deg_cent,
         eigen0814 = eigen_cent,
         pgrank0814 = page_rank,
         auth0814 = auth_score,
         hug0814 = hub_score,
         kcore0814 = k_core,
         louvain0814 = louvain_comm,
         fstgrdy0814 = fstgrdy_comm,
         comp0814 = component) %>%
  full_join(nodelist_200815, by = "login") %>%
  select(-id) %>%
  rename(deg0815 = deg_cent,
         wtddeg0815 = wtd_deg_cent,
         eigen0815 = eigen_cent,
         pgrank0815 = page_rank,
         auth0815 = auth_score,
         hug0815 = hub_score,
         kcore0815 = k_core,
         louvain0815 = louvain_comm,
         fstgrdy0815 = fstgrdy_comm,
         comp0815 = component) %>%
  full_join(nodelist_200816, by = "login") %>%
  select(-id) %>%
  rename(deg0816 = deg_cent,
         wtddeg0816 = wtd_deg_cent,
         eigen0816 = eigen_cent,
         pgrank0816 = page_rank,
         auth0816 = auth_score,
         hug0816 = hub_score,
         kcore0816 = k_core,
         louvain0816 = louvain_comm,
         fstgrdy0816 = fstgrdy_comm,
         comp0816 = component) %>%
  full_join(nodelist_200817, by = "login") %>%
  select(-id) %>%
  rename(deg0817 = deg_cent,
         wtddeg0817 = wtd_deg_cent,
         eigen0817 = eigen_cent,
         pgrank0817 = page_rank,
         auth0817 = auth_score,
         hug0817 = hub_score,
         kcore0817 = k_core,
         louvain0817 = louvain_comm,
         fstgrdy0817 = fstgrdy_comm,
         comp0817 = component) %>%
  full_join(nodelist_200818, by = "login") %>%
  select(-id) %>%
  rename(deg0818 = deg_cent,
         wtddeg0818 = wtd_deg_cent,
         eigen0818 = eigen_cent,
         pgrank0818 = page_rank,
         auth0818 = auth_score,
         hug0818 = hub_score,
         kcore0818 = k_core,
         louvain0818 = louvain_comm,
         fstgrdy0818 = fstgrdy_comm,
         comp0818 = component) %>%
  full_join(nodelist_200819, by = "login") %>%
  select(-id) %>%
  rename(deg0819 = deg_cent,
         wtddeg0819 = wtd_deg_cent,
         eigen0819 = eigen_cent,
         pgrank0819 = page_rank,
         auth0819 = auth_score,
         hug0819 = hub_score,
         kcore0819 = k_core,
         louvain0819 = louvain_comm,
         fstgrdy0819 = fstgrdy_comm,
         comp0819 = component)
}
