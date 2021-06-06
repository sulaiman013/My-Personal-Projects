# Data scraping

#2011

url1 <-'https://brandirectory.com/rankings/global/2011/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2011 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank11 <- tmp[1] %>% html_text() %>% as.numeric()
  rank10 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value11 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value10 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate11 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate10 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2011 = rbind(data2011, c(rank11, rank10,company, country,
                         value11, value10, rate11, rate10))
  data2011 <- as.data.frame(data2011)
}

data2011 <- data2011[1:100,]
data2011$Year <- 2011
colnames(data2011) = c("Rank", "RankLastYear", "Company", "Country",
                    "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2011 <- data2011[,c(9,1,2,3,4,5,6,7,8)]



#2012

url2 <-'https://brandirectory.com/rankings/global/2012/table'
webpage <- read_html(url2)
xdata <- webpage %>% html_nodes("tbody tr")
data2012 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank12 <- tmp[1] %>% html_text() %>% as.numeric()
  rank11 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value12 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value11 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate12 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate11 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2012 = rbind(data2012, c(rank12, rank11,company, country,
                               value12, value11, rate12, rate11))
  data2012 <- as.data.frame(data2012)
}

data2012 <- data2012[1:100,]
data2012$Year <- 2012
colnames(data2012) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2012 <- data2012[,c(9,1,2,3,4,5,6,7,8)]

#2013

url1 <-'https://brandirectory.com/rankings/global/2013/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2013 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank13 <- tmp[1] %>% html_text() %>% as.numeric()
  rank12 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value13 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value12 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate13 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate12 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2013 = rbind(data2013, c(rank13, rank12,company, country,
                               value13, value12, rate13, rate12))
  data2013 <- as.data.frame(data2013)
}

data2013 <- data2013[1:100,]
data2013$Year <- 2013
colnames(data2013) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2013 <- data2013[,c(9,1,2,3,4,5,6,7,8)]

#2014

url1 <-'https://brandirectory.com/rankings/global/2014/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2014 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank14 <- tmp[1] %>% html_text() %>% as.numeric()
  rank13 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value14 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value13 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate14 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate13 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2014 = rbind(data2014, c(rank14, rank13,company, country,
                               value14, value13, rate14, rate13))
  data2014 <- as.data.frame(data2014)
}

data2014 <- data2014[1:100,]
data2014$Year <- 2014
colnames(data2014) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2014 <- data2014[,c(9,1,2,3,4,5,6,7,8)]

#2015

url1 <-'https://brandirectory.com/rankings/global/2015/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2015 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank15 <- tmp[1] %>% html_text() %>% as.numeric()
  rank14 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value15 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value14 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate15 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate14 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2015 = rbind(data2015, c(rank15, rank14,company, country,
                               value15, value14, rate15, rate14))
  data2015 <- as.data.frame(data2015)
}

data2015 <- data2015[1:100,]
data2015$Year <- 2015
colnames(data2015) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2015 <- data2015[,c(9,1,2,3,4,5,6,7,8)]

#2016

url1 <-'https://brandirectory.com/rankings/global/2016/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2016 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank16 <- tmp[1] %>% html_text() %>% as.numeric()
  rank15 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value16 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value15 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate16 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate15 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2016 = rbind(data2016, c(rank16, rank15,company, country,
                               value16, value15, rate16, rate15))
  data2016 <- as.data.frame(data2016)
}

data2016 <- data2016[1:100,]
data2016$Year <- 2016
colnames(data2016) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2016 <- data2016[,c(9,1,2,3,4,5,6,7,8)]

#2017

url1 <-'https://brandirectory.com/rankings/global/2017/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2017 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank17 <- tmp[1] %>% html_text() %>% as.numeric()
  rank16 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value17 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value16 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate17 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate16 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2017 = rbind(data2017, c(rank17, rank16,company, country,
                               value17, value16, rate17, rate16))
  data2017 <- as.data.frame(data2017)
}

