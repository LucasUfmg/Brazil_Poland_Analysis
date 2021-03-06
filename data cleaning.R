rm(list=ls())
gc()

# Preprocessing Brazil data
install.packages("tidyverse")
install.packages("readxl")
install.packages("corrplot")
library(readxl)
library(tidyverse)
library(tibble)
library(purrr)

library(corrplot)
br = read_excel(file.choose(), col_names = T)
#br[,3:4] = NULL # NUll problematic columns in br to be replaced by tmp

df.1 = br[,c(1,2,5,10:39)]
df.2 = br[,c(1,2,5,40:76)]
df.3 = br[,c(1,2,5,77:81)]
df.4 = br[,c(1,2,5,82:87)]
df.5 = br[,c(1,2,5,88:92)]
df.6 = br[,c(1,2,5,93:101)]
df.7 = br[,c(1,2,5,102:141)]
df.8 = br[,c(1,2,5,142:144)]
df.9 = br[,c(1,2,5,145:149)]
df.10 = br[,c(1,2,5,150:174)]
df.11 = br[,c(1,2,5,175:180)]
df.12 = br[,c(1,2,5,181:185)]
df.13 = br[,c(1,2,5,186:191)]
df.14 = br[,c(1,2,5,192)]
df.15 = br[,c(1,2,5,193:195)]
df.16 = br[,c(1,2,5,196:201)]
df.17 = br[,c(1,2,5,202:206)]
df.18 = br[,c(1,2,5,207:211)]
df.19 = br[,c(1,2,5,212:212)]
df.20 = br[,c(1,2,5,213:214)]
df.21 = br[,c(1,2,5,215:222)]
df.22 = br[,c(1,2,5,223:225)]
df.23 = br[,c(1,2,5,226:253)]
df.24 = br[,c(1,2,5,254:254)]
df.25 = br[,c(1,2,5,255:257)]
df.26 = br[,c(1,2,5,258:262)]
df.27 = br[,c(1,2,5,263:263)]
df.28 = br[,c(1,2,5,264:264)]

l.df = lapply(ls(pattern="df.[0-9]+"), function(x) get(x)) # Cria lista de data frames do environment que possuem padr?o "df."

# Ajeita cabe?alho dos data frames
for (k in 1:28) {
  colnames(l.df[[k]]) = l.df[[k]][1,]
  l.df[[k]] = l.df[[k]][-1,]
  #l.df[[k]][is.na(l.df[[k]])] = 0
  colnames(l.df[[k]])[1:3] = c("Respondent","Collector","IP")
  #write.csv(l.df[[k]],paste0("C:\\Users\\iis\\Desktop\\Lucas\\estatisticas_aga\\tabelas\\","t_",k,".csv"))
}


# Organiza data frames para perguntas 
# Pergunta 1
# Brazil
setwd("C:\\Users\\iis\\Desktop\\Lucas\\estatisticas_aga\\tabelas\\poland")  
t1 = read.csv("Nature_to_be_Spered_based_on_Age2.csv")
t1$X = NULL

# Polonia 


#########################################
##################################################

# Pergunta 2

# Brazil

id = c(names(l.df[[1]]))
for (i in seq(4,length(id),3)) { # existe um padrao de 3 em 3 entao dado que sao trinta, se eu fizer dez vezes, pego todas as trincas
  print(i)
  l.df[[1]][paste0(id[[i]],"_tmp")] = ifelse(l.df[[1]][[i]] == 0 ,l.df[[1]][[i + 1]],l.df[[1]][[i]])
  l.df[[1]][paste0(id[[i]],"_final")] = ifelse(l.df[[1]][[paste0(id[[i]],"_tmp")]] == 0, l.df[[1]][[i + 2]],l.df[[1]][[paste0(id[[i]],"_tmp")]])
  l.df[[1]][paste0(id[[i]],"_tmp")] = NULL
  #l.df[[1]][,4:6] = NULL
}

l.df[[1]] = l.df[[1]][,- (4:33)]
colnames(l.df[[1]]) = c("Respondent","Collector","IP","air_polution","sea_polution","river_polution","deforestation","climate_change","water_scarcity",
                        "lack_of_sanitation","species_extinction","use_of_pesticides","soil_erosion")
names(l.df[[1]])
q_2_b = l.df[[1]][,4:ncol(l.df[[1]])]
#q_2_b[q_2_b == 0] = NA  
q_2_b[q_2_b == "Alta"] = "3"
q_2_b[q_2_b == "M?dia"] = "2"
q_2_b[q_2_b == "Baixa"] = "1"

