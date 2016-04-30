<style>
.small-code pre code {
  font-size: small;
}
</style>



WorldBankOpenData
========================================================
author: Igor Misechko
date: April 2016 
autosize: true
transition: concave
transition-speed: slow

This is the Assigments of the course Developing Data Product  
As part of the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) from Johns Hopkins University  
Providing on Coursera by Brian Caffo, Jeff Leek and Roger Peng    

Course Project: Shiny Application and __Reproducible Pitch__



Introduction
========================================================

World Bank provide [open data](http://data.worldbank.org/) about development in countries around the globe.  
This data include information:

- 215 country and 49 regions
- 148 indicators
- From 1960 to 2014 years

My application provide simple interface to select country and indicator that you want to analysis.  
You can select parameters and quick build diagram or look raw data in table.  
If necessary you can download raw data and make analyses with your needs.  
[World Bank Open Data Application](http://misechko.shinyapps.io/DDP_by_Shiny_on_Coursera)


Diagram example
========================================================
class: small-code

<span style="font-size:xx-large; font-weight:bold; color:green;">Example code for loading data</span>

```r
library(WDI)
dat = WDI::WDI(indicator='NY.GDP.PCAP.KD', 
               country=c('MX','CA','US'), 
               start=1960, end=2012)
```
  <br>
<span style="font-size:xx-large; font-weight:bold; color:green;">Building plot with loaded data</span>

```r
library(ggplot2)
p <- ggplot(dat, aes(year, 
                     NY.GDP.PCAP.KD, 
                     color=country)) + 
            geom_line() + 
            xlab('Year') + 
            ylab('GDP per capita')
```
*****  

![plot of chunk unnamed-chunk-3](WorldBankOpenData-figure/unnamed-chunk-3-1.png)


Table example
========================================================

Example of output raw data in table, include first 10 rows.

```r
kable(head(dat,10))
```
<span style="font-size:x-large; font-weight:bold; color:green;">
    <br>
    On this tab it's possible to download raw data.  
</span>
*****  


|iso2c |country | NY.GDP.PCAP.KD| year|
|:-----|:-------|--------------:|----:|
|CA    |Canada  |       37445.39| 2012|
|CA    |Canada  |       37176.16| 2011|
|CA    |Canada  |       36465.71| 2010|
|CA    |Canada  |       35670.58| 2009|
|CA    |Canada  |       37086.90| 2008|
|CA    |Canada  |       37054.88| 2007|
|CA    |Canada  |       36679.37| 2006|
|CA    |Canada  |       36028.23| 2005|
|CA    |Canada  |       35269.57| 2004|
|CA    |Canada  |       34540.60| 2003|

Some thoughts
========================================================
class: small-code


<span style="font-size:xx-large; font-weight:bold; ">[WDI](https://cran.r-project.org/web/packages/WDI/index.html) package</span>  

```r
str(WDI::WDIcache())
```

```
List of 2
 $ series : chr [1:16630, 1:5] "1.0.HCount.1.90usd" "1.0.HCount.2.5usd" "1.0.HCount.Mid10to50" "1.0.HCount.Ofcl" ...
  ..- attr(*, "dimnames")=List of 2
  .. ..$ : NULL
  .. ..$ : chr [1:5] "indicator" "name" "description" "sourceDatabase" ...
 $ country: chr [1:264, 1:9] "ABW" "AFG" "AFR" "AGO" ...
  ..- attr(*, "dimnames")=List of 2
  .. ..$ : NULL
  .. ..$ : chr [1:9] "iso3c" "iso2c" "country" "region" ...
```
<span style="font-size:x-large; font-weight:bold; ">Advantages:</span>
- <span style="font-size:x-large; ">Every indicator placed in separate column</span>

<span style="font-size:large; color:teal;line-height:50%";>
When the application builded only WDI package have been available. By the end april have announced package wbstats. It is similar by functionality but have additional options. <br>
I haven't enough time to rebuild application and I just cover a difference between this package.
</span>

-----
<span style="font-size:xx-large; font-weight:bold; ">Package [wbstats](https://cran.r-project.org/package=wbstats)</span>

```r
str(wbstats::wb_cachelist, max.level = 1)
```

```
List of 7
 $ countries  :'data.frame':	264 obs. of  14 variables:
 $ indicators :'data.frame':	16630 obs. of  6 variables:
 $ sources    :'data.frame':	39 obs. of  4 variables:
 $ datacatalog:'data.frame':	10 obs. of  25 variables:
 $ topics     :'data.frame':	21 obs. of  3 variables:
 $ income     :'data.frame':	10 obs. of  2 variables:
 $ lending    :'data.frame':	4 obs. of  2 variables:
```
<span style="font-size:x-large; font-weight:bold; ">Advantages:</span>
- <span style="font-size:x-large; ">More indicators available</span>
- <span style="font-size:x-large; ">Support for Most Recent Value queries</span>
- <span style="font-size:x-large; ">Support for grep style searching for data descriptions and names</span>
- <span style="font-size:x-large; ">Support for searching and downloading data in multiple languages</span>



