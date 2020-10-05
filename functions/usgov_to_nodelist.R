

usgov_to_nodelist <- function(edgelist){
  vertices <- data.frame(name = unique(c(as.character(edgelist$from), as.character(edgelist$to))))
  vertices <- vertices %>%
    rename(id = name) %>%
    arrange(id)
}