q_2_b_tmp = q_2_b %>% map_if(is.character, as.numeric)
q_2_b = as.data.frame(q_2_b_tmp)

# Polonia
t2 = read.csv("Nature_to_be_Spered_based_on_Explanatory_Variables.csv")
t2$X = NULL
q_2_p = t2[,1:10] # Para nao baguncar t2


#Statistics 
names(q_2_b)
names(q_2_p)

# Sampling variables and check the score of each variable
tmp = q_2_b[sample(nrow(q_2_b), 200), ]
tmp1 = q_2_p[sample(nrow(q_2_p), 200), ]

tmp$Country = "Brazil"
tmp1$Country = "Poland"

colnames(tmp1) = names(tmp)

df_to_question_2 = rbind(tmp,tmp1)

write.csv(df_to_question_2,"C:\\Users\\iis\\Desktop\\Lucas\\estatisticas_aga\\tabelas\\df_to_question_2.csv")


q_2_b.total = data.frame(colSums(tmp, na.rm = FALSE, dims = 1))
colnames(q_2_b.total) = "Answers summed Brazil"

q_2_p.total = data.frame(colSums(tmp1, na.rm = FALSE, dims = 1))
colnames(q_2_p.total) = "Answers summed Poland"

ranked_variables = cbind(q_2_b.total,q_2_p.total)

write.csv(ranked_variables,"C:\\Users\\iis\\Desktop\\Lucas\\estatisticas_aga\\tabelas\\ranked_variables.csv")

# Check variable correlation (Let's keep working with tmp and tmp1 - aint't good with names) 
TMP = cbind(tmp,tmp1) # Merged DF with q_2_b and q_2_p
plot(TMP$air_polution ~ TMP$Zanieczyszczenie_powietrza)



cor(TMP, use="complete.obs", method="kendall") 
cov(mtcars, use="complete.obs")

aov_tmp= aov(TMP$air_polution ~ TMP$Zanieczyszczenie_powietrza, data = TMP)
summary(aov_tmp)
# for(j in seq(2,length(q_2_b),1)){
#        print(j)
#       # Transforma character to factor
#       q_2_b[[j]] = parse_factor(q_2_b[[j]], 
#                                     unique(q_2_b[[j]]))
#      }


## corrplot 0.84 loaded
M = cor(q_2_b)
corrplot(M, method = "number")


#########################################
##################################################

# Pergunta 3
# Brazil 

names(l.df[[2]])

id.2 = c(names(l.df[[2]]))
for (i in seq(4,length(id.2),5)) { # existe um padrao de 3 em 3 entao dado que sao trinta, se eu fizer dez vezes, pego todas as trincas
  print(i)
  l.df[[2]][paste0(id.2[[i]],"_tmp")] = ifelse(l.df[[2]][[i]] == 0 ,l.df[[2]][[i + 1]],l.df[[2]][[i]])
  l.df[[2]][paste0(id.2[[i]],"_final")] = ifelse(l.df[[2]][[paste0(id.2[[i]],"_tmp")]] == 0, l.df[[2]][[i + 2]],l.df[[2]][[paste0(id.2[[i]],"_tmp")]])
  l.df[[2]][paste0(id.2[[i]],"_tmp")] = NULL
  #l.df[[1]][,4:6] = NULL
}
l.df[[2]] = l.df[[2]][,-(4:28)]

# Polonia


#########################################
##################################################

#   t3 = read.csv("Nature_to_be_Spered_based_on_Man_Woman.csv")
#   t3$X = NULL 
# for (i in 1:30) {
#   for(j in c(seq(4,length(l.df[[i]]),1))){
#     print(i)
#     print(j)
#     # Transforma character to factor
#     l.df[[i]][j] <- parse_factor(l.df[[i]][j], 
#                                  unique(l.df[[i]][j]))
#   }
# }
# 

# df.1[3:ncol(df.1)][df.1[3:ncol(df.1)] == "M?dia"] = "2"
# df.1[3:ncol(df.1)][df.1[3:ncol(df.1)] == "Baixa"] = "1"
# df.1[3:ncol(df.1)][df.1[3:ncol(df.1)] == "Alta"] = "3"
# colnames(l.df[[i]])[1:3] = c("Respondent","Collector","IP")











