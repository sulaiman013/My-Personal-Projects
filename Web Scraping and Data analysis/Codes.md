Web Scraping and Data Analysis
================

## Loading necessary libraries

``` r
library(tidyverse)
library(stringr)
library(R.utils)
library(rvest)
library(xml2)
library(tm)
```

## Web scraping the billboard hot 100 page

``` r
an_url="https://www.billboard.com/charts/hot-100"
an = read_html(an_url)

hot100.rank = an %>% 
  html_nodes('.chart-element__rank__number') %>% 
  html_text()

hot100.artist = an %>% 
  html_nodes('.text--truncate.color--secondary') %>% 
  html_text()

hot100.title = an %>% 
  html_nodes('.color--primary') %>% 
  html_text()
hot100.title =hot100.title[-c(1,2)]


df <- data.frame(hot100.rank, hot100.artist, hot100.title)
```

## Observing number of tracks of each artist

``` r
no_of_tracks <- table(df$hot100.artist)
head(no_of_tracks)
```

    ## 
    ##              24kGoldn Featuring iann dior 
    ##                                         1 
    ##                     42 Dugg & Roddy Ricch 
    ##                                         1 
    ##                  42 Dugg Featuring Future 
    ##                                         1 
    ## A Boogie Wit da Hoodie Featuring Lil Durk 
    ##                                         1 
    ##                                       AJR 
    ##                                         1 
    ##                             Ariana Grande 
    ##                                         1

## Creating a function that will return all the songs sang by a specific artist

``` r
artist.func = function(write){
  
  if(write == "List"){
    result= df$hot100.artist
    return(result)
  } 
  if(nchar(write, type="chars")){
    df_song = df[ df$hot100.artist==write, ]
    result = df_song$hot100.title
    }
  else{
    result = "Invalid Input"
  }
  return(result)
}

write = "The Weeknd"

artist.func(write)
```

    ## [1] "Blinding Lights"

## Web scraping another page, cleaning and making a data frame

``` r
an_url2="https://www.chewy.com/b/dry-food-294"
an2 = read_html(an_url2)

brand_name = an2 %>% 
  html_nodes('h2 strong') %>% 
  html_text()
brand_name = trimws(brand_name, which = c("both"), whitespace = "[ :\t\r\n]")
brand_name
```

    ##  [1] "Purina Pro Plan"             "Blue Buffalo"               
    ##  [3] "Taste of the Wild"           "Purina Pro Plan"            
    ##  [5] "Hill's Science Diet"         "Taste of the Wild"          
    ##  [7] "Bundle"                      "Bundle"                     
    ##  [9] "Hill's Science Diet"         "Purina ONE"                 
    ## [11] "Purina ONE"                  "Bundle"                     
    ## [13] "Bundle"                      "Purina Pro Plan"            
    ## [15] "Royal Canin Veterinary Diet" "Bundle"                     
    ## [17] "Blue Buffalo"                "Bundle"                     
    ## [19] "Iams"                        "Rachael Ray Nutrish"        
    ## [21] "Purina Pro Plan"             "Bundle"                     
    ## [23] "Blue Buffalo"                "Pedigree"                   
    ## [25] "Iams"                        "Purina ONE"                 
    ## [27] "Blue Buffalo"                "Diamond"                    
    ## [29] "Bundle"                      "Bundle"                     
    ## [31] "Bundle"                      "Bundle"                     
    ## [33] "Purina ONE"                  "Hill's Science Diet"        
    ## [35] "Bundle"                      "Purina Pro Plan"

