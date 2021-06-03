# Loading necessary libraries
library(haven)
library(ggplot2)
library(plyr)
library(fastDummies)
library(readstata13)
library(dplyr)
library(magrittr)

# Importing the data set
data <- read.dta13("F:\\Assignments\\75\\ess_6_spain.dta")

# Frequency table for inwdds and inwmms

t1 <- plyr::count(data, 'inwdds')
percent <- (t1$freq/sum(t1$freq)*100)
t1$percent <- percent
cumulative_percent <- cumsum(percent)
t1$cumulative_percent <- cumulative_percent
t1

t2 <- plyr::count(data, 'inwmms')
percent <- (t2$freq/sum(t2$freq)*100)
t2$percent <- percent
cumulative_percent <- cumsum(percent)
t2$cumulative_percent <- cumulative_percent
t2

# Generating the D_exposure_barcenas variable

data2 <- data.frame(data$inwdds, data$inwmms)
data2$D_exposure_barcenas <- rep(NA, 1889)

x <- which(data2$data.inwdds < 31 & data2$data.inwmms == 1)
data2$D_exposure_barcenas[x] <- 0

x <- which(data2$data.inwmms > 1)
data2$D_exposure_barcenas[x] <- 1

x <- which(data2$data.inwmms == 1 & data2$data.inwdds == 31)
data2$D_exposure_barcenas[x] <- 1

x <- which(data2$data.inwmms > 2)
data2$D_exposure_barcenas[x] <- NA

data$D_exposure_barcenas <- data2$D_exposure_barcenas


# Time variable for the months of January and February


data2$time <- data2$data.inwdds

x <- which(is.na(data2$D_exposure_barcenas))
data2$time[x] <- NA

x <- which(data2$D_exposure_barcenas == 0)
data2$time[x] <- data2$time[x] - 31

x <- which(data2$time == 31)
data2$time[x] <- 0

data$time <- data2$time

# Time variable for the whole survey fieldwork period 

data2$time_whole <- data2$time

x <- which(data2$data.inwmms == 3)
data2$time_whole[x] <- 28 + data2$data.inwdds[x]

x <- which(data2$data.inwmms == 4)
data2$time_whole[x] <- 59 + data2$data.inwdds[x]

x <- which(data2$data.inwmms == 5)
data2$time_whole[x] <- 89 + data2$data.inwdds[x]

data$time_whole <- data2$time_whole

# Alternative D_exposure_barcenas variable considering the whole survey fieldwork (
# to study decay of the D_exposure_barcenas effect)

data2$treatment1 <- rep(NA, 1889)

x <- which(data2$data.inwdds < 31 & data2$data.inwmms == 1)
data2$treatment1[x] <- 0

x <- which(data2$data.inwmms > 1)
data2$treatment1[x] <- 1

x <- which(data2$data.inwmms == 1 & data2$data.inwdds == 31)
data2$treatment1[x] <- 1

data$treatment1 <- data2$treatment1



# Time variable with positive values for the whole fieldwork period (for simulation)

data$fieldwork_time <- data$time_whole + 8



# Dummies for party voted to 

data3 <- data.frame(data$prtvtces)
plyr::count(data3$data.prtvtces)

data3$data.prtvtces[data3$data.prtvtces == 17] <- 16
data3$data.prtvtces[data3$data.prtvtces == 18] <- 16
data3$data.prtvtces[data3$data.prtvtces == 19] <- 16


data3$data.prtvtces <- factor(data3$data.prtvtces, 
                              levels = c(1:16),
                              labels = c("Partido Popular - PP (con UPN en Navarra)",
                                         "Partido Socialista Obrero Español (PSOE)",
                                         "Convergència i Unió (CiU)",
                                         "Izquierda Unida (IU)-(ICV en Cataluña)",
                                         "AMAIUR",
                                         "Unión, Progreso y Democracia (UPyD)",
                                         "Partido Nacionalista Basco (PNV)",
                                         "Esquerra Republicana de Catalunya (ERC)",
                                         "Bloque Nacionalista Galego (BNG)",
                                         "Coalición Canaria - Nueva Canarias",
                                         "Compromís - EQUO",
                                         "Foro de Ciudadanos",
                                         "Otro",
                                         "Votó en blanco",
                                         "Votó nulo",
                                         "Problem factor"))

plyr::count(data3$data.prtvtces)

data$prtvtces <- data3$data.prtvtces

data <- dummy_cols(data, 
                   select_columns = "prtvtces")

data <- data %>%
  rename(party_voted1 = `prtvtces_Partido Popular - PP (con UPN en Navarra)`,
         party_voted2 = `prtvtces_Partido Socialista Obrero Español (PSOE)`,
         party_voted3 = `prtvtces_Convergència i Unió (CiU)`,
         party_voted4 = `prtvtces_Izquierda Unida (IU)-(ICV en Cataluña)`,
         party_voted5 = `prtvtces_AMAIUR`,
         party_voted6 = `prtvtces_Unión, Progreso y Democracia (UPyD)`,
         party_voted7 = `prtvtces_Partido Nacionalista Basco (PNV)`,
         party_voted8 = `prtvtces_Esquerra Republicana de Catalunya (ERC)`,
         party_voted9 = `prtvtces_Bloque Nacionalista Galego (BNG)`,
         party_voted10 = `prtvtces_Coalición Canaria - Nueva Canarias`,
         party_voted11 = `prtvtces_Compromís - EQUO`,
         party_voted12 = `prtvtces_Foro de Ciudadanos`,
         party_voted13 = `prtvtces_Votó en blanco`,
         party_voted14 = `prtvtces_Votó nulo`,
         party_voted15 = `prtvtces_Problem factor`)




