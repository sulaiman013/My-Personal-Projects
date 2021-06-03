# loading necessary packages
library(lubridate)
library(dplyr)
library(ggplot2)


# Importing the weather_dataset
weather_data <- read.csv("D:\\Projects\\Data Visualization Project (BASIC GGPLOT2)\\Hourly weather data.csv")



# observing the structure of the weather_dataset
str(weather_data)


# summary of the weather_dataset
summary(weather_data)



# Analysis example 1
# In this analysis, we are plotting a histogram of dewpoint over a year
# for both the airport's, which will show the differences in dewpoint between
# both the airport's over a year.


weather_data %>%
  ggplot(aes(x=dewp , fill = origin))+
  geom_histogram(alpha=0.8 , color = 'black')+
  labs(x = "Dewpoint(F)", y = "Count", title = "Histogram", 
       subtitle = "Dewpoint differences in two airport's over a year")+
  facet_wrap(~origin)+
  theme_minimal()



# Analysis example 2    
# In this analysis, we are plotting boxplots of wind-speed for different months,
# which will represent how wind-speed values varies by month to month.  

weather_data %>%
  ggplot(aes(y=wind_speed, x=factor(month), fill= factor(month)))+
  geom_boxplot()+
  labs(x = "Months", y = "Wind-speed(Mph)", title = "Boxplot",
       subtitle = "Wind-speed differences in two airport's for different months")+
  facet_wrap(~origin)+
  theme_minimal()



# Analysis example 3    
# In this analysis, we are plotting boxplots of relative humidity for different months and at night-time,
# this will show how humidity varies from month to month at night.   

weather_data %>%
  filter(hour <= 12) %>%
  ggplot(aes(y=humid, x=factor(month), fill=factor(month)))+
  geom_boxplot()+
  labs(x = "Months", y = "Relative Humidity(%)", title = "Boxplot",
       subtitle = "Humidity differences at night in two airport's for different months")+
  facet_wrap(~origin)+
  theme_minimal()  




# Analysis example 5   
# In this analysis, we are summarising different weather parameters, and then plotting a bar-chart of average dewpoint vs
# months which will show how dewpoint changes in different months for different airport's (variation). 

weather_data2 <- 
  weather_data %>%  
  group_by(month, origin) %>%
  summarise(Avg_dewp = mean(dewp),
            Avg_temp = mean(temp),
            Avg_humid = mean(humid),
            Avg_wind_dir = mean(wind_dir , na.rm = TRUE),
            Avg_wind_speed = mean(wind_speed , na.rm = TRUE),
            Avg_visib = mean(visib, na.rm = TRUE),
            Avg_pressure = mean(pressure, na.rm = TRUE),
            sd_dewp = sd(dewp),
            max_dewp = max(dewp),
            min_dewp = min(dewp),
            sum_dewp = sum(dewp),
            median_dewp = median(dewp),
            total = n())
View(weather_data2)  

weather_data2 %>%
  ggplot(aes(weight=Avg_dewp, x= factor(month), fill = origin))+
  geom_bar(alpha = 0.8)+
  labs(x = "Months", y = "Dewpoint(F)", title = "Bar-Chart", 
       subtitle = "Average dewpoint in different months")+
  facet_wrap(~origin)+
  theme_minimal()



# Analysis example 4    
# In this analysis, we plot scatterplot between dewpoint and pressure for
# the month march at John F Kennedy International Airport, which will show the 
# inter-relationship between the variables.

weather_data %>%
  filter(origin == "JFK", month == 3) %>%
  ggplot(aes(x=pressure, y = dewp)) +
  geom_point(alpha=0.6, color = "#357847") +
  geom_smooth(se=F, size = 0.5)+
  labs(x = "Pressure(Millibars)", y = "Dewpoint(F)", title = "Scatter-plot", 
       subtitle = "Scatter-plot showing relationship between Dewpoint and Pressure")+
  theme_minimal()



# Analysis example 6    
# In this analysis, we plot scatterplot between temperature and dewpoint 
# at night-time for different months in LaGuardia Airport, which will
# show the inter-relationship between the variables over different months of a year.

weather_data %>%
  filter(origin == "LGA", hour <= 12 ) %>%
  ggplot(aes(x=dewp, y = temp, col = factor(month))) +
  geom_point(alpha=0.8) +
  geom_smooth(se=T, size = 0.8)+
  labs(x = "Dewpoint(F)", y = "Temperature(F)", title = "Scatter-plot", 
       subtitle = "Scatter-plot showing relationship between Temperature and Dewpoint at night over different months of a year")+
  facet_wrap(~month)+
  theme_minimal()
  

# Analysis example 7   
# In this analysis, we plot a density plot for Wind speed at August month,
# and then we will show the Wind-speed differences in two airports at month of august.  