``` r
prod_name = an2 %>% 
  html_nodes('.content h2') %>% 
  html_text()
prod_name
```

    ##  [1] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                             
    ##  [2] "\n        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                           
    ##  [3] "\n        \n          \n          \n          \n            Taste of the Wild\n             High Prairie Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                        
    ##  [4] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                      
    ##  [5] "\n        \n          \n          \n          \n            Hill's Science Diet\n             Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                
    ##  [6] "\n        \n          \n          \n          \n            Taste of the Wild\n             Pacific Stream Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                      
    ##  [7] "\n        \n          \n            Bundle: \n            Taste of the Wild Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                    
    ##  [8] "\n        \n          \n            Bundle: \n            Taste of the Wild High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [9] "\n        \n          \n          \n          \n            Hill's Science Diet\n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                            
    ## [10] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                  
    ## [11] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                             
    ## [12] "\n        \n          \n            Bundle: \n            Purina ONE SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                           
    ## [13] "\n        \n          \n            Bundle: \n            Purina Pro Plan Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
    ## [14] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                         
    ## [15] "\n        \n          \n          \n          \n            Royal Canin Veterinary Diet\n             Hydrolyzed Protein Adult HP Dry Dog Food, 25.3-lb bag\n          \n        \n      "                                                                                        
    ## [16] "\n        \n          \n            Bundle: \n            Purina Pro Plan Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "
    ## [17] "\n        \n          \n          \n          \n            Blue Buffalo\n             Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag\n          \n        \n      "                                                                                                
    ## [18] "\n        \n          \n            Bundle: \n            Purina ONE SmartBlend Large Breed Puppy Formula Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                         
    ## [19] "\n        \n          \n          \n          \n            Iams\n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                           
    ## [20] "\n        \n          \n          \n          \n            Rachael Ray Nutrish\n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                
    ## [21] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                         
    ## [22] "\n        \n          \n            Bundle: \n            Diamond Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                 
    ## [23] "\n        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                         
    ## [24] "\n        \n          \n          \n          \n            Pedigree\n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                                         
    ## [25] "\n        \n          \n          \n          \n            Iams\n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                          
    ## [26] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                                
    ## [27] "\n        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                         
    ## [28] "\n        \n          \n          \n          \n            Diamond\n             Naturals Chicken & Rice Formula All Life Stages Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                          
    ## [29] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "              
    ## [30] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                          
    ## [31] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [32] "\n        \n          \n            Bundle: \n            Purina ONE True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                    
    ## [33] "\n        \n          \n          \n          \n            Purina ONE\n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                           
    ## [34] "\n        \n          \n          \n          \n            Hill's Science Diet\n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                        
    ## [35] "\n        \n          \n            Bundle: \n            Purina Pro Plan Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                  
    ## [36] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "

``` r
prod_name = trimws(prod_name, which = c("both"), whitespace = "[:\t\r\n]")
prod_name
```

    ##  [1] "        \n          \n          \n          \n            Purina Pro Plan\n             Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                             
    ##  [2] "        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                           
    ##  [3] "        \n          \n          \n          \n            Taste of the Wild\n             High Prairie Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                        
    ##  [4] "        \n          \n          \n          \n            Purina Pro Plan\n             Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                      
    ##  [5] "        \n          \n          \n          \n            Hill's Science Diet\n             Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                
    ##  [6] "        \n          \n          \n          \n            Taste of the Wild\n             Pacific Stream Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                      
    ##  [7] "        \n          \n            Bundle: \n            Taste of the Wild Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                    
    ##  [8] "        \n          \n            Bundle: \n            Taste of the Wild High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [9] "        \n          \n          \n          \n            Hill's Science Diet\n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                            
    ## [10] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                  
    ## [11] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                             
    ## [12] "        \n          \n            Bundle: \n            Purina ONE SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                           
    ## [13] "        \n          \n            Bundle: \n            Purina Pro Plan Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
    ## [14] "        \n          \n          \n          \n            Purina Pro Plan\n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                         
    ## [15] "        \n          \n          \n          \n            Royal Canin Veterinary Diet\n             Hydrolyzed Protein Adult HP Dry Dog Food, 25.3-lb bag\n          \n        \n      "                                                                                        
    ## [16] "        \n          \n            Bundle: \n            Purina Pro Plan Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "
    ## [17] "        \n          \n          \n          \n            Blue Buffalo\n             Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag\n          \n        \n      "                                                                                                
    ## [18] "        \n          \n            Bundle: \n            Purina ONE SmartBlend Large Breed Puppy Formula Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                         
    ## [19] "        \n          \n          \n          \n            Iams\n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                           
    ## [20] "        \n          \n          \n          \n            Rachael Ray Nutrish\n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                
    ## [21] "        \n          \n          \n          \n            Purina Pro Plan\n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                         
    ## [22] "        \n          \n            Bundle: \n            Diamond Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                 
    ## [23] "        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                         
    ## [24] "        \n          \n          \n          \n            Pedigree\n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                                         
    ## [25] "        \n          \n          \n          \n            Iams\n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                          
    ## [26] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                                
    ## [27] "        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                         
    ## [28] "        \n          \n          \n          \n            Diamond\n             Naturals Chicken & Rice Formula All Life Stages Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                          
    ## [29] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "              
    ## [30] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                          
    ## [31] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [32] "        \n          \n            Bundle: \n            Purina ONE True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                    
    ## [33] "        \n          \n          \n          \n            Purina ONE\n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                           
    ## [34] "        \n          \n          \n          \n            Hill's Science Diet\n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                        
    ## [35] "        \n          \n            Bundle: \n            Purina Pro Plan Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                  
    ## [36] "        \n          \n          \n          \n            Purina Pro Plan\n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "

``` r
prod_name = removeWords(prod_name, brand_name)
prod_name
```

    ##  [1] "        \n          \n          \n          \n            \n             Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                       
    ##  [2] "        \n          \n          \n          \n            \n             Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                  
    ##  [3] "        \n          \n          \n          \n            \n             High Prairie Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                    
    ##  [4] "        \n          \n          \n          \n            \n             Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                
    ##  [5] "        \n          \n          \n          \n            \n             Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                              
    ##  [6] "        \n          \n          \n          \n            \n             Pacific Stream Grain-Free Dry Dog Food, 28-lb bag\n          \n        \n      "                                                                                                  
    ##  [7] "        \n          \n            : \n             Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [8] "        \n          \n            : \n             High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                        
    ##  [9] "        \n          \n          \n          \n            \n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                          
    ## [10] "        \n          \n          \n          \n            \n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                       
    ## [11] "        \n          \n          \n          \n            \n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                  
    ## [12] "        \n          \n            : \n             SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                      
    ## [13] "        \n          \n            : \n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
    ## [14] "        \n          \n          \n          \n            \n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                   
    ## [15] "        \n          \n          \n          \n            \n             Hydrolyzed Protein Adult HP Dry Dog Food, 25.3-lb bag\n          \n        \n      "                                                                                              
    ## [16] "        \n          \n            : \n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "
    ## [17] "        \n          \n          \n          \n            \n             Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag\n          \n        \n      "                                                                                       
    ## [18] "        \n          \n            : \n             SmartBlend Large Breed Puppy Formula Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                    
    ## [19] "        \n          \n          \n          \n            \n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                          
    ## [20] "        \n          \n          \n          \n            \n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                              
    ## [21] "        \n          \n          \n          \n            \n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                   
    ## [22] "        \n          \n            : \n             Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "         
    ## [23] "        \n          \n          \n          \n            \n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                
    ## [24] "        \n          \n          \n          \n            \n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                            
    ## [25] "        \n          \n          \n          \n            \n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                         
    ## [26] "        \n          \n          \n          \n            \n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                     
    ## [27] "        \n          \n          \n          \n            \n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                
    ## [28] "        \n          \n          \n          \n            \n             Naturals Chicken & Rice Formula All Life Stages Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                            
    ## [29] "        \n          \n            : \n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [30] "        \n          \n            : \n             Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                       
    ## [31] "        \n          \n            : \n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "        
    ## [32] "        \n          \n            : \n             True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                               
    ## [33] "        \n          \n          \n          \n            \n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                
    ## [34] "        \n          \n          \n          \n            \n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                      
    ## [35] "        \n          \n            : \n             Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                  
    ## [36] "        \n          \n          \n          \n            \n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "

``` r
prod_name = trimws(prod_name, which = c("both"), whitespace = "[ :\t\r\n]")
prod_name
```

    ##  [1] "Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag"                                                                     
    ##  [2] "Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag"                                                                
    ##  [3] "High Prairie Grain-Free Dry Dog Food, 28-lb bag"                                                                                                  
    ##  [4] "Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag"                                                                              
    ##  [5] "Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag"                                                                            
    ##  [6] "Pacific Stream Grain-Free Dry Dog Food, 28-lb bag"                                                                                                
    ##  [7] "Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats"                      
    ##  [8] "High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats"                        
    ##  [9] "Adult Large Breed Dry Dog Food, 35-lb bag"                                                                                                        
    ## [10] "SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag"                                                                                     
    ## [11] "SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag"                                                                                
    ## [12] "SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                                                      
    ## [13] "Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                            
    ## [14] "Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…"                                                                 
    ## [15] "Hydrolyzed Protein Adult HP Dry Dog Food, 25.3-lb bag"                                                                                            
    ## [16] "Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats"
    ## [17] "Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag"                                                                                     
    ## [18] "SmartBlend Large Breed Puppy Formula Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats"                    
    ## [19] "ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag"                                                                                        
    ## [20] "Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag"                                                                                            
    ## [21] "Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…"                                                                 
    ## [22] "Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats"         
    ## [23] "Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…"                                                              
    ## [24] "Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …"                                                          
    ## [25] "ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag"                                                                                       
    ## [26] "SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag"                                                                                   
    ## [27] "Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…"                                                              
    ## [28] "Naturals Chicken & Rice Formula All Life Stages Dry Dog Food, 40-lb bag"                                                                          
    ## [29] "Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"           
    ## [30] "Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"                       
    ## [31] "Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"        
    ## [32] "True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                               
    ## [33] "True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag"                                                              
    ## [34] "Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag"                                                                                    
    ## [35] "Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                                                  
    ## [36] "Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag"

``` r
price.auto = an2 %>%
  html_nodes('.product-info') %>%
  map_chr(~{
    autoprice <- .x %>% 
      html_nodes('.autoship strong') %>% 
      html_text2()
    
    if(length(autoprice) == 0){
      autoprice <- NA
    }
    
    return(autoprice)
 }) 

price.auto
```

    ##  [1] "$49.86" "$47.48" "$49.39" "$47.48" "$57.94" "$49.39" NA       NA      
    ##  [9] "$52.24" "$36.42" "$30.45" NA       NA       "$64.58" "$99.74" "$52.99"
    ## [17] "$51.14" "$35.43" "$30.06" "$37.61" "$49.86" "$38.28" "$47.48" NA      
    ## [25] "$29.91" "$32.29" "$50.33" "$35.14" NA       NA       NA       NA      
    ## [33] "$42.65" "$57.94" NA       "$49.86"

``` r
price.auto = trimws(price.auto, which = c("both"), whitespace = "[ \t\r\n]")
price.auto
```

    ##  [1] "$49.86" "$47.48" "$49.39" "$47.48" "$57.94" "$49.39" NA       NA      
    ##  [9] "$52.24" "$36.42" "$30.45" NA       NA       "$64.58" "$99.74" "$52.99"
    ## [17] "$51.14" "$35.43" "$30.06" "$37.61" "$49.86" "$38.28" "$47.48" NA      
    ## [25] "$29.91" "$32.29" "$50.33" "$35.14" NA       NA       NA       NA      
    ## [33] "$42.65" "$57.94" NA       "$49.86"

