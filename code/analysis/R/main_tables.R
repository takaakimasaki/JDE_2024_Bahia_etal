main_tables <- function(dt, varlist, filename, ncol){
n <- 0
for(variable in varlist) {
  n <- n + 1
  #dt <- results_main
  #variable <- "worknonhh"
  
  new_row <- data.frame(gt = NA, v = NA, b_coef = NA, se = NA, t = NA, pval_pre = NA, n_obs = NA)
   results_coef_sub <- dt %>%
    filter(v == variable) %>%
     bind_rows(new_row) %>%
    dplyr::select(gt,b_coef) %>%
    rename(!!sym(variable) := b_coef) %>%
    mutate(type = "coef")
   
  #variable <- "lntotcons_adj"
  results_se_sub <- dt %>%
    filter(v == variable) %>%
    mutate(se = ifelse(!is.na(gt),paste0("(",round(se,4),")"),NA)) %>%
    dplyr::select(gt,se) %>%
    rename(!!sym(variable) := se)%>%
    mutate(type = "se") 
  
  cond <- c("Early - Wave 2","Early - Wave 3","Late - Wave 2")
  
  pval <- dt %>%
    filter(v == variable) %>%
    mutate(pval_pre = round(pval_pre,4)) %>%
    dplyr::select(gt,pval_pre) %>%
    mutate(pval_pre = ifelse(gt=="Early - Wave 2" | gt=="Late - Wave 2","",pval_pre),
           pval_pre = as.character(pval_pre)) %>%
    rename(!!sym(variable) := pval_pre) %>%
    filter(gt %in% cond) %>%
    mutate(gt = ifelse(gt=="Early - Wave 2","",gt),
           gt = ifelse(gt=="Early - Wave 3","p-value for test of",gt),
           gt = ifelse(gt=="Late - Wave 2","conditional parallel trends",gt)) 
  
  n_obs <- dt %>%
    filter(v == variable & gt == "Early - Wave 2") %>%
    mutate(gt = "N. of observations",
           n_obs = as.character(n_obs)) %>%
    dplyr::select(gt,n_obs) %>%
    rename(!!sym(variable) := n_obs) 
    
  if(n==1) { 
    results_1 <- results_coef_sub %>%
      bind_rows(., results_se_sub) %>%
     bind_rows(., pval) %>%
      bind_rows(., n_obs) 
  }
  
  if(n>1) { 
    results_2 <- results_coef_sub %>%
      bind_rows(., results_se_sub) %>%
      bind_rows(., pval)%>%
      bind_rows(., n_obs) 
    
    results_1 <- results_1 %>%
      left_join(., results_2, by=c("gt","type"))
    rm(results_2, results_coef_sub, results_se_sub)
  }
}

results_coef_se <- results_1 %>%
  filter(type %in% c("coef","se")) %>%
  arrange(gt) %>%
  mutate(gt = ifelse(type=="se","",gt)) %>%
  dplyr::select(-type)

results_pval <- results_1 %>%
  filter(!type %in% c("coef","se")) %>%
  arrange(gt) %>%
  dplyr::select(-type) %>%
  mutate(order = seq(1:dim(.)[1])) %>%
  mutate(order = ifelse(order == 3, 5, order))  %>%
  arrange(order) %>%
  dplyr::select(-order) 

results_n_obs <- results_1 %>%
  filter(gt =="N. of observations") 

#now let's change the order of the rows
results_final <- results_coef_se %>%
  mutate(order = seq(1:dim(.)[1])) %>%
  mutate(order = ifelse(order == 11, 8.5, order)) %>%
  arrange(order) %>%
  dplyr::select(-order) %>%
  bind_rows(., results_pval)  %>%
  mutate(gt = ifelse(is.na(gt)," ",gt)) %>%
  filter(gt!= "N. of observations") %>%
  bind_rows(., results_n_obs) %>%
  dplyr::select(-type)

n <- 0
while(dim(results_final)[2]<=ncol) {
  n <- n + 1
  var <- paste0("x",n)
  results_final <- results_final %>%
    mutate(!!sym(var) := "")
}

results_final.tex <- xtable(results_final)
hline1 <- nrow(results_final)-3 #draw a line 
hline2 <- nrow(results_final)-1 #draw a line
print(results_final.tex, hline.after = c(-1,0,hline1,hline2,nrow(results_final)),include.rownames=FALSE, file=filename)

#remove unnecessary rows
text <- read.delim(filename) 
colnames(text) <- "temp" 

text_main <- text %>%
  mutate(n_row = seq(1:dim(.)[1])) %>%
  filter(n_row >=8 & n_row <= 24) %>%
  filter(n_row !=12 & n_row !=13) %>% #drop pre-trend
  dplyr::select(-n_row) 

text_last <- as.data.frame(text_main[dim(text_main)[1],])
colnames(text_last) <- "temp"

text_last <- text_last %>%
  mutate(temp = str_sub(temp, end = -5))

text_main  %>%
  mutate(n_row = seq(1:dim(.)[1])) %>%
  filter(n_row != dim(.)[1]) %>%
  dplyr::select(-n_row) %>%
  bind_rows(., text_last) %>% 
  write.table(., file=filename, append = FALSE, row.names = FALSE, col.names = FALSE, quote = FALSE)
}