# Recoding activity variable and generating dummies

data$mnactic[data$mnactic == 4] <- 3
data$mnactic[data$mnactic == 6] <- 5
data$mnactic[data$mnactic == 8] <- 5

data$mnactic <- factor(data$mnactic, levels = c(1,2,3,5,9),
                       labels = c("Paid work",
                                  "Education",
                                  "Unemployed, looking for job",
                                  "Permanently sick or disabled",
                                  "Other"))
data$employment <- data$mnactic    

data$employment <- as.numeric(data$employment)    
data$employment[data$employment == 5] <- 9
data$employment[data$employment == 4] <- 5

data$employment <- factor(data$employment, levels = c(1,2,3,5,9),
                       labels = c("Paid work",
                                  "In Education",
                                  "Unemployed",
                                  "Out of labor market",
                                  "Other"))

data <- dummy_cols(data, 
                   select_columns = "employment")
data <- data[,-1353]

data <- data %>%
  rename(emp_paid_work = `employment_Paid work`,
         emp_in_education = `employment_In Education`,
         emp_unemployed = employment_Unemployed,
         emp_out_labor = `employment_Out of labor market`,
         emp_other = employment_Other)


# Elections winner variable (coded 1 for PP voters)

data$election_winner <- data$party_voted1


# Number of times a respondent refused to answer to the survey (reachability bias). From ESS paradata


data_outnic <- data.frame(data[, c(1163:1231)])
data_outnic1 <- data_outnic[, 1:27]
data_outnic1[is.na(data_outnic1)] <- "Not Applicable"

data_outnic1 %<>% 
  mutate_at(paste0('outnic', c(1:27)),
            recode, '1'='0', '2'='1', '3'= NULL, '4'= NULL, '5'= NULL, '6'= NULL, '7'= NULL, '8'= NULL,
            '9'= NULL, '10'= NULL, '11'= NULL, '12'= NULL, '13'= NULL) 

data_outnic1[data_outnic1 == 1] <- "Appointment"

eLevels <- factor(c("0", "Appointment", "Not Applicable"), levels = c(0, "Appointment", "Not Applicable"),
                 labels = c("0", "Appointment", "Not Applicable"))

data_outnic1[,1:27] <- lapply(data_outnic1[,1:27], function(x) factor(x, eLevels))

data[,1163:1189] <- data_outnic1[,1:27]

data_outnic <- data.frame(data[, c(1163:1231)])
data_outnic[,1:27] <- lapply(data_outnic[,1:27], as.numeric)

data_outnic %<>% 
  mutate_at(paste0('outnic', c(1:27)),
            recode, '1'= 0, '2'= 1, '3' = NULL) 

data_outnic$refusals <- rowSums(data_outnic[, 1:69], na.rm = TRUE)

data$refusals <- data_outnic$refusals


# Voting and abstention 

data$vote[data$vote == 3] <- NA
data$vote[data$vote == 2] <- 0



# Encoding regions 

data$regionnum <- data$region

data %<>% 
  mutate_at(vars(regionnum),
            recode, "ES11" = 1, "ES12" = 2, "ES13" = 3, "ES21" = 4, "ES22" = 5, "ES23" = 6, "ES24" = 7,
            "ES30" = 8, "ES41" = 9, "ES42" = 10, "ES43" = 11, "ES51" = 12, "ES52" = 13, "ES53" = 14,
            "ES61" = 15, "ES62" = 16, "ES63" = 17, "ES70" = 18)

data$regionnum <- factor(data$regionnum, levels = c(1:18),
                         labels = c("ES11", "ES12", "ES13", "ES21", "ES22", "ES23", "ES24",
                                    "ES30", "ES41", "ES42", "ES43", "ES51", "ES52", "ES53",
                                    "ES61", "ES62", "ES63", "ES70"))



# Identifying regions that are only present in D_exposure_barcenas = 1

data$region_treatment <- 0



data_important <- data %>%
  select(D_exposure_barcenas, regionnum, region_treatment) %>%
  group_by(regionnum) %>%
  summarise(sum_D_exposure_barcenas = sum(D_exposure_barcenas, na.rm = TRUE),
            average_D_exposure_barcenas = mean(D_exposure_barcenas, na.rm = TRUE)) %>%
  mutate(region_treatment = case_when(
    average_D_exposure_barcenas < 1 ~ 1,
    average_D_exposure_barcenas >= 1 ~ 0
  ))

x <- which(data$regionnum == "ES11")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES12")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES13")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES21")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES30")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES41")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES42")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES51")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES52")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES53")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES62")
data$region_treatment[x] <- 1

x <- which(data$regionnum == "ES70")
data$region_treatment[x] <- 1


# UPDATED PORTION

new_df <- data
new_df <- new_df[,-c(1340,1343)]

new_df2 <- new_df[!(new_df$prtvtces == "Problem factor"),]

#write.csv(new_df2, "F:\\Assignments\\75\\new data.csv", row.names = F)

