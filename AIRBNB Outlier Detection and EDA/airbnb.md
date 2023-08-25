# Airbnb Data Analysis and Outlier Detection Project

## Introduction

The way people experience cities around the world has been completely transformed by Airbnb in the fields of contemporary travel and hospitality. Airbnb provides a variety of lodging options, ranging from comfortable private rooms to roomy entire apartments, as an online marketplace that connects hosts with travelers. The European Booking Dataset, a thorough compilation of information from nine renowned cities—Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, Paris, Rome, and Vienna—is the subject of this project. The dataset has undergone meticulous curation and cleaning, making it a useful tool for analysis and insight.

This project's main goals are to perform exploratory data analysis (EDA), identify outliers in the dataset, and determine any possible causal links between outliers and guest satisfaction.  In order to identify patterns, trends, and elements that affect visitors' overall experiences, we will combine data from various cities and Airbnb stays. We use SQL queries within the Snowflake environment to accomplish this, allowing us to quickly process and analyze large amounts of data.

## Dataset Overview

The dataset comprises several key variables that shed light on different dimensions of Airbnb stays. These variables include:

- **City**: The name of the city in which the Airbnb stay is located.
- **Price**: The price of the Airbnb stay.
- **Day**: Indicates whether the stay falls on a weekday or weekend.
- **Room Type**: The type of Airbnb accommodation, such as an entire apartment, private room, or shared room.
- **Shared Room**: Indicates whether the room is shared by multiple guests.
- **Private Room**: Indicates the availability of a private room within the accommodation.
- **Person Capacity**: The maximum number of individuals the accommodation can host.
- **Superhost**: A binary indicator of whether the host is classified as a superhost.
- **Multiple Rooms**: Indicates if the Airbnb offers multiple rooms (2-4 rooms).
- **Business**: A binary indicator of whether the accommodation offers more than four listings, potentially suggesting a business-oriented host.
- **Cleaningness Rating**: A rating reflecting the cleanliness of the place, as provided by guests.
- **Guest Satisfaction**: The satisfaction score left by guests after their stay.
- **Bedrooms**: The number of bedrooms available in the facility.
- **City Center (km)**: The distance from the accommodation to the city center.
- **Metro Distance (km)**: The distance from the accommodation to the nearest metro service.
- **Attraction Index**: An index measuring the proximity of attractions to the accommodation.
- **Normalized Attraction Index**: A normalized version of the attraction index.
- **Restaurant Index**: An index measuring the proximity of restaurants to the accommodation.
- **Normalized Restaurant Index**: A normalized version of the restaurant index.

## Project Goals

1. **Exploratory Data Analysis (EDA)**: Before delving into outlier detection and causal relationship establishment, it's crucial to understand the data. Through visualization and statistical analysis, we'll uncover insights such as price distributions, room type preferences, and location-based trends.

2. **Outlier Detection**: Identifying outliers can provide valuable insights into unusual occurrences or exceptional cases within the dataset. By applying appropriate techniques, we can pinpoint instances that deviate significantly from the norm, potentially shedding light on hidden factors affecting guest satisfaction.

3. **Causal Relationship with Guest Satisfaction**: Establishing causal relationships involves examining factors that might influence guest satisfaction scores. Through rigorous analysis, we'll explore correlations and potentially infer causal links between variables such as cleanliness ratings, distance to city center, and room types.