data2017 <- data2017[1:100,]
data2017$Year <- 2017
colnames(data2017) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2017 <- data2017[,c(9,1,2,3,4,5,6,7,8)]

#2018

url1 <-'https://brandirectory.com/rankings/global/2018/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2018 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank18 <- tmp[1] %>% html_text() %>% as.numeric()
  rank17 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value18 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value17 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate18 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate17 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2018 = rbind(data2018, c(rank18, rank17,company, country,
                               value18, value17, rate18, rate17))
  data2018 <- as.data.frame(data2018)
}

data2018 <- data2018[1:100,]
data2018$Year <- 2018
colnames(data2018) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2018 <- data2018[,c(9,1,2,3,4,5,6,7,8)]

#2019

url1 <-'https://brandirectory.com/rankings/global/2019/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2019 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank19 <- tmp[1] %>% html_text() %>% as.numeric()
  rank18 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value19 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value18 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate19 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate18 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2019 = rbind(data2019, c(rank19, rank18,company, country,
                               value19, value18, rate19, rate18))
  data2019 <- as.data.frame(data2019)
}

data2019 <- data2019[1:100,]
data2019$Year <- 2019
colnames(data2019) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2019 <- data2019[,c(9,1,2,3,4,5,6,7,8)]

#2020

url1 <-'https://brandirectory.com/rankings/global/2020/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2020 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank20 <- tmp[1] %>% html_text() %>% as.numeric()
  rank19 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value20 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value19 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate20 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate19 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2020 = rbind(data2020, c(rank20, rank19,company, country,
                               value20, value19, rate20, rate19))
  data2020 <- as.data.frame(data2020)
}

data2020 <- data2020[1:100,]
data2020$Year <- 2020
colnames(data2020) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2020 <- data2020[,c(9,1,2,3,4,5,6,7,8)]

#2021

url1 <-'https://brandirectory.com/rankings/global/2021/table'
webpage <- read_html(url1)
xdata <- webpage %>% html_nodes("tbody tr")
data2021 = NULL
for (i in 1:length(xdata)){
  tmp <- xdata[i] %>% html_nodes("td")
  rank21 <- tmp[1] %>% html_text() %>% as.numeric()
  rank20 <- tmp[2] %>% html_text() %>% as.numeric()
  company = trimws(gsub("\n", "", tmp[3] %>% html_text()))
  country = trimws(gsub("\n", "", tmp[4] %>% html_text()))
  flag <- tmp[5] %>% html_nodes("img") %>% xml_attr("src")
  value21 <- tmp[5] %>% html_nodes("span") %>% html_text()
  value20 <- tmp[6] %>% html_nodes("span") %>% html_text()
  rate21 = trimws(gsub("\n", "", tmp[7] %>% html_text()))
  rate20 = trimws(gsub("\n", "", tmp[8] %>% html_text()))
  data2021 = rbind(data2021, c(rank21, rank20,company, country,
                               value21, value20, rate21, rate20))
  data2021 <- as.data.frame(data2021)
}

data2021 <- data2021[1:100,]
data2021$Year <- 2021
colnames(data2021) = c("Rank", "RankLastYear", "Company", "Country",
                       "Value", "ValueLastYear", "Rate", "RateLastYear", "Year")

data2021 <- data2021[,c(9,1,2,3,4,5,6,7,8)]


top100brands <- rbind(data2011,data2012,data2013,data2014,data2015,data2016,data2017,data2018,
                      data2019,data2020,data2021)

# data pre-processing

str(top100brands)
top100brands$Rank <- as.numeric(top100brands$Rank)
top100brands$RankLastYear <- as.numeric(top100brands$RankLastYear)

top100brands$Value <- gsub("[$M,]", "", top100brands$Value)
top100brands$ValueLastYear <- gsub("[$M,]", "", top100brands$ValueLastYear)

top100brands$Value <- as.numeric(top100brands$Value)
top100brands$ValueLastYear <- as.numeric(top100brands$ValueLastYear)

summary(top100brands)



