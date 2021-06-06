Web Scraping and Data Analysis
================

## Loading necessary libraries

``` r
library(stringr)
library(R.utils)
library(rvest)
library(dplyr)
library(xml2)
library(tm)
library(ggplot2)
```

## Web scraping the billboard hot 100 page

``` r
an_url="https://www.billboard.com/charts/hot-100"
an = read_html(an_url)
an
```

    ## {html_document}
    ## <html class="" lang="">
    ## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
    ## [2] <body class="chart-page chart-page-" data-trackcategory="Charts-TheHot100 ...

``` r
str( an )
```

    ## List of 2
    ##  $ node:<externalptr> 
    ##  $ doc :<externalptr> 
    ##  - attr(*, "class")= chr [1:2] "xml_document" "xml_node"

``` r
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
table(df$hot100.artist)
```

    ## 
    ##                   24kGoldn Featuring iann dior 
    ##                                              1 
    ##                          42 Dugg & Roddy Ricch 
    ##                                              1 
    ##                       42 Dugg Featuring Future 
    ##                                              1 
    ##      A Boogie Wit da Hoodie Featuring Lil Durk 
    ##                                              1 
    ##                                            AJR 
    ##                                              1 
    ##                                  Ariana Grande 
    ##                                              1 
    ##                                   Bella Poarch 
    ##                                              1 
    ##                                  Billie Eilish 
    ##                                              1 
    ##                                  Blake Shelton 
    ##                                              1 
    ##                                            BTS 
    ##                                              1 
    ##                                        Cardi B 
    ##                                              1 
    ##                       Chris Young + Kane Brown 
    ##                                              1 
    ##                                     City Girls 
    ##                                              1 
    ##                   Coi Leray Featuring Lil Durk 
    ##                                              1 
    ##                                  Cole Swindell 
    ##                                              1 
    ##                                     Dan + Shay 
    ##                                              1 
    ##                                 Dierks Bentley 
    ##                                              1 
    ##        DJ Khaled Featuring Lil Baby & Lil Durk 
    ##                                              1 
    ##                                       Doja Cat 
    ##                                              1 
    ##                         Doja Cat Featuring SZA 
    ##                                              1 
    ##                                          Drake 
    ##                                              1 
    ##                       Drake Featuring Lil Baby 
    ##                                              1 
    ##                                       Dua Lipa 
    ##                                              1 
    ##                      Dua Lipa Featuring DaBaby 
    ##                                              1 
    ##                                Duncan Laurence 
    ##                                              1 
    ##                                    Dylan Scott 
    ##                                              1 
    ##                                    Eric Church 
    ##                                              1 
    ##                          Future & Lil Uzi Vert 
    ##                                              1 
    ##                                  Gabby Barrett 
    ##                                              1 
    ##                                         Giveon 
    ##                                              1 
    ##                                  Glass Animals 
    ##                                              1 
    ##                                Imagine Dragons 
    ##                                              1 
    ##                                        J. Cole 
    ##                                              6 
    ##                                  J. Cole & Bas 
    ##                                              1 
    ##                             J. Cole & Lil Baby 
    ##                                              1 
    ##                    J. Cole, 21 Savage & Morray 
    ##                                              1 
    ##                           J. Cole, Bas & 6LACK 
    ##                                              1 
    ##                                      Jake Owen 
    ##                                              1 
    ##                                   Jason Aldean 
    ##                                              1 
    ##                               Jazmine Sullivan 
    ##                                              1 
    ##                                   Jordan Davis 
    ##                                              1 
    ##                                  Justin Bieber 
    ##                                              1 
    ## Justin Bieber Featuring Daniel Caesar & Giveon 
    ##                                              1 
    ##                                     Kali Uchis 
    ##                                              1 
    ##                     Keith Urban Duet With P!nk 
    ##                                              1 
    ##                                  Lainey Wilson 
    ##                                              1 
    ##                                       Lil Baby 
    ##                                              1 
    ##                                      Lil Nas X 
    ##                                              2 
    ##                       Lil Tjay Featuring 6LACK 
    ##                                              1 
    ##                                     Luke Combs 
    ##                                              1 
    ##                  Machine Gun Kelly X blackbear 
    ##                                              1 
    ##         Maroon 5 Featuring Megan Thee Stallion 
    ##                                              1 
    ##                    Marshmello X Jonas Brothers 
    ##                                              1 
    ##                                    Masked Wolf 
    ##                                              1 
    ##                                          Migos 
    ##                                              1 
    ##                                Miranda Lambert 
    ##                                              1 
    ##                                   Moneybagg Yo 
    ##                                              2 
    ##                                         Mooski 
    ##                                              1 
    ##                                  Morgan Wallen 
    ##                                              1 
    ##                                         Morray 
    ##                                              1 
    ##                   Nelly & Florida Georgia Line 
    ##                                              1 
    ##                 Nicki Minaj, Drake & Lil Wayne 
    ##                                              1 
    ##                                 Olivia Rodrigo 
    ##                                             11 
    ##                                           P!nk 
    ##                                              1 
    ##                                         Polo G 
    ##                                              1 
    ##                             Polo G & Lil Wayne 
    ##                                              1 
    ##                Pooh Shiesty Featuring Lil Durk 
    ##                                              1 
    ##                                      Pop Smoke 
    ##                                              1 
    ##     Pop Smoke Featuring A Boogie Wit da Hoodie 
    ##                                              1 
    ##                                       Rod Wave 
    ##                                              1 
    ##                    Ryan Hurd With Maren Morris 
    ##                                              1 
    ##                                       Sam Hunt 
    ##                                              1 
    ##                    Saweetie Featuring Doja Cat 
    ##                                              1 
    ##       Silk Sonic (Bruno Mars & Anderson .Paak) 
    ##                                              1 
    ##  SpotemGottem Featuring Pooh Shiesty Or DaBaby 
    ##                                              1 
    ##                                  The Kid LAROI 
    ##                                              1 
    ##                                     The Weeknd 
    ##                                              1 
    ##                     The Weeknd & Ariana Grande 
    ##                                              1 
    ##                                   Thomas Rhett 
    ##                                              1 
    ##                            Travis Scott & HVME 
    ##                                              1 
    ##                   Trippie Redd & Playboi Carti 
    ##                                              1 
    ##                             Young Thug & Gunna 
    ##                                              1 
    ##             Young Thug & Gunna Featuring Drake 
    ##                                              1

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
an2
```

    ## {html_document}
    ## <html lang="en" class="cw-desktop">
    ## [1] <head>\n<link rel="preconnect" href="https://cdn.optimizely.com">\n<link  ...
    ## [2] <body class="bd-category">\n\n    <script>\n    var suReleaseLink =  docu ...

``` r
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
    ## [19] "Rachael Ray Nutrish"         "Iams"                       
    ## [21] "Purina Pro Plan"             "Bundle"                     
    ## [23] "Blue Buffalo"                "Pedigree"                   
    ## [25] "Iams"                        "Blue Buffalo"               
    ## [27] "Purina ONE"                  "Diamond"                    
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
    ## [19] "\n        \n          \n          \n          \n            Rachael Ray Nutrish\n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                
    ## [20] "\n        \n          \n          \n          \n            Iams\n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                           
    ## [21] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                         
    ## [22] "\n        \n          \n            Bundle: \n            Diamond Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                 
    ## [23] "\n        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                         
    ## [24] "\n        \n          \n          \n          \n            Pedigree\n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                                         
    ## [25] "\n        \n          \n          \n          \n            Iams\n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                          
    ## [26] "\n        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                         
    ## [27] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                                
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
    ## [19] "        \n          \n          \n          \n            Rachael Ray Nutrish\n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                
    ## [20] "        \n          \n          \n          \n            Iams\n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                           
    ## [21] "        \n          \n          \n          \n            Purina Pro Plan\n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                         
    ## [22] "        \n          \n            Bundle: \n            Diamond Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "                 
    ## [23] "        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                         
    ## [24] "        \n          \n          \n          \n            Pedigree\n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                                         
    ## [25] "        \n          \n          \n          \n            Iams\n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                                          
    ## [26] "        \n          \n          \n          \n            Blue Buffalo\n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                         
    ## [27] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                                
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
    ## [19] "        \n          \n          \n          \n            \n             Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                              
    ## [20] "        \n          \n          \n          \n            \n             ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                          
    ## [21] "        \n          \n          \n          \n            \n             Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…\n          \n        \n      "                                                                   
    ## [22] "        \n          \n            : \n             Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats\n          \n          \n          \n        \n      "         
    ## [23] "        \n          \n          \n          \n            \n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…\n          \n        \n      "                                                                
    ## [24] "        \n          \n          \n          \n            \n             Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …\n          \n        \n      "                                                            
    ## [25] "        \n          \n          \n          \n            \n             ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag\n          \n        \n      "                                                                                         
    ## [26] "        \n          \n          \n          \n            \n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…\n          \n        \n      "                                                                
    ## [27] "        \n          \n          \n          \n            \n             SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                     
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
    ## [19] "Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag"                                                                                            
    ## [20] "ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag"                                                                                        
    ## [21] "Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…"                                                                 
    ## [22] "Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats"         
    ## [23] "Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…"                                                              
    ## [24] "Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …"                                                          
    ## [25] "ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag"                                                                                       
    ## [26] "Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…"                                                              
    ## [27] "SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag"                                                                                   
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
  html_nodes('.autoship strong') %>%
  html_text()

