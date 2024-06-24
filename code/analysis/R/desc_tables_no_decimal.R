desc_tables_no_decimal <- function(table, filename) {
  #table <- results_hh
  table.tex <- xtable(table, digits = c(0,0,0,0,0,0,0,0,0,0,0))
  print(table.tex, hline.after = c(-1,0,nrow(table)),include.rownames=FALSE, file=filename)
  
  #remove unnecessary rows
  text <- read.delim(filename) 
  colnames(text) <- "temp" 
  
  n_row_3 <- dim(text)[1] - 3
  text_main <- text %>%
    mutate(n_row = seq(1:dim(.)[1])) %>%
    filter(n_row >=8 & n_row <= n_row_3) %>%
    dplyr::select(-n_row) 
  
  text_last <- as.data.frame(text_main[dim(text_main)[1],])
  colnames(text_last) <- "temp"
  
  text_last <- text_last %>%
    mutate(temp = str_sub(temp, end = -4))
  
  text_main  %>%
    mutate(n_row = seq(1:dim(.)[1])) %>%
    filter(n_row != dim(.)[1]) %>%
    dplyr::select(-n_row) %>%
    bind_rows(., text_last) %>% 
    write.table(., file=filename, append = FALSE, row.names = FALSE, col.names = FALSE, quote = FALSE)
}
