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
    ## [13] "Purina Pro Plan"             "Bundle"                     
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
    ## [35] "Purina Pro Plan"             "Bundle"

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
    ##  [7] "\n        \n          \n            Bundle: \n            Taste of the Wild High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [8] "\n        \n          \n            Bundle: \n            Taste of the Wild Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                    
    ##  [9] "\n        \n          \n          \n          \n            Hill's Science Diet\n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                            
    ## [10] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                  
    ## [11] "\n        \n          \n          \n          \n            Purina ONE\n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                             
    ## [12] "\n        \n          \n            Bundle: \n            Purina ONE SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                           
    ## [13] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                         
    ## [14] "\n        \n          \n            Bundle: \n            Purina Pro Plan Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
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
    ## [29] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                          
    ## [30] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [31] "\n        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "              
    ## [32] "\n        \n          \n            Bundle: \n            Purina ONE True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                    
    ## [33] "\n        \n          \n          \n          \n            Purina ONE\n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                           
    ## [34] "\n        \n          \n          \n          \n            Hill's Science Diet\n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                        
    ## [35] "\n        \n          \n          \n          \n            Purina Pro Plan\n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "                                                                                         
    ## [36] "\n        \n          \n            Bundle: \n            Purina Pro Plan Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "

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
    ##  [7] "        \n          \n            Bundle: \n            Taste of the Wild High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [8] "        \n          \n            Bundle: \n            Taste of the Wild Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                    
    ##  [9] "        \n          \n          \n          \n            Hill's Science Diet\n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                            
    ## [10] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                                  
    ## [11] "        \n          \n          \n          \n            Purina ONE\n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                             
    ## [12] "        \n          \n            Bundle: \n            Purina ONE SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                           
    ## [13] "        \n          \n          \n          \n            Purina Pro Plan\n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                         
    ## [14] "        \n          \n            Bundle: \n            Purina Pro Plan Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
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
    ## [29] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                          
    ## [30] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [31] "        \n          \n            Bundle: \n            Blue Buffalo Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "              
    ## [32] "        \n          \n            Bundle: \n            Purina ONE True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                    
    ## [33] "        \n          \n          \n          \n            Purina ONE\n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                           
    ## [34] "        \n          \n          \n          \n            Hill's Science Diet\n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                        
    ## [35] "        \n          \n          \n          \n            Purina Pro Plan\n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "                                                                                         
    ## [36] "        \n          \n            Bundle: \n            Purina Pro Plan Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "

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
    ##  [7] "        \n          \n            : \n             High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                        
    ##  [8] "        \n          \n            : \n             Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats\n          \n          \n          \n        \n      "                      
    ##  [9] "        \n          \n          \n          \n            \n             Adult Large Breed Dry Dog Food, 35-lb bag\n          \n        \n      "                                                                                                          
    ## [10] "        \n          \n          \n          \n            \n             SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag\n          \n        \n      "                                                                                       
    ## [11] "        \n          \n          \n          \n            \n             SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag\n          \n        \n      "                                                                                  
    ## [12] "        \n          \n            : \n             SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                                                      
    ## [13] "        \n          \n          \n          \n            \n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…\n          \n        \n      "                                                                   
    ## [14] "        \n          \n            : \n             Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                            
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
    ## [29] "        \n          \n            : \n             Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "                       
    ## [30] "        \n          \n            : \n             Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "        
    ## [31] "        \n          \n            : \n             Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats\n          \n          \n          \n        \n      "           
    ## [32] "        \n          \n            : \n             True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "                               
    ## [33] "        \n          \n          \n          \n            \n             True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag\n          \n        \n      "                                                                
    ## [34] "        \n          \n          \n          \n            \n             Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag\n          \n        \n      "                                                                                      
    ## [35] "        \n          \n          \n          \n            \n             Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag\n          \n        \n      "                                                                                   
    ## [36] "        \n          \n            : \n             Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats\n          \n          \n          \n        \n      "

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
    ##  [7] "High Prairie Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats"                        
    ##  [8] "Pacific Stream Grain-Free Dry Food + American Journey Peanut Butter Recipe Grain-Free Oven Baked Crunchy Biscuit Dog Treats"                      
    ##  [9] "Adult Large Breed Dry Dog Food, 35-lb bag"                                                                                                        
    ## [10] "SmartBlend Lamb & Rice Adult Formula Dry Dog Food, 40-lb bag"                                                                                     
    ## [11] "SmartBlend Chicken & Rice Adult Formula Dry Dog Food, 31.1-lb bag"                                                                                
    ## [12] "SmartBlend Lamb & Rice Adult Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                                                      
    ## [13] "Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Dog Food, 50…"                                                                 
    ## [14] "Sport All Life Stages Performance 30/20 Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                            
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
    ## [29] "Life Protection Formula Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"                       
    ## [30] "Life Protection Formula Healthy Weight Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"        
    ## [31] "Life Protection Formula Large Breed Adult Chicken & Brown Rice Recipe Dry Food + Health Bars Baked with Bacon, Egg & Cheese Dog Treats"           
    ## [32] "True Instinct with Real Turkey & Venison High Protein Adult Dry Food + Milk-Bone Original Large Biscuit Dog Treats"                               
    ## [33] "True Instinct with Real Turkey & Venison High Protein Adult Dry Dog Food, 36-lb bag"                                                              
    ## [34] "Adult Perfect Weight Chicken Recipe Dry Dog Food, 28.5 lb bag"                                                                                    
    ## [35] "Adult Large Breed Chicken & Rice Formula Dry Dog Food, 34-lb bag"                                                                                 
    ## [36] "Adult Large Breed Chicken & Rice Formula Dry Food + Milk-Bone Original Large Biscuit Dog Treats"

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
    ##  [8] "$54.59"  "$54.99"  "$38.34"  "$32.05"  "$49.98"  "$67.98"  "$79.62" 
    ## [15] "$104.99" "$55.78"  "$53.98"  "$37.29"  "$41.42"  "$31.64"  "$52.48" 
    ## [22] "$40.29"  "$49.98"  "$19.94"  "$31.48"  "$52.98"  "$33.99"  "$36.99" 
    ## [29] "$53.95"  "$53.95"  "$56.95"  "$56.53"  "$44.89"  "$60.99"  "$52.48" 
    ## [36] "$64.12"

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
    ## 1                 Blue Buffalo     1831.750
    ## 2                       Bundle     1013.833
    ## 3                      Diamond     3516.000
    ## 4          Hill's Science Diet     1159.000
    ## 5                         Iams      651.500
    ## 6                     Pedigree      545.000
    ## 7                   Purina ONE     1399.750
    ## 8              Purina Pro Plan     1471.200
    ## 9          Rachael Ray Nutrish      578.000
    ## 10 Royal Canin Veterinary Diet      848.000
    ## 11           Taste of the Wild     3121.500

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
    ## 2      35.14      49.98       1034
    ## 3      49.86      52.98       2714
    ## 4      49.86      53.98       1165
    ## 5      64.58      64.12       1093
    ## 6      52.24      54.59        565