price.auto
```

    ##  [1] "\n              $49.86\n            "
    ##  [2] "\n              $47.48\n            "
    ##  [3] "\n              $49.39\n            "
    ##  [4] "\n              $47.48\n            "
    ##  [5] "\n              $57.94\n            "
    ##  [6] "\n              $49.39\n            "
    ##  [7] "\n              $52.24\n            "
    ##  [8] "\n              $36.42\n            "
    ##  [9] "\n              $30.45\n            "
    ## [10] "\n              $64.58\n            "
    ## [11] "\n              $99.74\n            "
    ## [12] "\n              $52.99\n            "
    ## [13] "\n              $51.28\n            "
    ## [14] "\n              $35.43\n            "
    ## [15] "\n              $39.35\n            "
    ## [16] "\n              $30.06\n            "
    ## [17] "\n              $49.86\n            "
    ## [18] "\n              $38.28\n            "
    ## [19] "\n              $47.48\n            "
    ## [20] "\n              $29.91\n            "
    ## [21] "\n              $50.33\n            "
    ## [22] "\n              $32.29\n            "
    ## [23] "\n              $35.14\n            "
    ## [24] "\n              $42.65\n            "
    ## [25] "\n              $57.94\n            "
    ## [26] "\n              $49.86\n            "

``` r
price.auto = trimws(price.auto, which = c("both"), whitespace = "[ \t\r\n]")
price.auto
```

    ##  [1] "$49.86" "$47.48" "$49.39" "$47.48" "$57.94" "$49.39" "$52.24" "$36.42"
    ##  [9] "$30.45" "$64.58" "$99.74" "$52.99" "$51.28" "$35.43" "$39.35" "$30.06"
    ## [17] "$49.86" "$38.28" "$47.48" "$29.91" "$50.33" "$32.29" "$35.14" "$42.65"
    ## [25] "$57.94" "$49.86"

``` r
price.orig = an2 %>% 
  html_nodes('.price strong') %>% 
  html_text()
