---
title: "Web Scraping and Data-Visualization"
date: '2021-04-14'
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Loading necessary libraries
```{r message=FALSE, warning=FALSE}
library(rvest)
library(dplyr)
library(highcharter) 
library(xml2)
library(ggplot2)
library(gganimate)
library(animation)
library(magick)
library(viridis)
library(plotly)
library(hrbrthemes)
library(dygraphs)
library(curl)
```

## Set high-charter options
```{r message=FALSE, warning=FALSE}
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))
```

## Data web-scraping
```{r message=FALSE, warning=FALSE}
source("Data Scraping.R")
```

## Interactive Pie-Chart
```{r message=FALSE, warning=FALSE}
pie_data <- aggregate(Company ~ Country, data = data2021, FUN = length)  

pie_inter <- pie_data %>%
  hchart(
    "pie", hcaes(x = Country, y = Company),
    name = "Number of Brands by Country in 2021"
  )

pie_inter
```

## animated pie-chart
```{r message=FALSE, warning=FALSE}
anim_pie_data <- aggregate(Company ~ Country + Year, data = top100brands, FUN = length)

img <- image_graph(600, 600, res = 96)

for (i in unique(anim_pie_data$Year)) {
  p = ggplot(anim_pie_data[anim_pie_data$Year==i,], aes(x="", y=Company, fill= Country, frame=Year))+
    geom_bar(width = 1, stat = "identity") + 
    facet_grid(~Year) +
    coord_polar("y", start=0) 
  print(p)
}

dev.off()
animation <- image_animate(img, fps = 2, optimize = TRUE)
print(animation)
```

## Bubble Chart
```{r message=FALSE, warning=FALSE}
# data importing and pre-processing

datax <- read.csv("D:\\Projects\\Web Scraping and Data Visualization\\book3.csv")
datax <- datax[1:100,]

str(datax)

datax$RankLastYear <- as.numeric(datax$RankLastYear)
datax$Value <- as.numeric(datax$Value)
datax$ValueLastYear <- as.numeric(datax$ValueLastYear)
colnames(datax) = c("Company", "Rank", "RankLastYear", "Value",
                    "ValueLastYear", "Rate", "RateLastYear", "Year", "Sector")
summary(datax)


# plot

interactive_bubblechart <- datax %>% 
  hchart(
    'scatter', hcaes(x = RankLastYear, y = Rank, size = Value, group = Sector),
    maxSize = "5%"
  )

interactive_bubblechart %>%
  hc_title(
    text = "Interactive Bubble Chart",
    style = list(fontWeight = "bold", fontSize = "15px"),
    align = "center"
  ) %>% 
  hc_subtitle(
    text = "Year 2021", 
    style = list(fontWeight = "bold", fontSize = "13px"),
    align = "center"
  ) %>%
  hc_xAxis(title = list(text = "Ranking 2020")) %>%
  hc_yAxis(title = list(text = "Ranking 2021")) %>%
  hc_legend(align = "right", verticalAlign = "middle", 
            layout = "vertical") 
```

## Interactive time-series plots
```{r message=FALSE, warning=FALSE}
# Data Pre-processing
int_time_series <- top100brands %>%
  select(Company, Year, Value) %>%
  filter(Company %in% c("Apple", "Google", "Amazon","Amazon.com", "Microsoft"))

int_time_series_wide <- reshape(int_time_series, idvar = "Year", timevar = "Company", direction = "wide")
int_time_series_wide$Value.Amazon <- paste(int_time_series_wide$Value.Amazon,
                                           int_time_series_wide$Value.Amazon.com, sep="")

int_time_series_wide$Value.Amazon <- gsub("[NA]", "", int_time_series_wide$Value.Amazon)
int_time_series_wide <- int_time_series_wide[-6]
int_time_series_wide$Value.Amazon <- as.numeric(int_time_series_wide$Value.Amazon)

# plot

dygraph(int_time_series_wide) %>%
  dySeries("Value.Amazon", label = "Brand Value of Amazon") %>%
  dySeries("Value.Apple", label = "Brand Value of Apple") %>%
  dySeries("Value.Google", label = "Brand Value of Google") %>%
  dySeries("Value.Microsoft", label = "Brand Value of Microsoft") %>%
  dyRangeSelector(height = 20)
```



