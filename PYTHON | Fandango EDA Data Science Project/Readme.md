# Fandango EDA Data Science Project

## Introduction

Welcome to the Fandango EDA Data Science Project, a comprehensive opportunity to apply your skills in data science. This project delves into the analysis of data from the year 2015, focusing on the domain of movie ratings and ticket sales.

### Project Focus

- **Real-World Application**: Engage with real-world data to apply your theoretical knowledge in practical data analysis scenarios.
- **Data-Driven Decision Making**: Collect, store, and analyze data to make informed conclusions.
- **Critical Thinking**: Address key questions about data relationships and implications.

### Technical Tools

- **Jupyter Notebook**: For coding and data analysis.
- **NumPy & Pandas**: Essential for data manipulation.
- **Matplotlib & Seaborn**: Tools for visualizing data insights.

### Central Question

- **Conflict of Interest Investigation**: Investigate whether there is a conflict of interest for a website like Fandango that both sells movie tickets and displays review ratings.

### Case Study: 2015

- **Dual Role of Fandango**: Explore Fandango's role in selling movie tickets and displaying movie ratings, focusing on potential biases.
- **Case Example**: "Taken 3" and its rating on Fandango will be analyzed to assess discrepancies between ratings and movie quality.

### Analytical Approach

- **Rating Discrepancy Analysis**: Compare Fandango's displayed STARS and the actual RATING for movies to uncover any inconsistencies.
- **Comparative Review Analysis**: Evaluate how Fandango’s ratings stack up against other review websites.
- **Data Scraping and Analysis**: Employ web scraping techniques to gather comprehensive review data for analysis.

## Executive Summary
This project aims to investigate Fandango's movie rating system, particularly examining if there's a discrepancy between the ratings displayed on Fandango and the actual ratings, and how these ratings compare with other movie review sites. The analysis is rooted in data from 2015, incorporating datasets that include ratings from Fandango, Rotten Tomatoes, Metacritic, and IMDB.

## Methodology
1. **Data Collection & Preparation**: 
   - Utilized datasets: `fandango_scrape.csv` for Fandango's ratings and `all_sites_scores.csv` for other sites.
   - Performed data cleaning and preparation, including normalization of ratings for uniformity across different scales.

2. **Exploratory Data Analysis (EDA)**: 
   - Initial exploration using Pandas to understand the datasets' structure and summary statistics.
   - Created new columns where necessary, e.g., extracting the year from movie titles.

3. **Data Analysis & Visualization**:
   - Analyzed the correlation between a film's popularity and its ratings on Fandango.
   - Visualized the distribution of movie counts per year and the highest-rated movies.
   - Investigated movies with zero votes to filter out unreviewed films.

4. **Comparative Analysis**:
   - Merged Fandango's dataset with the dataset containing ratings from other review sites.
   - Conducted comparative analysis to observe discrepancies and patterns.

5. **Statistical Analysis & Interpretation**:
   - Performed normalization of ratings from all sites to ensure comparability.
   - Analyzed the distribution of ratings across different sites, focusing on Fandango's ratings.

## Key Findings
- **Rating Discrepancies**: There is a notable discrepancy between Fandango's displayed ratings and the actual ratings.
- **Comparison with Other Sites**: Fandango's ratings are consistently higher compared to other sites like Rotten Tomatoes, Metacritic, and IMDB.
- **Distribution of Ratings**: Fandango shows an uneven distribution, leaning towards higher ratings, whereas other sites have more balanced or critical distributions.
- **Case Study - "Taken 3"**: The analysis of "Taken 3" exemplifies how Fandango's ratings can mislead compared to other platforms.

## Implications
The findings suggest a potential bias in Fandango's rating system, where movies are rated more favorably. This raises questions about the reliability and integrity of online movie ratings, especially on platforms that also sell movie tickets.

## Conclusion
This data-driven analysis highlights the importance of critical evaluation of online rating systems. It underscores the need for transparency and reliability in how movie ratings are displayed and suggests consumers should consult multiple sources when assessing the quality of a film.
