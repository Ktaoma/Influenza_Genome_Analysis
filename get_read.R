library(dplyr)
library(data.table)
library(Biostrings)

args <- commandArgs(trailingOnly = TRUE)

anno <- read.table(paste0(args[3],"/annotation.txt"),header = T)
df <- fread(args[1]) %>% as.data.frame()
jdf <- inner_join(df,anno,by="V2")

cnt <- table(jdf$V1,jdf$gene) %>% 
  as.data.frame() %>% filter(Freq != 0) %>%
  select(Var1,Var2) %>% unique() 

cn <- table(cnt$Var1) %>% as.data.frame()

dup <- cn %>% filter(Freq==2) %>% select(Var1) %>% unlist() %>% as.vector()

jdf %>% filter(!V1 %in% dup) %>% select(V1,gene) %>% unique() %>% write.csv(paste0(args[2],"/group.txt"))
