library(xml2)
library(rvest)
library(purrr)


Sys.sleep(15)


# Read the HTML file
url1 <- 'D:\\Projects\\Web scraping, Data Cleaning and REGEX\\data\\rawdata\\angus_deaton_GoogleScholarCitations.html'

scrape1 <- function(url1){
paperName <- url1 %>% 
  read_html() %>%
  html_nodes(".gsc_a_at") %>%
  html_text() %>%
  as.data.frame()

researcher <- url1 %>% 
  read_html() %>%
  html_nodes(".gsc_a_at+ .gs_gray") %>%
  html_text() %>%
  as.data.frame()
  
journal <- url1 %>% 
  read_html() %>%
  html_nodes(".gs_gray+ .gs_gray") %>%
  html_text() %>%
  as.data.frame()


citations <- url1 %>% 
  read_html() %>%
  html_nodes(".gsc_a_ac") %>%
  html_text() %>%
  as.data.frame()


year <- url1 %>% 
  read_html() %>%
  html_nodes(".gsc_a_hc") %>%
  html_text() %>%
  as.data.frame()

data_final <- cbind(paperName,researcher,journal,citations,year)
names(data_final) <- c("paperName", "researcher", "journal", "citations", "year")
data_final <- as.data.frame(data_final)
                               
}

data_scholarA <- map_df(url1, scrape1)





url2 <- 'D:\\Projects\\Web scraping, Data Cleaning and REGEX\\data\\rawdata\\jean_tirole_GoogleScholarCitations.html'

scrape2 <- function(url2){
  paperName <- url2 %>% 
    read_html() %>%
    html_nodes(".gsc_a_at") %>%
    html_text() %>%
    as.data.frame()
  
  researcher <- url2 %>% 
    read_html() %>%
    html_nodes(".gsc_a_at+ .gs_gray") %>%
    html_text() %>%
    as.data.frame()
  
  journal <- url2 %>% 
    read_html() %>%
    html_nodes(".gs_gray+ .gs_gray") %>%
    html_text() %>%
    as.data.frame()
  
  
  citations <- url2 %>% 
    read_html() %>%
    html_nodes(".gsc_a_ac") %>%
    html_text() %>%
    as.data.frame()
  
  
  year <- url2 %>% 
    read_html() %>%
    html_nodes(".gsc_a_hc") %>%
    html_text() %>%
    as.data.frame()
  
  data_final <- cbind(paperName,researcher,journal,citations,year)
  names(data_final) <- c("paperName", "researcher", "journal", "citations", "year")
  data_final <- as.data.frame(data_final)
  
}

data_scholarB <- map_df(url2, scrape2)



write.csv(data_scholarA, "D:\\Projects\\Web scraping, Data Cleaning and REGEX\\data\\cleandata\\angus_deaton_GoogleScholarCitations.csv", row.names = F)
write.csv(data_scholarB, "D:\\Projects\\Web scraping, Data Cleaning and REGEX\\data\\cleandata\\jean_tirole_GoogleScholarCitations.csv", row.names = F)