``` r
price.orig = an2 %>% 
  html_nodes('.price strong') %>% 
  html_text()
price.orig = trimws(price.orig, which = c("both"), whitespace = "[ \t\r\n]")
price.orig
```

    ##  [1] "$52.48"  "$49.98"  "$51.99"  "$49.98"  "$60.99"  "$51.99"  "$54.59" 
    ##  [8] "$54.59"  "$54.99"  "$38.34"  "$32.05"  "$49.98"  "$79.62"  "$67.98" 
    ## [15] "$104.99" "$55.78"  "$53.83"  "$37.29"  "$31.64"  "$39.59"  "$52.48" 
    ## [22] "$40.29"  "$49.98"  "$19.94"  "$31.48"  "$33.99"  "$52.98"  "$36.99" 
    ## [29] "$56.95"  "$53.95"  "$53.95"  "$56.53"  "$44.89"  "$60.99"  "$64.12" 
    ## [36] "$52.48"

``` r
num_review = an2 %>%
  html_nodes('.product-info') %>%
  map_chr(~{
    rating <- .x %>% 
      html_nodes('.item-rating span') %>% 
      html_text2()
    
    if(length(rating) == 0){
      rating <- NA
    }
    
    return(rating)
 }) 

num_review
```

    ##  [1] "2714" "2414" "3516" "1634" "1101" "2727" NA     NA     "565"  "983" 
    ## [11] "1188" NA     NA     "1109" "1093" "1"    "1321" NA     "848"  "1467"
    ## [21] "790"  NA     "1165" "530"  "578"  "578"  "819"  "710"  NA     NA    
    ## [31] NA     NA     "1034" "545"  NA     "484"

``` r
df2 <- data.frame(brand_name, prod_name, price.auto, price.orig, num_review)
head(df2)
```

    ##            brand_name
    ## 1     Purina Pro Plan
    ## 2        Blue Buffalo
    ## 3   Taste of the Wild
    ## 4     Purina Pro Plan
    ## 5 Hill's Science Diet
    ## 6   Taste of the Wild
    ##                                                                           prod_name
    ## 1      Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag
    ## 2 Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 3                                   High Prairie Grain-Free Dry Dog Food, 28-lb bag
    ## 4               Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag
    ## 5             Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag
    ## 6                                 Pacific Stream Grain-Free Dry Dog Food, 28-lb bag
    ##   price.auto price.orig num_review
    ## 1     $49.86     $52.48       2714
    ## 2     $47.48     $49.98       2414
    ## 3     $49.39     $51.99       3516
    ## 4     $47.48     $49.98       1634
    ## 5     $57.94     $60.99       1101
    ## 6     $49.39     $51.99       2727

## Average number of reviews of each brand

``` r
df2$num_review <- as.numeric(df2$num_review)
avg_rev_brand <-  aggregate((num_review) ~ brand_name , data= df2, FUN = mean)
avg_rev_brand
```

    ##                     brand_name (num_review)
    ## 1                 Blue Buffalo      1429.75
    ## 2                       Bundle         1.00
    ## 3                      Diamond       710.00
    ## 4          Hill's Science Diet       737.00
    ## 5                         Iams       713.00
    ## 6                     Pedigree       530.00
    ## 7                   Purina ONE       945.75
    ## 8              Purina Pro Plan      1346.20
    ## 9          Rachael Ray Nutrish      1467.00
    ## 10 Royal Canin Veterinary Diet      1093.00
    ## 11           Taste of the Wild      3121.50

## Subsetting the data frame only having the brand “Taste of the wild”

``` r
df2_tasteofthewild = df2[df2$brand_name == "Taste of the Wild",]
df2_tasteofthewild
```

    ##          brand_name                                         prod_name
    ## 3 Taste of the Wild   High Prairie Grain-Free Dry Dog Food, 28-lb bag
    ## 6 Taste of the Wild Pacific Stream Grain-Free Dry Dog Food, 28-lb bag
    ##   price.auto price.orig num_review
    ## 3     $49.39     $51.99       3516
    ## 6     $49.39     $51.99       2727