price.orig = trimws(price.orig, which = c("both"), whitespace = "[ \t\r\n]")
price.orig
```

    ##  [1] "$52.48"  "$49.98"  "$51.99"  "$49.98"  "$60.99"  "$51.99"  "$54.59" 
    ##  [8] "$54.59"  "$54.99"  "$38.34"  "$32.05"  "$49.98"  "$79.62"  "$67.98" 
    ## [15] "$104.99" "$55.78"  "$53.98"  "$37.29"  "$41.42"  "$31.64"  "$52.48" 
    ## [22] "$40.29"  "$49.98"  "$19.94"  "$31.48"  "$52.98"  "$33.99"  "$36.99" 
    ## [29] "$56.95"  "$53.95"  "$53.95"  "$56.53"  "$44.89"  "$60.99"  "$64.12" 
    ## [36] "$52.48"

``` r
num_review = an2 %>% 
  html_nodes('.item-rating span') %>% 
  html_text()
num_review = trimws(num_review, which = c("both"), whitespace = "[ \t\r\n]")
num_review
```

    ##  [1] "2714" "2414" "3516" "1634" "1101" "2727" "565"  "983"  "1188" "1109"
    ## [11] "1093" "1"    "1321" "1467" "848"  "790"  "1165" "530"  "578"  "819" 
    ## [21] "578"  "710"  "1034" "545"  "484"

``` r
df2 <- cbind(brand_name, prod_name, price.auto, price.orig, num_review)
df2 <- data.frame(df2)
```

## Average number of reviews of each brand

``` r
df2$num_review <- as.numeric(df2$num_review)
avg_rev_brand <-  aggregate((num_review) ~ brand_name , data= df2, FUN = mean)
avg_rev_brand
```

    ##                     brand_name (num_review)
    ## 1                 Blue Buffalo      1831.75
    ## 2                       Bundle      1003.00
    ## 3                      Diamond      3516.00
    ## 4          Hill's Science Diet      1159.00
    ## 5                         Iams       651.50
    ## 6                     Pedigree       545.00
    ## 7                   Purina ONE      1399.75
    ## 8              Purina Pro Plan      1497.20
    ## 9          Rachael Ray Nutrish       578.00
    ## 10 Royal Canin Veterinary Diet       848.00
    ## 11           Taste of the Wild      3121.50

## Subsetting the data frame only having the brand “Taste of the wild”

``` r
df2_tasteofthewild = df2[df2$brand_name == "Taste of the Wild",]
```

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
 theme_gray()
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
  brand_name
  
 prod_name = an2 %>% 
  html_nodes('.content h2') %>% 
  html_text()
  prod_name
  prod_name = trimws(prod_name, which = c("both"), whitespace = "[:\t\r\n]")
  prod_name
  prod_name = removeWords(prod_name, brand_name)
  prod_name
  prod_name = trimws(prod_name, which = c("both"), whitespace = "[ :\t\r\n]")
  prod_name
  
  price.auto = an2 %>% 
    html_nodes('.autoship strong') %>% 
    html_text()
  price.auto = trimws(price.auto, which = c("both"), whitespace = "[ \t\r\n]")
  price.auto
  
  
  price.orig = an2 %>% 
    html_nodes('.price strong') %>% 
    html_text()
  price.orig = trimws(price.orig, which = c("both"), whitespace = "[ \t\r\n]")
  price.orig
  
  num_review = an2 %>% 
    html_nodes('.item-rating span') %>% 
    html_text()
  num_review = trimws(num_review, which = c("both"), whitespace = "[ \t\r\n]")
  num_review
  
  
  chewy.df <- cbind(brand_name, prod_name, price.auto, price.orig, num_review)
  chewy.df <- data.frame(chewy.df)
  return(chewy.df)
}

chewy.info.final = function(page_num){
  if(page_num>5 | page_num<1){
    result="Invalid input." 
  } else{
    #url = "https://www.chewy.com/b/dry-food-294"
    result = df2[,-6]
    if(page_num<=5 & page_num>1){
      for(i in 2:page_num){
        url = paste("https://www.chewy.com/b/dry-food_c294_p" , i , sep="")
        result.temp = chewy.info(url)
        result = rbind(result, result.temp)
      }
    }
  }
  return(result)
}

page_num=3
chewy.result = chewy.info.final(page_num)
chewy.result
```

    ##                      brand_name
    ## 1                  Blue Buffalo
    ## 2                  Blue Buffalo
    ## 3                  Blue Buffalo
    ## 4                  Blue Buffalo
    ## 5                        Bundle
    ## 6                        Bundle
    ## 7                        Bundle
    ## 8                        Bundle
    ## 9                        Bundle
    ## 10                       Bundle
    ## 11                       Bundle
    ## 12                       Bundle
    ## 13                       Bundle
    ## 14                       Bundle
    ## 15                       Bundle
    ## 16                       Bundle
    ## 17                      Diamond
    ## 18          Hill's Science Diet
    ## 19          Hill's Science Diet
    ## 20          Hill's Science Diet
    ## 21                         Iams
    ## 22                         Iams
    ## 23                     Pedigree
    ## 24                   Purina ONE
    ## 25                   Purina ONE
    ## 26                   Purina ONE
    ## 27                   Purina ONE
    ## 28              Purina Pro Plan
    ## 29              Purina Pro Plan
    ## 30              Purina Pro Plan
    ## 31              Purina Pro Plan
    ## 32              Purina Pro Plan
    ## 33          Rachael Ray Nutrish
    ## 34  Royal Canin Veterinary Diet
    ## 35            Taste of the Wild
    ## 36            Taste of the Wild
    ## 37                     Bundle: 
    ## 38              Kibbles 'n Bits
    ## 39                     Bundle: 
    ## 40                     Dog Chow
    ## 41          Rachael Ray Nutrish
    ## 42             American Journey
    ## 43                     Bundle: 
    ## 44                     Bundle: 
    ## 45                Gentle Giants
    ## 46          Hill's Science Diet
    ## 47                     Bundle: 
    ## 48  Royal Canin Veterinary Diet
    ## 49                        Nutro
    ## 50                     Bundle: 
    ## 51                     Bundle: 
    ## 52                       VICTOR
    ## 53                      Diamond
    ## 54                     Bundle: 
    ## 55               Purina Beneful
    ## 56                     Bundle: 
    ## 57              Purina Pro Plan
    ## 58              Purina Pro Plan
    ## 59                     Dog Chow
    ## 60          Hill's Science Diet
    ## 61                 Blue Buffalo
    ## 62                     Bundle: 
    ## 63                      Diamond
    ## 64                     Bundle: 
    ## 65                   Purina ONE
    ## 66              Purina Pro Plan
    ## 67                     Bundle: 
    ## 68                     Bundle: 
    ## 69                     Bundle: 
    ## 70  Royal Canin Veterinary Diet
    ## 71                   Purina ONE
    ## 72                 Blue Buffalo
    ## 73                     Bundle: 
    ## 74              Natural Balance
    ## 75              Purina Pro Plan
    ## 76                 Blue Buffalo
    ## 77                     Bundle: 
    ## 78             American Journey
    ## 79     Hill's Prescription Diet
    ## 80            Taste of the Wild
    ## 81                      Diamond
    ## 82                     Bundle: 
    ## 83                     Bundle: 
    ## 84                     Bundle: 
    ## 85                     Bundle: 
    ## 86               Purina Beneful
    ## 87                      Diamond
    ## 88                     Bundle: 
    ## 89                 Blue Buffalo
    ## 90          Hill's Science Diet
    ## 91                     Bundle: 
    ## 92     Hill's Prescription Diet
    ## 93                     Bundle: 
    ## 94                 Blue Buffalo
    ## 95                     Bundle: 
    ## 96              Purina Pro Plan
    ## 97                     Bundle: 
    ## 98     Hill's Prescription Diet
    ## 99                   Purina ONE
    ## 100             Kibbles 'n Bits
    ## 101                    Bundle: 
    ## 102             Purina Pro Plan
    ## 103                    Bundle: 
    ## 104                    Bundle: 
    ## 105                    Bundle: 
    ## 106                    Bundle: 
    ## 107             Purina Pro Plan
    ## 108                    Bundle: 
    ##                                                                                                                                                                             prod_name
    ## 1                                                                                                   Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 2                                                                                                 Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Dog F…
    ## 3                                                                                                 Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…
    ## 4                                                                                                                        Wilderness Chicken Recipe Grain-Free Dry Dog Food, 24-lb bag
    ## 5                                                                                     Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 6                                                           High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 7                                                          Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats
    ## 8                                           Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats
    ## 9                                              Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats
    ## 10                                           Naturals Chicken & Rice Formula All Life Stages Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats
    ## 11                                                        Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 12                                  Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats
    ## 13                                                                                        SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 14                                                      SmartBlend Large Breed Puppy Formula Dry Food + American Journey Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats
    ## 15                                                              Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 16                                                                 True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 17                                                                                                            Naturals Chicken & Rice Formula All Life Stages Dry Dog Food, 40-lb bag
    ## 18                                                                                                                                          Adult Large Breed Dry Dog Food, 35-lb bag
    ## 19                                                                                                                      Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag
    ## 20                                                                                                              Adult Sensitive Stomach & Skin Chicken Recipe Dry Dog Food, 30-lb bag
    ## 21                                                                                                                         ProActive Health Adult Large Breed Dry Dog Food, 30-lb bag
    ## 22                                                                                                                          ProActive Health Adult MiniChunks Dry Dog Food, 30-lb bag
    ## 23                                                                                            Adult Complete Nutrition Roasted Chicken, Rice & Vegetable Flavor Dry Dog Food, 33-lb …
    ## 24                                                                                                                  SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag
    ## 25                                                                                                                       SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag
    ## 26                                                                                                                     SmartBlend Large Breed Puppy Formula Dry Dog Food, 31.1-lb bag
    ## 27                                                                                                True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag
    ## 28                                                                                                                   Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag
    ## 29                                                                                                       Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry Dog Food, 30-lb bag
    ## 30                                                                                                                Adult Shredded Blend Chicken & Rice Formula Dry Dog Food, 35-lb bag
    ## 31                                                                                                   Puppy Large Breed Chicken & Rice Formula with Probiotics Dry Dog Food, 34-lb ba…
    ## 32                                                                                                   Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…
    ## 33                                                                                                                              Real Chicken & Veggies Recipe Dry Dog Food, 40-lb bag
    ## 34                                                                                                                              Hydrolyzed Protein Adult HP Dry Dog Food, 25.3-lb bag
    ## 35                                                                                                                                    High Prairie Grain-Free Dry Dog Food, 28-lb bag
    ## 36                                                                                                                                  Pacific Stream Grain-Free Dry Dog Food, 28-lb bag
    ## 37                                                  Bundle: \n             Canine Nutrition Chicken Dry Food +  Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 38                                                                                                                     Original Savory Beef & Chicken Flavors Dry Dog Food, 50-lb bag
    ## 39                                                          Bundle: \n             Complete Adult with Real Chicken Dry Food, 42-lb bag + Milk-Bone Original Large Biscuit Dog Treats
    ## 40                                                                                                                           Complete Adult with Real Chicken Dry Dog Food, 42-lb bag
    ## 41                                                                                                                        Real Beef, Pea, & Brown Rice Recipe Dry Dog Food, 40-lb bag
    ## 42                                                                                                    Active Life Formula Salmon, Brown Rice & Vegetables Recipe Dry Dog Food, 28-lb…
    ## 43                                                                  Bundle: \n             Natural Chicken & Veggies Recipe Dry Food + Soup Bones Chicken & Veggies Flavor Dog Treats
    ## 44                                                            Bundle: \n             Natural Beef, Pea, & Brown Rice Recipe Dry Food + Soup Bones Chicken & Veggies Flavor Dog Treats
    ## 45                                                                                                                                   Canine Nutrition Chicken Dry Dog Food, 30-lb bag
    ## 46                                                                                                                              Adult Chicken & Barley Recipe Dry Dog Food, 35-lb bag
    ## 47                                                                                 Bundle: \n             Adult Chicken & Barley Recipe Dry Food + Greenies Regular Dental Dog Treats
    ## 48                                                                                                                                 Gastrointestinal Low Fat Dry Dog Food, 28.6-lb bag
    ## 49                                                                                               Natural Choice Large Breed Adult Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 50                               Bundle: \n             Natural Choice Large Breed Adult Chicken & Brown Rice Recipe Dry Food + SmartBones SmartSticks Peanut Butter Chews Dog Treats
    ## 51                                                                Bundle: \n             Classic Hi-Pro Plus Formula Dry Food + SmartBones SmartSticks Peanut Butter Chews Dog Treats
    ## 52                                                                                                                                Classic Hi-Pro Plus Formula Dry Dog Food, 40-lb bag
    ## 53                                                                                                                    Naturals Lamb Meal & Rice Formula Adult Dry Dog Food, 40-lb bag
    ## 54                                                              Bundle: \n             Healthy Weight with Farm-Raised Chicken Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 55                                                                                                                    Healthy Weight with Farm-Raised Chicken Dry Dog Food, 28-lb bag
    ## 56                              Bundle: \n             Naturals Skin & Coat Formula All Life Stages Dry Food +  Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 57                                                                                                                   Adult Shredded Blend Lamb & Rice Formula Dry Dog Food, 35-lb bag
    ## 58                                                                                                      Adult Sensitive Skin & Stomach Lamb & Oatmeal Formula Dry Dog Food, 24-lb bag
    ## 59                                                                                                                              Complete Adult with Real Beef Dry Dog Food, 46-lb bag
    ## 60                                                                                                                Puppy Large Breed Chicken Meal & Oat Recipe Dry Dog Food, 30-lb bag
    ## 61                                                                                                     Life Protection Formula Adult Lamb & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 62                                     Bundle: \n             Life Protection Formula Adult Lamb & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats
    ## 63                                                                                                               Naturals Skin & Coat Formula All Life Stages Dry Dog Food, 30-lb bag
    ## 64                                               Bundle: \n             Adult Sensitive Stomach & Skin Chicken Recipe Dry Food, 30-lb bag + Tender Turkey & Rice Stew Canned Dog Food
    ## 65                                                                                                             SmartBlend Vibrant Maturity 7+ Adult Formula Dry Dog Food, 31.1-lb bag
    ## 66                                                                                                                               Puppy Chicken & Rice Formula Dry Dog Food, 34-lb bag
    ## 67                                                Bundle: \n             Puppy Chicken & Rice Formula Dry Food + Wellness Soft Puppy Bites Lamb & Salmon Recipe Grain-Free Dog Treats
    ## 68                               Bundle: \n            Taste of the Wild Sierra Mountain Grain-Free Dry Food +  Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 69                                                                  Bundle: \n             Naturals Beef Meal & Rice Formula Adult Dry Food + Bones & Chews Bully Stick 6" Dog Treats
    ## 70                                                                                                                                                 Ultamino Dry Dog Food, 19.8-lb bag
    ## 71                                                                                                                     SmartBlend Large Breed Adult Formula Dry Dog Food, 31.1-lb bag
    ## 72                                                                                                  Life Protection Formula Puppy Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 73                                                        Bundle: \n             Naturals Large Breed Adult Chicken & Rice Formula Dry Food + Bones & Chews Bully Stick 6" Dog Treats
    ## 74                                                                                                    L.I.D. Limited Ingredient Diets Grain-Free Salmon & Sweet Potato Formula Dry D…
    ## 75                                                                                                   Adult Weight Management Shredded Blend Chicken & Rice Formula Dry Dog Food, 34-…
    ## 76                                                                                                                        Wilderness Salmon Recipe Grain-Free Dry Dog Food, 24-lb bag
    ## 77                                   Bundle: \n             Chicken & Sweet Potato Recipe Grain-Free Dry Food + Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats
    ## 78                                                                                                                   Chicken & Sweet Potato Recipe Grain-Free Dry Dog Food, 24-lb bag
    ## 79                                                                                                            w/d Multi-Benefit Digestive, Weight, Glucose, Urinary Management Chick…
    ## 80                                                                                                                                 Sierra Mountain Grain-Free Dry Dog Food, 28-lb bag
    ## 81                                                                                                                    Naturals Beef Meal & Rice Formula Adult Dry Dog Food, 40-lb bag
    ## 82                                Bundle: \n             Adult Sensitive Stomach & Skin Chicken Recipe Dry Food + Hill's Natural Soft Savories with Peanut Butter & Banana Dog Treats
    ## 83                                                 Bundle: \n             Adult Perfect Weight Chicken Recipe Dry Food, 28.5 lb bag + Hearty Vegetable & Chicken Stew Canned Dog Food
    ## 84                                                                 Bundle: \n             SmartBlend Large Breed Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 85                                                                             Bundle: \n             Originals with Real Beef Dry Food + Milk-Bone Original Large Biscuit Dog Treats
    ## 86                                                                                                                                   Originals with Real Beef Dry Dog Food, 28-lb bag
    ## 87                                                                                                          Naturals Large Breed Adult Chicken & Rice Formula Dry Dog Food, 40-lb bag
    ## 88                                 Bundle: \n             Life Protection Formula Senior Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats
    ## 89                                                                                                 Life Protection Formula Senior Chicken & Brown Rice Recipe Dry Dog Food, 30-lb bag
    ## 90                                                                                                                  Adult Small Bites Chicken & Barley Recipe Dry Dog Food, 35-lb bag
    ## 91                                    Bundle: \n             Adult Small Bites Chicken & Barley Recipe Dry Food + Hill's Natural Soft Savories with Peanut Butter & Banana Dog Treats
    ## 92                                                                                                            Metabolic + Mobility Weight & Joint Care Chicken Flavor Dry Dog Food, …
    ## 93                                          Bundle: \n             Life Protection Formula Small Breed Adult Chicken & Brown Rice Recipe Dry Food + Greenies Teenie Dental Dog Treats
    ## 94                                                                                                Life Protection Formula Small Breed Adult Chicken & Brown Rice Recipe Dry Dog Food…
    ## 95                          Bundle: \n            Iams ProActive Health Smart Puppy Large Breed Dry Food, 30.6-lb bag +  Beef Recipe Grain-Free Soft & Chewy Training Bits Dog Treats
    ## 96                                                                                                                                  Puppy Lamb & Rice Formula Dry Dog Food, 34-lb bag
    ## 97                                                   Bundle: \n             Puppy Lamb & Rice Formula Dry Food + Wellness Soft Puppy Bites Lamb & Salmon Recipe Grain-Free Dog Treats
    ## 98                                                                                                                        i/d Digestive Care Chicken Flavor Dry Dog Food, 27.5-lb bag
    ## 99                                                                                                               SmartBlend Sensitive Systems Adult Formula Dry Dog Food, 31.1-lb bag
    ## 100                                                                                                  Bistro Oven Roasted Beef, Spring Vegetable & Apple Flavor Dry Dog Food, 50-lb b…
    ## 101                                                             Bundle: \n            Iams ProActive Health Adult MiniChunks Dry Food + Milk-Bone Flavor Snacks for Small/Medium Dogs
    ## 102                                                                                                  Sport All Life Stages Performance 30/20 Salmon & Rice Formula Dry Dog Food, 33-…
    ## 103                                        Bundle: \n             Adult Sensitive Skin & Stomach Lamb & Oatmeal Formula Dry Food + Focus Classic Salmon & Rice Entree Canned Dog Food
    ## 104 Bundle: \n             Sport All Life Stages Performance 30/20 Salmon & Rice Formula Dry Food + Focus Adult Classic Sensitive Skin & Stomach Salmon & Rice Entree Canned Dog Food
    ## 105                                                              Bundle: \n             Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry + Canned Dog Food, 13-oz, case of 12
    ## 106                                                                      Bundle: \n             Adult Sensitive Skin & Stomach Salmon & Rice Formula Dry + Canned Dog Food, 41-lb bag
    ## 107                                                                                                                Adult Shredded Blend Salmon & Rice Formula Dry Dog Food, 33-lb bag
    ## 108                                Bundle: \n             Adult Shredded Blend Salmon & Rice Formula Dry Food + Classic Sensitive Skin & Stomach Salmon & Rice Entree Canned Dog Food
    ##     price.auto price.orig num_review
    ## 1        47.48      49.98       2414
    ## 2        35.14      49.98       1034
    ## 3        49.86      52.98       2714
    ## 4        49.86      53.98       1165
    ## 5        30.45      64.12       1109
    ## 6        36.42      54.59        983
    ## 7        47.48      53.95       1101
    ## 8        57.94      53.95       2727
    ## 9        49.39      56.95       1634
    ## 10       32.29      40.29        710
    ## 11       52.24      54.59        565
    ## 12       30.06      55.78        790
    ## 13       52.99      49.98          1
    ## 14       38.28      37.29        530
    ## 15       51.28      79.62       1321
    ## 16       49.39      56.53        565
    ## 17       47.48      36.99       3516
    ## 18       30.45      54.99       1188
    ## 19       36.42      60.99       1188
    ## 20       57.94      60.99       1101
    ## 21       57.94      31.48        484
    ## 22       29.91      31.64        819
    ## 23       42.65      19.94        545
    ## 24       99.74      32.05       1093
    ## 25       64.58      38.34       1109
    ## 26       49.86      33.99       2414
    ## 27       52.24      44.89        983
    ## 28       64.58      52.48       1093
    ## 29       49.86      52.48       2714
    ## 30       47.48      49.98       1634
    ## 31       50.33      52.48        578
    ## 32       35.43      67.98       1467
    ## 33       47.48      41.42        578
    ## 34       39.35     104.99        848
    ## 35       49.39      51.99       3516
    ## 36       49.39      51.99       2727
    ## 37      $21.83     $35.59        431
    ## 38      $39.35     $22.98        448
    ## 39      $37.99     $36.63        947
    ## 40      $42.55     $24.99       1059
    ## 41      $42.55     $41.42          1
    ## 42      $52.24     $39.99          2
    ## 43      $84.52     $44.79        991
    ## 44      $93.09     $44.79        362
    ## 45      $46.53     $32.99       1581
    ## 46      $54.54     $54.99        670
    ## 47      $55.50     $88.97          2
    ## 48      $47.49     $97.99          1
    ## 49      $36.09     $48.98       1168
    ## 50      $25.64     $57.41        552
    ## 51      $47.48     $58.42        578
    ## 52      $49.86     $49.99        748
    ## 53      $52.24     $37.99        470
    ## 54      $50.33     $38.63        303
    ## 55      $37.04     $26.99        480
    ## 56      $87.05     $41.59        853
    ## 57      $31.28     $49.98        470
    ## 58      $49.86     $52.48          2
    ## 59      $94.99     $22.98        557
    ## 60      $30.51     $54.99        520
    ## 61      $47.48     $52.98        498
    ## 62      $21.83     $56.95        379
    ## 63      $39.35     $38.99        752
    ## 64      $37.99     $91.63        431
    ## 65      $42.55     $32.93        448
    ## 66      $42.55     $52.48        947
    ## 67      $52.24     $56.96       1059
    ## 68      $84.52     $54.59          1
    ## 69      $93.09     $47.63          2
    ## 70      $46.53     $99.99        991
    ## 71      $54.54     $32.12        362
    ## 72      $55.50     $49.98       1581
    ## 73      $54.05     $48.63        901
    ## 74      $49.86     $56.89        505
    ## 75      $54.13     $52.48        959
    ## 76      $41.50     $56.98       1484
    ## 77      $83.59     $46.28        942
    ## 78      $49.39     $43.68       1331
    ## 79      $34.19     $87.99        775
    ## 80      $62.21     $51.99          1
    ## 81      $86.10     $35.99        343
    ## 82      $25.64     $65.48        344
    ## 83      $35.14     $90.63        816
    ## 84      $47.48     $52.00        508
    ## 85      $52.24     $38.63        503
    ## 86      $56.51     $26.99        931
    ## 87      $89.29     $36.99          1
    ## 88      $31.33     $53.95        378
    ## 89      $32.94     $49.98        728
    ## 90      $49.86     $54.99        357
    ## 91      $90.24     $59.48        264
    ## 92      $30.76     $93.99        239
    ## 93      $21.83     $66.96          1
    ## 94      $51.14     $32.98        299
    ## 95      $49.86     $34.67        901
    ## 96      $69.24     $52.48        505
    ## 97      $69.24     $56.96        959
    ## 98      $69.24     $94.99       1484
    ## 99      $83.96     $32.38        942
    ## 100     $47.48     $22.98       1331
    ## 101     $66.86     $53.83        775
    ## 102     $54.05     $52.48          1
    ## 103     $49.86     $72.88        343
    ## 104     $54.13     $72.88        344
    ## 105     $41.50     $72.88        816
    ## 106     $83.59     $88.38        508
    ## 107     $49.39     $49.98        503
    ## 108     $34.19     $70.38        931