weather_data %>%
  filter(month == "8") %>%
  ggplot(aes(x=wind_speed , fill = origin)) +
  geom_density(alpha = 0.6) +
  labs(x = "Wind-Speed(mph)", y = "Density", title = "Density plot", 
       subtitle = "Differences of Wind-speed in two airport's on August")+
  theme_minimal()



# Analysis example 8   
# In this analysis, we plot a density plot for pressure in LaGuardia Airport, and then we will show the pressure differs
# by different months in LaGuardia Airport.  

weather_data %>%
  filter(origin == "LGA") %>%
  ggplot(aes(x=pressure , fill = factor(month))) +
  geom_density(alpha = 0.5) +
  labs(x = "Pressure(Millibars)", y = "Density", title = "Density plot", 
       subtitle = "Showing how pressure differs by different months in LaGuardia Airport")+
  facet_wrap(~month)+
  theme_minimal()


# Analysis example 9   
# In this analysis, at first, we are creating datetime and sorting the weatherdata3 by datetime.
# Then we plot a line graph which shows the trendline of humidity over the year at LaGuardia Airport.

weather_data3<- weather_data %>%
  mutate(date = make_date(year, month, day),
         datetime = make_datetime(year, month, day, hour)) %>%
  arrange(datetime)

weather_data3 %>%
  filter(origin == "LGA") %>%
  ggplot(aes(x = datetime, y = humid)) +
  geom_line(size = 0.8, colour = "#1f807e", alpha = 0.6) +
  labs(x = "Date-time(Mm-Yy)", y = "Relative Humidity(%)", title = "Time series plot (Humidity vs Date-time)",
       subtitle = "Trendline of Relative humidity over the year at LaGuardia Airport") +
  theme_minimal()


# Analysis example 10  
# In this analysis, we plot a line graph which shows the trendline
# of wind gust over the year at John F. Kennedy International Airport.

weather_data3 %>%
  filter(origin == "JFK") %>%
  ggplot(aes(x = datetime, y = wind_speed)) +
  geom_line(size = 0.8, colour = "#1f803a", alpha = 0.6) +
  labs(x = "Date-time(Mm-Yy)", y = "Wind Speed(mph)", title = "Time series plot (Wind speed vs Date-time)",
       subtitle = "Trendline of Wind speed over the year at John F. Kennedy International Airport") +
  theme_minimal()


# Analysis example 11 
# In this analysis, we plot a Bar-chart which shows average temperature
# over different months at John F. Kennedy International Airport.

weather_data2 %>%
  filter(origin == "JFK") %>%
  ggplot(aes(weight = Avg_temp, x= factor(month), fill = factor(month)))+
  geom_bar(alpha = 0.6)+
  labs(x = "Months", y = "Temperature(F)", title = "Bar-chart",
       subtitle = "Bars showing average temperature over different months at John F. Kennedy International Airport") +
  theme_minimal()



# Analysis example 12 
# In this analysis, we plot a scatter-plot of precipitation vs Wind-speed at november month for both Airports.

data %>%
  filter(month == 11) %>%
  ggplot(aes(y=precip, x = wind_speed, col= origin)) +
  geom_point(alpha=0.8) +
  labs(x = "Wind-speed(mph)", y = "Precipitation(inches)", title = "Scatter-plot (Precipitation vs Wind-speed)",
       subtitle = "scatter-plot of Precipitation vs Wind-speed at November for both Airport's") +
  facet_wrap(~origin)



# Analysis example 13
# In this analysis, we are plotting a frequency polygon of wind-speed for different months
# at LaGuardia Airport, which will show the distribution of wind-speed at LaGuardia Airport over months.

weather_data %>%
  filter(origin == "LGA") %>%
  ggplot(aes(x=wind_speed , col = factor(month)))+
  geom_freqpoly(size = 1, alpha=0.6 )+
  labs(x = "Wind-Speed(mph)", y = "Count", title = "Frequency Polygon", 
       subtitle = "Distribution of wind-speed at LaGuardia Airport over months")+
  theme_minimal()


# Analysis example 14
# In this analysis, we are plotting a frequency polygon of Relative humidity at night for the month january and both the airport's,
# which will represent the differences in relative humidity at night in january and between both the airport's.

weather_data %>%
  filter(month == 1, hour <= 12) %>%
  ggplot(aes(x=humid))+
  geom_freqpoly(size = 1, alpha=0.6, color = "#3bc72e" )+
  labs(x = "Relative Humidity(%)", y = "Count", title = "Frequency Polygon", 
       subtitle = "Showing differences in relative humidity at night in january and between both the airport's")+
  facet_wrap(~origin)+
  theme_minimal() 