## Visualization

``` r
df2$price.auto <- gsub("[$]", "", df2$price.auto)
df2$price.orig <- gsub("[$]", "", df2$price.orig)

df2$price.auto <- as.numeric(df2$price.auto)
df2$price.orig <- as.numeric(df2$price.orig)


ggplot(df2) +
 aes(x = price.orig, y = price.auto, colour = brand_name) +
 geom_point(shape = "circle", 
 size = 2.8) +
 scale_color_hue(direction = 1) +
 theme_classic()
```

![](Codes_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

## Creating a variable that shows price differences

``` r
df2$price.diff <- df2$price.orig - df2$price.auto
df2$price.diff[is.na(df2$price.diff)] <- 0
```

## Sorting the newly created data frame

``` r
df2 <- arrange(df2,brand_name, prod_name)
```

## Creating a function where I’ll input the number of pages to scrape and the output will be the cleaned scraped pages in a data frame

``` r
chewy.info = function(url){
  an2 = read_html(url)
  
  brand_name = an2 %>% 
  html_nodes('h2 strong') %>% 
  html_text()
brand_name = trimws(brand_name, which = c("both"), whitespace = "[ :\t\r\n]")

prod_name = an2 %>% 
  html_nodes('.content h2') %>% 
  html_text()

prod_name = trimws(prod_name, which = c("both"), whitespace = "[:\t\r\n]")
prod_name = removeWords(prod_name, brand_name)
prod_name = trimws(prod_name, which = c("both"), whitespace = "[ :\t\r\n]")


price.auto = an2 %>%
  html_nodes('.product-info') %>%
  map_chr(~{
    autoprice <- .x %>% 
      html_nodes('.autoship strong') %>% 
      html_text2()
    
    if(length(autoprice) == 0){
      autoprice <- NA
    }
    
    return(autoprice)
 }) 

price.auto = trimws(price.auto, which = c("both"), whitespace = "[ \t\r\n]")



price.orig = an2 %>% 
  html_nodes('.price strong') %>% 
  html_text()
price.orig = trimws(price.orig, which = c("both"), whitespace = "[ \t\r\n]")


num_review = an2 %>%
  html_nodes('.product-info') %>%
  map_chr(~{
    rating <- .x %>% 
      html_nodes('.item-rating span') %>% 
      html_text2()
    
    if(length(rating) == 0){
      rating <- NA
    }
    
    return(rating)
 }) 

  
  
  chewy.df <- data.frame(brand_name, prod_name, price.auto, price.orig, num_review)
  return(chewy.df)
}

chewy.info.final = function(page_num){
  if(page_num>8 | page_num<1){
    result="Invalid input." 
  } else{
    #url = "https://www.chewy.com/b/dry-food-294"
    result = df2[,-6]
    if(page_num<=8 & page_num>1){
      for(i in 2:page_num){
        url = paste("https://www.chewy.com/b/dry-food_c294_p" , i , sep="")
        result.temp = chewy.info(url)
        result = rbind(result, result.temp)
      }
    }
  }
  return(result)
}

page_num=6
chewy.result = chewy.info.final(page_num)
head(chewy.result)
```

    ##     brand_name
    ## 1 Blue Buffalo
    ## 2 Blue Buffalo
    ## 3 Blue Buffalo
    ## 4 Blue Buffalo
    ## 5       Bundle
    ## 6       Bundle
    ##                                                                                                                   prod_name
    ## 1                                         Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 2                                       Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…
    ## 3                                       Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…
    ## 4                                                              Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag
    ## 5                           Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 6 High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ##   price.auto price.orig num_review
    ## 1      47.48      49.98       2414
    ## 2      47.48      49.98       1165
    ## 3      50.33      52.98        819
    ## 4      51.14      53.83       1321
    ## 5       <NA>      64.12       <NA>
    ## 6       <NA>      54.59       <NA>
