#Author: M. Fertakos
####setup####
library(dplyr)
setwd("C:/Users/mfertakos/OneDrive - University of Massachusetts/Year1")
newBHLcombined<-read.csv('BHL_results_ofc.csv') #load assembled API results (from BHL_construct_APIresults.R)
colnames(newBHLcombined)<-c("Status","SearchedName","BaseURL","ResultCount","BHLType","ItemID","TitleID","Volume","ItemUrl","TitleUrl","MaterialType","PublisherPlace","PublicationDate","Authors","Genre","Title")
newBHLcombined$FoundIn<-NA
newBHLcombined$LocationKeep<-NA
newBHLcombined$Country<-NA
newBHLcombined$PublisherName<-NA
newBHLcombined$ResultType<-NA
newBHLcombined$TitleLanguage<-NA
newBHLcombined$Notes<-NA
newBHLcombined$UniqueIdentifier<-NA
####cleaning dates####
#For cleaning, the original catalog often had to be referred to
#Fix weird locations
newBHLcombined$PublisherPlace[which(newBHLcombined$PublisherPlace=='Low Angeles Calif')]<-'Los Angeles Calif'

#Fix PublicationDate ranges by checking the source directly for each span of years
unique(newBHLcombined$PublicationDate)
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1885-1917')])

#explore the publication dates and volumes of these catalogs
newBHLcombined %>% filter(Title=="[Harlan P. Kelsey (Firm) materials]") %>% select(Title,PublicationDate,Volume,SearchedName)
#Looks like the actual date is the latest PublicationDate -1 year

#verify that everything containing a range that starts with 1885 is from the same collection of catalogs
unique(newBHLcombined$Title[grep("1885-", newBHLcombined$PublicationDate)]) #it is
unique(newBHLcombined$PublicationDate[grep("1885-", newBHLcombined$PublicationDate)]) #checking to make sure this actually filtered to the correct dates

#convert PublicationDate of the ranges starting with 1885 in the dataset to that of 1 year lower than the high end of the range of the current PublicationDate
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1914')]<-'1913'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1918')]<-'1917'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1917')]<-'1916'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1900')]<-'1899'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1903')]<-'1902'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1902')]<-'1901'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1901')]<-'1900'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1905')]<-'1904'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1911')]<-'1910'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1912')]<-'1911'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1913')]<-'1912'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1921')]<-'1920'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1920')]<-'1919'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1916')]<-'1915'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1899')]<-'1898'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1896')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1908')]<-'1907'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1910')]<-'1909'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1909')]<-'1908'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1904')]<-'1903'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1892')]<-'1891'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1895')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1893')]<-'1892'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1894')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1887')]<-'1886'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1891')]<-'1890'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1906')]<-'1905'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1888')]<-'1887'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1907')]<-'1906'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1890')]<-'1889'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1886')]<-'1885'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-1889')]<-'1888'

#1885 dates from this collection of catalogs also looks wrong but the volume will correct this
unique(newBHLcombined$PublicationDate[which(newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')])
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-newBHLcombined$Volume[which(newBHLcombined$PublicationDate=='1885'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1902 Special Bulb List'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1902'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1921 Fall'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1921'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='March 15, 1920'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1920'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='March 29, 1909'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1909'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1920-21 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1920'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1891-92 Fall/Spring Wholesale Catalogue'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1891'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1895-96 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-02'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1901'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1915-16 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1915'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1913-14 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1913'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1906-07'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1906'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1893-94'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='15-Mar-20'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1920'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901 Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1901'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1903 Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1903'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='March 1894'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1905 Summer/Fall'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1905'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='April 9, 1907'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1907'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1885-86 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1885'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1902-03'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1902'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1903-04 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1903'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1897-98'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1907-08 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1907'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1910-11 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1910'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1891-92 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1891'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1916-17 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1916'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1898-99'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1898'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1894-95'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1895-06'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='April 15, 1899'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1899'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='April 6, 1905'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1905'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='March 1, 1892'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1892'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='August 1894'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1906 Fall'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1906'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='Sept. 15, 1906'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1906'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1912-13 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1912'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1919-20 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1919'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1899-1900'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1899'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1909-10 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1909'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1908-09 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1908'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1892-93'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1892'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1917-18 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1917'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1911-12 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1911'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1890-91 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1890'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1904-05 Fall/Spring'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1904'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1900-01'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1900'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1905-06'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1905'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1895-06'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='n.d. Surplus Stock'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-NA
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='n.d. Surplus Offer of Nursery Stock'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-NA
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='n.d.'&newBHLcombined$Title=='[Harlan P. Kelsey (Firm) materials]')]<-NA


#fix PublicationDates with one year span to be the earlier one
unique(newBHLcombined$PublicationDate[grep("-", newBHLcombined$PublicationDate)]) #used to check remaining date spans to fix
unique(newBHLcombined$Title[which(newBHLcombined$PublicationDate=='1903-1904')]) #used to check dates
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1903-1904')]) #used to check dates
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1903-1904')]<-'1903'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1921-1922')]<-'1921'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1919-1920')]<-'1919'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1914-1915')]<-'1914'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1899-1900')]<-'1899'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1909-1910')]<-'1909'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1908-1909')]<-'1908'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1966-1967')]<-'1966'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1920-1921')]<-'1920'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1918-1919')]<-'1918'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1913-1914')]<-'1913'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1869-1870')]<-'1869'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1912-1913')]<-'1912'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1863-1864')]<-'1863'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1856-1857')]<-'1856'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1860-1861')]<-'1860'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1857-1858')]<-'1857'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1895-1896')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1897-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1911-1912')]<-'1911'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1873-1874')]<-'1873'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1878-1879')]<-'1878'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1877-1878')]<-'1877'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1896-1897')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-1902')]<-'1901'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1900-1901')]<-'1900'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1902-1903')]<-'1902'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1930-1931')]<-'1930'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1885')]<-'1884'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1864-1865')]<-'1864'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1879-1880')]<-'1879'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1880-1881')]<-'1880'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1862-1863')]<-'1862'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1893-1894')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1964-1965')]<-'1964'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1965-1966')]<-'1965'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1890-1891')]<-'1890'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1937-1938')]<-'1937'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1898-1899')]<-'1898'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1859-1860')]<-'1859'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1875-1876')]<-'1875'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1953-1954')]<-'1953'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1952-1953')]<-'1952'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1916-1917')]<-'1916'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1834-1835')]<-'1834'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1910-1911')]<-'1910'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1969-1970')]<-'1969'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1907-1908')]<-'1907'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1882-1883')]<-'1882'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1867-1868')]<-'1867'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1883-1884')]<-'1883'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1867-1868')]<-'1867'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1874-1875')]<-'1874'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1970-1971')]<-'1970'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-1907')]<-'1907'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1957-1958')]<-'1957'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1958-1959')]<-'1958'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1955-1956')]<-'1955'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1956-1957')]<-'1956'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1951-1952')]<-'1951'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1906-07')]<-'1906'

#Fixing more date ranges (>1 year span)
unique(newBHLcombined$PublicationDate[grep("-", newBHLcombined$PublicationDate)])
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1796-1807')]) #this one is outside the US
newBHLcombined<-newBHLcombined[!(newBHLcombined$PublicationDate=='1796-1807'),]

unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1901-1914')])
unique(newBHLcombined$Title[grep("1901-", newBHLcombined$PublicationDate)])
newBHLcombined %>% filter(Title=="[Mount Arbor Nurseries materials]") %>% select(Title,PublicationDate,Volume,SearchedName)
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-1914')]<-'1913'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-1912')]<-'1911'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901-1913')]<-'1912'

#A lot of the 1901s from this catalog are wrong
newBHLcombined %>% filter(Title=="[Mount Arbor Nurseries materials]") %>% select(Title,PublicationDate,Volume,SearchedName)
#remove things that arent years from the volume column
foo <- newBHLcombined %>% filter(Title=="[Mount Arbor Nurseries materials]") %>% select(Title,PublicationDate,Volume,SearchedName)
foo <- foo$Volume
# Remove all before and up to ","
gsub(".*,","",foo)->foo
#Remove words from column
require("tm")
stopwords<-c("March","Feb.","March","Fall","Spring","January","February","March","April","May","June","July","August","September","October","November","December","Winter","Ornamental","and","Fruit","Trees")
removeWords(foo,stopwords)->foo
#remove white space
gsub(" ", "", foo, fixed = TRUE)->foo
#fix remaining dates
foo[which(foo=="1913-14")]<-"1913"
foo[which(foo=="1912-13")]<-"1912"
foo[which(foo=="1911-12")]<-"1911"
foo[which(foo=="10-Mar-09")]<-"1909"
foo[which(foo=="24-Mar-14")]<-"1914"
foo[which(foo=="9-Apr-14")]<-"1914"
foo[which(foo=="2-Mar-14")]<-"1914"
foo[which(foo=="27-Mar-11")]<-"1911"
foo[which(foo=="3-Mar-10")]<-"1910"
foo[which(foo=="6-Mar-07")]<-"1907"
foo[which(foo=="19-Apr-15")]<-"1915"
foo[which(foo=="2-Mar-06")]<-"1906"
foo[which(foo=="2-Apr-15")]<-"1915"
#place fixed dates into the df
newBHLcombined$PublicationDate[which(newBHLcombined$Title=="[Mount Arbor Nurseries materials]")]<-foo
#move these years to the PublicationDate column
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1901'&newBHLcombined$Title=='[Mount Arbor Nurseries materials]')]<-newBHLcombined$Volume[which(newBHLcombined$PublicationDate=='1901'&newBHLcombined$Title=='[Mount Arbor Nurseries materials]')]
#a new check on publication dates with ranges
unique(newBHLcombined$PublicationDate[grep("-", newBHLcombined$PublicationDate)])

#Fix 1881-1922
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1881-1922')])
unique(newBHLcombined$Title[which(newBHLcombined$PublicationDate=='1881-1922')])
unique(newBHLcombined$ItemID[which(newBHLcombined$Title=='Price list of fruit and ornamental trees, small fruits, evergreens, roses, etc., of the California Nursery Co')])
newBHLcombined %>% filter(ItemID=='179437') %>% select(PublicationDate,Volume,SearchedName)
newBHLcombined %>% filter(ItemID=='179961') %>% select(PublicationDate,Volume,SearchedName)
#those with itemid 179961 need the volume date as publicationdate
#first remove words from the volume column
foo <- newBHLcombined %>% filter(ItemID=="179961") %>% select(PublicationDate,Volume,SearchedName)
foo <- foo$Volume
stopwords<-c("March","Feb.","March","Fall","Spring","January","February","March","April","May","June","July","August","September","October","November","December","Winter","Ornamental","and","Fruit","Trees")
removeWords(foo,stopwords)->foo
gsub(" ", "", foo, fixed = TRUE)->foo
newBHLcombined$PublicationDate[which(newBHLcombined$ItemID=="179961")]<-foo
#back to fixing itemid 179437 
foo<-newBHLcombined %>% filter(ItemID=='179437') %>% select(PublicationDate,Volume,SearchedName)
foo$Volume<-"1921"
newBHLcombined$Volume[which(newBHLcombined$ItemID=='179437')]<-foo$Volume
newBHLcombined$PublicationDate[which(newBHLcombined$ItemID=='179437')]<-foo$Volume

#Fix those ranges starting with 1884
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1884-1891')])
unique(newBHLcombined$ItemID[which(newBHLcombined$PublicationDate=='1884-1899')])
newBHLcombined %>% filter(ItemID=="181077") %>% select(PublicationDate,Volume,SearchedName)
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1891')]<-'1890' #good
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1888')]<-'1887' #good
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1889')]<-'1888' #good
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1899')]<-'1898' #good
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1884-1892')]<-'1891' #good

#Fix the weird 1893-1898 issue
unique(newBHLcombined$ItemID[which(newBHLcombined$PublicationDate=='1893-1898')])
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1893-1898')])
newBHLcombined %>% filter(PublicationDate=='1893-1898') %>% select(PublicationDate,Volume,SearchedName,ItemID,PublisherPlace,Title)
newBHLcombined$Title[which(newBHLcombined$PublicationDate=='1893-1898')]

newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.1:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1893'

newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.2:no.12'&newBHLcombined$PublicationDate=='1893-1898')]<-'1894'

newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='V.3:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='V.3:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='V.3:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='V.3:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='V.3:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.3:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1895'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.4:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1896'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.5:no.12'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.1'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.2'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.3'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.4'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.5'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.6'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.7'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.8'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.9'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.10'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'
newBHLcombined$PublicationDate[which(newBHLcombined$Volume=='v.6:no.11'&newBHLcombined$PublicationDate=='1893-1898')]<-'1897'

#1850-1861 fix
unique(newBHLcombined$PublicationDate[grep("-", newBHLcombined$PublicationDate)])
newBHLcombined$PublicationDate[which(newBHLcombined$ItemID=='284560')]<-'1857'
newBHLcombined$PublicationDate[which(newBHLcombined$ItemID=='284064')]<-'1858'

#More fixes determined by viewing catalogs with date ranges
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1993')])
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1889-1892')]<-'1889' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1917-1920')]<-'1919' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1908-1915')]<-'1916' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1909-1919')]<-'1919' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1886-1890')]<-'1889' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1912-1914')]<-'1912' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1857-1863')]<-'1857' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1939-1941')]<-'1939' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1917-1922')]<-'1915' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1907-1913')]<-'1907' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1893-1895')]<-'1894' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1940-1942'&newBHLcombined$ItemID=='152682')]<-'1941' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1940-1942'&newBHLcombined$ItemID=='154232')]<-'1940'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1940-1942'&newBHLcombined$ItemID=='152702')]<-'1942' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1870-1880')]<-'1879' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1904-1911')]<-'1904' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1857-1872')]<-'1871' 
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1993'&newBHLcombined$ItemID=='263630')]<-'1933'

#these are not in the US so I removed them rather than fixing the dates
newBHLcombined[!(newBHLcombined$PublicationDate=='1861-1914'),]->newBHLcombined
newBHLcombined[!(newBHLcombined$PublicationDate=='1883-1914'),]->newBHLcombined
newBHLcombined[!(newBHLcombined$PublicationDate=='1895-1937'),]->newBHLcombined
newBHLcombined[!(newBHLcombined$PublicationDate=='1899-1915'),]->newBHLcombined

#what ranges are left× Check!
unique(newBHLcombined$PublicationDate[grep("-", newBHLcombined$PublicationDate)])

#check by hand the rows with larger ranges based on filtering in excel
unique(newBHLcombined$ItemUrl[which(newBHLcombined$PublicationDate=='1878-1885')])

newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1912-1918')]<-'1912'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1900-1908')]<-'1900'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1921-1929')]<-'1921'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1928-1945')]<-'1929'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1893-1897')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1893-1897')]<-'1893'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1904-1906')]<-'1904'
newBHLcombined$PublicationDate[which(newBHLcombined$PublicationDate=='1931-1934')]<-'1931'

newBHLcombined[!(newBHLcombined$PublicationDate=='1850-1870'),]->newBHLcombined #outside of US
newBHLcombined[!(newBHLcombined$PublicationDate=='1890-1903'),]->newBHLcombined #out of US
newBHLcombined[!(newBHLcombined$PublicationDate=='1781-93'),]->newBHLcombined
newBHLcombined[!(newBHLcombined$PublicationDate=='1843-1870'),]->newBHLcombined #out of US
newBHLcombined[!(newBHLcombined$PublicationDate=='1957-1972'),]->newBHLcombined #proceedings 
newBHLcombined[!(newBHLcombined$PublicationDate=='1973-1979'),]->newBHLcombined #proceedings
newBHLcombined[!(newBHLcombined$PublicationDate=='1986-1992'),]->newBHLcombined #proceedings
newBHLcombined[!(newBHLcombined$PublicationDate=='1929-1939'),]->newBHLcombined #proceedings
newBHLcombined[!(newBHLcombined$PublicationDate=='1920-1927'),]->newBHLcombined #not a catalog
newBHLcombined[!(newBHLcombined$PublicationDate=='1878-1885'),]->newBHLcombined #brazilian flora
newBHLcombined[!(newBHLcombined$PublicationDate=='1878-1885'),]->newBHLcombined #not in english flora

#####remove non-catalogs####
#remove journals/proceedings/flora
dplyr::filter(newBHLcombined, !grepl('proceedings|journ', Title,ignore.case=TRUE))->newBHLcombined
####clean scientific names####
#Find accepted names for  searched names
colnames(newBHLcombined)[2]<-"SearchedName"
library('dbplyr')
library(jsonlite)
library(stringr)

newBHLcombined$SearchedName<-str_to_sentence(newBHLcombined$SearchedName)
new_allnames<-data.frame(Scientific.Name=unique(newBHLcombined$SearchedName))
new_allnames$Scientific.Name<-gsub("×","X ",new_allnames$Scientific.Name,)
new_allnames<-data.frame(Name=new_allnames$Scientific.Name)

#install_github("ecoinfor/U.Taxonstand")
library(U.Taxonstand)
library(openxlsx)

#load TPL database (downloaded from: https://github.com/nameMatch/Database)
dat1 <- read.xlsx("Plants_WFO_database_part1.xlsx")
dat2 <- read.xlsx("Plants_WFO_database_part2.xlsx")
dat3 <- read.xlsx("Plants_WFO_database_part3.xlsx")
database <- rbind(dat1, dat2, dat3)
rm(dat1, dat2, dat3)

#names to match
spList<-new_allnames[!(is.na(new_allnames$Name)),]
res2<-nameMatch(spList=spList,spSource=database,author=FALSE,max.distance=1)
colnames(res2)[2]<-"SearchedName"
res2$SearchedName<-gsub(" NA","",res2$SearchedName)
#Most unidentified names are not plants (fish, insects, fungi, etc.) OR unresolvable hybrids remove these from newBHLcombined #611 names #7749 rows
res2_NA<-res2[is.na(res2$Accepted_SPNAME),]
res2_NA_names<-unique(res2_NA$SearchedName)
newBHLcombined$SearchedName<-gsub("×","X ",newBHLcombined$SearchedName,)
newBHLcombined<-newBHLcombined[!(newBHLcombined$SearchedName %in% res2_NA_names),]

#add accepted name to the new  data
res2<-res2 %>%
  select(SearchedName,Accepted_SPNAME)
newBHLcombined_2<-plyr::join(newBHLcombined,res2, by = "SearchedName",type="left",match="first") #only takes the first match if there are more than 1 USDAcode name per accepted name
newBHLcombined_2<-newBHLcombined_2%>%
  relocate(SearchedName,.after=PublicationDate)
#remove all NA rows and extra columns
newBHLcombined_2<-newBHLcombined_2[!(is.na(newBHLcombined_2$Accepted_SPNAME)),]

####Append USDA Codes####
#Add USDA codes from AcceptedNames from WFO
usdacodes_BHL=read.table("usdacodes_BHL.txt",sep=",",header=TRUE) #file contains all USDA codes, and USDA codes without periods (var. -> var) to account for variations in names
colnames(newBHLcombined_2)[25]<-"AcceptedName"
newBHLcombined_2<-plyr::join(newBHLcombined_2,usdacodes_BHL, by = "AcceptedName",type="left",match="all") #only takes the first match if there are more than 1 USDAcode name per accepted name
test<-unique(newBHLcombined_2[c("AcceptedName","Accepted.Symbol")])
test<-test %>% group_by(AcceptedName) %>% filter(n() > 1)
#Fix USDA codes that resulted from more than 1 match
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Acacia greggii')]<-'ACGR'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Acacia macracantha')]<-'ACMA'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Artocarpus integer')]<-'ARIN17'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Anemone multifida')]<-'ANMU'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Aristolochia grandiflora')]<-'ARGR2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Muehlenbeckia axillaris')]<-'MUAX2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Setaria palmifolia')]<-'SEPA6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Yucca brevifolia')]<-'YUBR'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Cleome spinosa')]<-'CLSP3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Crataegus coccinea')]<-'CRCHC2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Crocus vernus')]<-'CRVE4'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Diplacus grandiflorus')]<-'DIGR5'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Eucalyptus cladocalyx')]<-'EUCL'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Eucalyptus obtusiflora')]<-'EUOB11'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Festuca ovina')]<-'FEOV'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Gnaphalium uliginosum')]<-'GNUL'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Acorus calamus')]<-'ACCA4'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Centella asiatica')]<-'CEAS'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Iris sibirica')]<-'IRSI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Iris orientalis')]<-'IROR'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Monarda fistulosa')]<-'MOFI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Passiflora suberosa')]<-'PASU3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Passiflora mollissima')]<-'PATA6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Pinus caribaea')]<-'PICA18'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Dasiphora fruticosa')]<-'DAFR6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Pycnanthemum flexuosum')]<-'PYFL'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Quercus prinoides')]<-'QUPR'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ziziphus jujuba')]<-'ZIMA'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Rosa cinnamomea')]<-'ROCI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Sabatia paniculata')]<-'SABR10'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix babylonica')]<-'SABA'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix babylonica')]<-'SABA'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix exigua')]<-'SAEX'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salvinia auriculata')]<-'SAAU'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Silene latifolia')]<-'SILA21'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Silphium terebinthinaceum')]<-'SITE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Solanum villosum')]<-'SOVI8'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Alophia drummondii')]<-'ALDR2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Trimezia martinicensis')]<-'TRMA6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ampelopsis cordata')]<-'AMCO2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Acacia berlandieri')]<-'ACBE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Acacia constricta')]<-'ACCO2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Alisma lanceolatum')]<-'ALLA2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Nothoscordum gracile')]<-'NOGR3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Amaranthus graecizans')]<-'AMGR13'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Amaranthus viridis')]<-'AMVI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Amelanchier stolonifera')]<-'AMST80'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Antennaria parvifolia')]<-'ANPA4'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Antennaria umbrinella')]<-'ANUM'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Aster divaricatus')]<-'EUDI16'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Aster longifolius')]<-'SYNON'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Aster salicifolius')]<-'SYNON'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Callirhoe pedata')]<-'CAPE23'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Capsicum baccatum')]<-'CAANG'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Capsicum frutescens')]<-'CAANA4'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Celtis tenuifolia')]<-'CETE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Cestrum parqui')]<-'CEPA9'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Chloris barbata')]<-'CHBA10'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Actaea cordifolia')]<-'ACPO11'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ipomoea nil')]<-'IPNI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Crataegus columbiana')]<-'CRCHP2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Delphinium scopulorum')]<-'DESC2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Derris elliptica')]<-'DEEL3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Eleocharis obtusa')]<-'ELOB2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Eleocharis ovata')]<-'ELOV'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Epidendrum anceps')]<-'EPAN3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Escobaria tuberculosa')]<-'ESTU'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Euphorbia maculata')]<-'CHMA15'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Fritillaria liliacea')]<-'FRLI2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Fritillaria liliacea')]<-'FRLI3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Fumaria officinalis')]<-'FUOF'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Galium boreale')]<-'GABO2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Gentiana setigera')]<-'GESE2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Platanthera hyperborea')]<-'PLHY2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Helenium vernale')]<-'HEVE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Hierochloe odorata')]<-'HIOD'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ipomoea hederacea')]<-'IPHE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ipomoea triloba')]<-'IPTR2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Lespedeza violacea')]<-'LEVI6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Linum lewisii')]<-'LILE3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Malpighia glabra')]<-'MAGL6'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Malus sylvestris')]<-'MASY2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Oenothera californica')]<-'OECA2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Oenothera rhombipetala')]<-'OERH'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ophioglossum vulgatum')]<-'OPVU'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Oxalis stricta')]<-'OXST'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Paronychia pulvinata')]<-'PAPU2'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Phyllanthus distichus')]<-'PHDI8'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Physalis lanceolata')]<-'PHLA32'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Pluchea odorata')]<-'PLCA10'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Prosopis juliflora')]<-'PRJU3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Quercus texana')]<-'QUTE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Ruellia tuberosa')]<-'RUTU'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salicornia europaea')]<-'SADE10'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix cordata')]<-'SACO3'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix arctica')]<-'SAAR27'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salix speciosa')]<-'SAALA'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salvia virgata')]<-'SAVI18'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Salvinia natans')]<-'SANA5'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Solanum nigrum')]<-'SONI'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Tillandsia tenuifolia')]<-'TITE'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Verbena bonariensis')]<-'VEBO'
newBHLcombined_2$Accepted.Symbol[which(newBHLcombined_2$AcceptedName=='Yucca rupicola')]<-'YURU'
newBHLcombined_2<-newBHLcombined_2[-c(27,28,29)] #remove extra columns
newBHLcombined_2<-distinct(newBHLcombined_2)#remove duplicates
colnames(newBHLcombined_2)[26]<-"USDAcode" #rename column w/ codes

##Fix some USDA codes by hand 
usdacodes_resolved=read.table("taxa_to_code_fix_novarspp.txt",sep=",",header=TRUE) #file containing fixes by hand
newBHLcombined_2<-left_join(newBHLcombined_2,usdacodes_resolved,by="AcceptedName")
for(i in 1:length(newBHLcombined_2$BHLType)){
  if(!(is.na(newBHLcombined_2$USDAcode.y[i]))){
    newBHLcombined_2$USDAcode.x[i]<-newBHLcombined_2$USDAcode.y[i]}
} 
newBHLcombined_2<-newBHLcombined_2[-27]
colnames(newBHLcombined_2)[26]<-'USDAcode'

#resolve some remaining names by hand 
unique(newBHLcombined_2$AcceptedName[which(is.na(newBHLcombined_2$USDAcode))])
BHL_final<-newBHLcombined_2
unique(BHL_final$AcceptedName[is.na(BHL_final$USDAcode)])
#Other accepted names found in USDA plants as a synonym
BHL_final$USDAcode[which(BHL_final$AcceptedName=="×Solidaster luteus")]<-"SOLU10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Caragana ×sophorifolia")]<-"CAS09"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Caragana arborescens var. pendula")]<-"CAAR18"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Colutea ×media")]<-"COME12"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Deutzia ×lemoinei var. compacta")]<-"DELE9"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Deutzia ×lemoinei")]<-"DELE9"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Deutzia ×magnifica")]<-"DEMA10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Erysimum ×allionii")]<-"ERMA17"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Hypericum patulum var. henryi")]<-"HYBE3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Iris ×flexicaulis")]<-"IRHEF"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Narcissus ×intermedius")]<-"NAIN6"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Philadelphus ×virginalis")]<-"PHVI16"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Picea ×albertiana")]<-"PIAL4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Prunus ×yedoensis")]<-"PRYE"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Viola ×palmata")]<-"VIPA18"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Viola ×viarum")]<-"VIVI10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Adiantum lunulatum")]<-"ADPH"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Allium sphaerocephalon")]<-"ALSP4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Zephyranthes atamasco")]<-"ZEAT"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Bothriochloa saccharoides var  saccharoides")]<-"BOSA"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Andropogon gerardii ssp  hallii")]<-"ANHA"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Dendrocalamus giganteus")]<-"DEGI2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Synthyris wyomingensis")]<-"BEWY"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Kopsiopsis hookerim")]<-"BOHO"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Quadrella cynophallophora")]<-"CACY"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Senna auriculata")]<-"CAAU19"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Senna artemisioides ssp. ×coriacea")]<-"SEARC"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Senna surattensis ssp  sulfurea")]<-"SESU10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Senna surattensis ssp  surattensis")]<-"SESU4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Zeltnera venusta")]<-"CEVE3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Prunus ilicifolia var  ilicifolia")]<-"PRIL"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinocereus coccineus ssp  paucispinus")]<-"ECCOP"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Ericameria nauseosa var  nauseosa")]<-"ERNAN5"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Clinopodium carolinianum")]<-"CLGE"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Clitoria laurifolia")]<-"CLLA4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Collinsonia anisata")]<-"COSE11"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Corydalis pauciflora")]<-"COPA11"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Coryphantha georgii")]<-"COVI18"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Coryphantha scolymoides")]<-"COSC12"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Cotoneaster insignis")]<-"COIN15"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Cucurbita argyrosperma")]<-"CUMI3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Cucurbita pepo ssp  pepo")]<-"CUPE"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Callitropsis forbsii")]<-"HEF010"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Cynoglossum creticum")]<-"CYCR11"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Dermatocarpon luridum")]<-"DELU60"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Epiphyllum ackermanii")]<-"EPAC2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Eriophyllum staechadifolium")]<-"ERST9"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Euphorbia dulcis")]<-"CHDE6"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Euphorbia meloformis ssp  valida")]<-"EUVA5"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Gaultheria pyroloides")]<-"GAMI2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Kohleria trianae")]<-"KOER3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Ipomopsis spicata var  cephaloidea")]<-"IPSPC2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Gladiolus murielae")]<-"GLMU"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Crocanthemum aldersonii")]<-"HESC2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Juniperus macrocarpa")]<-"JUOXM2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Mulgedium oblongifolium")]<-"LATAP"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Paysonia grandiflora")]<-"LEGR3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinopsis maximiliana")]<-"LOCO20"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinopsis lateritia")]<-"LOLA10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Lonchocarpus domingensis")]<-"LODO5"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Acmispon humistratus")]<-"LOHU2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Dieteria canescens var  canescens")]<-"MACAC3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Dieteria canescens var  sessiliflora")]<-"MACAS2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Musa nana")]<-"MUNA"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Nephelium ramboutan ake")]<-"NEMU5"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Chylismia brevipes ssp  brevipes")]<-"CABRB4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Chylismia multijuga")]<-"CAMU13"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Ormosia calavensis")]<-"ORCA12"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinochloa polystachya var  spectabilis")]<-"ECPO3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Papaver heterophyllum")]<-"STHE3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Parkia biglobosa")]<-"PACL9"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Paspalum ceresia")]<-"PATE19"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Peltophorum dubium")]<-"PEDU3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Penstemon")]<-"PENST"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Philodendron undulatum")]<-"PHUN3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Phoenix loureiroi")]<-"PHLO13"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Phyllostachys nigra var  henonis")]<-"PHNI80"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Pteridium aquilinum ssp  latiusculum")]<-"PTAQL"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Rosenbergiodendron formosum")]<-"RAFO2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Annona mucosa")]<-"ROPU3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Rosa carolina ssp  carolina")]<-"ROCA4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Rosa nutkana ssp  macdougalii")]<-"RONUH"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Clinopodium nepeta ssp  glandulosum")]<-"CANEG"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Silene catesbaei")]<-"SIVI4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Smelowskia americana")]<-"SMCAA"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Solidago velutina ssp  sparsiflora")]<-"SOVE6"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Solidago X luteus")]<-"SOLU10"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Handroanthus chrysanthus")]<-"TACH3"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Handroanthus capitatus")]<-"TACA17"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Handroanthus serratifolius")]<-"TASE4"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Tillandsia streptophylla")]<-"TIPA2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinopsis atacamensis ssp  pasacana")]<-"ECPA8"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Echinopsis glauca")]<-"TRUY"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Triteleia lilacina")]<-"TRLI8"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Anticlea elegans var  elegans")]<-"ZIEL2"
BHL_final$USDAcode[which(BHL_final$AcceptedName=="Kopsiopsis hookeri")]<-"BOHO"

#Remove those outside of the L48 US
BHL_final<-BHL_final[!grepl("Alaska",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Hawaii",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Honolulu",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Alaska",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Canada",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Peterborough Ontario",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Port Burwell Ontario",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Simcoe Ontario",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Manitoba",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Saskatoon",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Alberta",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("BC",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Toronto",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Ottawa Ont",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Montreal",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Winnipeg",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Winnepeg Man",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Brandon Man",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("London",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Dublin",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("England",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Belgium",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Aalsmeer",BHL_final$PublisherPlace),]
BHL_final<-BHL_final[!grepl("Boskoop",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Germany",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Heemstede ",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Haarlem",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Hillegom",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Heemstede ",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Lisse Holland",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("ogelenzang near Haarlem Holland",BHL_final$PublisherPlace),] 
BHL_final<-BHL_final[!grepl("Honduras",BHL_final$PublisherPlace),]


BHL_final$USDAcode<-trimws(BHL_final$USDAcode, which = "b") #remove white space from USDAcodes

####Add growth habit####
#add growth habit
growthhabits=read.csv("USDAgrowthhabitbyUSDAid.csv",header=TRUE)
#fix weird column name
colnames(growthhabits)[1] <- gsub('^...','',colnames(growthhabits)[1])
as.data.frame(growthhabits)->growthhabits

BHL_final<-left_join(BHL_final,growthhabits,by="USDAcode")
####Add USDA Status####
#USDAplants
setwd("C:/Users/mfert/OneDrive - University of Massachusetts/Year1")
status = read.table('usdacodes_BHL.txt',sep=",",header=TRUE)


#Change native status column to just native vs. introduced

#Get codes that are native
natives <- filter(status, grepl('L48\\(N\\)', Native.Status))
natives<-natives[!duplicated(natives$Accepted.Symbol),]

introduced <- filter(status, grepl('L48\\(I\\)', Native.Status))
introduced<-introduced[!duplicated(introduced$Accepted.Symbol),]

introduced_native <- filter(status, grepl('L48\\(I,N\\)', Native.Status))
introduced_native<-introduced_native[!duplicated(introduced_native$Accepted.Symbol),]

#add row for introduced and native for both and then combine
introduced$status <- 'introduced'
natives$status <- 'native'
introduced_native$status<-'introduced/native'

rbind(introduced,natives,introduced_native)->usdaplantstatus
usdaplantstatus<-usdaplantstatus %>%
  select(Accepted.Symbol,status)
colnames(usdaplantstatus)<-c('USDAcode','USDAstatus')

BHL_final<-left_join(BHL_final,usdaplantstatus,by="USDAcode")

#GPI database (identify invasives)
GPI<-read.csv('BHL_GPI.csv')
BHL_final<-left_join(BHL_final,GPI,by="USDAcode")
BHL_final<-BHL_final[-29]
#GSID
#GISD web scraping (source: https://naturaldatasolutions.com/2018/11/28/scraping-and-visualizing-the-gisd-with-r/)
library(robotstxt)  # check website scraping rules
library(readr)  # reading data
library(dplyr)  # "wrangling" data
library(rvest)  # web scraping
library(xfun)
library(knitr)  # HTML table creation
library(kableExtra)  # additional HTML table formatting

#load in species list
introducedspecies<-unique(BHL_final$AcceptedName[which(BHL_final$USDAstatus=='introduced'|BHL_final$USDAstatus=='introduced/native')])
introducedspecies<-as.data.frame(introducedspecies)
colnames(introducedspecies)<-"Species"
introducedspecies<-introducedspecies[!grepl("X ", introducedspecies$Species,ignore.case=FALSE),]
introducedspecies<-as.data.frame(introducedspecies)

SppList <- introducedspecies
# to display some of this loaded data frame as an HTML table: 
kable(SppList[1:5,]) %>% #first 5 rows to test it
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
#create urls
SppList <- SppList %>% 
  tidyr::separate(introducedspecies, c("genus", "species"), sep = " ", remove = FALSE) %>% 
  tidyr::unite(c(genus, species), col="genspp", sep = "+", remove = FALSE) %>% 
  mutate(url=paste0("http://www.iucngisd.org/gisd/speciesname/", genspp)) %>% 
  select(-genspp)
SppList[1:5,]$url  # display the first 5 URLs

urls <- SppList[1:2394,]$url
sppnames <- SppList[1:2394,]$introducedspecies
a_status <- vector(mode = "list", length = length(urls))
names(a_status) <- sppnames

for (i in 1:length(urls)) {
  sp.url <- urls[i]
  sp.node <- '[id=spe-title]'
  a_status[[i]] <- read_html(sp.url) %>% html_nodes(sp.node) %>% html_text()
}

a_statuses<-sapply(a_status,function(x) x[1])
a_statuses<-as.data.frame(a_statuses)
a_statuses<-a_statuses[!is.na(a_statuses$a_status),]
a_statuses<-trimws(a_statuses,which="right")
a_statuses<-as.data.frame(a_statuses)
colnames(a_statuses)<-"species"
#append USDA codes to these species
library(data.table)
setwd("C:/Users/mfert/OneDrive - University of Massachusetts/Year1")
usdacodes=fread("usdacodes_BHL.txt")

a_statuses$USDAcode<-NA

for(i in 1:length(a_statuses$species)){
  which(usdacodes$AcceptedName==a_statuses$species[i])->match
  if(length(match)>=2){
    a_statuses$USDAcode[i]<-usdacodes$Accepted.Symbol[match[1]]}
  if(length(match)==0){
    a_statuses$USDAcode[i]<-'undefined'}
  if(length(match)==1){
    a_statuses$USDAcode[i]<-usdacodes$Accepted.Symbol[match]}
}

a_statuses$USDAcode[which(a_statuses$species=='Cenchrus setaceus')]<-'PESE3'
  
#now have invasive species from GSID that are in my dataset
a_statuses$GSID_status<-'invasive'
a_statuses<-a_statuses %>%
  distinct(USDAcode,.keep_all=TRUE)
BHL_final<-left_join(BHL_final,a_statuses,by="USDAcode")

BHL_final<-select(BHL_final,c("USDAcode","ItemID","ItemUrl","SearchedName","Authors","AcceptedName","PublisherPlace","PublicationDate","Title","Habit","USDAstatus","GPI_status","GSID_status"))
####Add coordinates####
library(data.table)
geocodeiofinal=fread("geocodelocations_geocodio.csv",header=TRUE) #this file was generated using all unique localities in the dataset input to the geocoding website: geocod.io
as.data.frame(geocodeiofinal)->geocodeiofinal
colnames(geocodeiofinal)[2]<-"PublisherPlace"
geocodeiofinal<-geocodeiofinal %>%
  select(PublisherPlace, Latitude_r,Longitude_r)
geocodeiofinal<-geocodeiofinal[!is.na(geocodeiofinal$PublisherPlace),]
geocodeiofinal<-distinct(geocodeiofinal)
BHL_final<-left_join(BHL_final,geocodeiofinal,by="PublisherPlace") 


#most missing coordinates are outside the US or have NA PublisherPlace
unique(BHL_final$PublisherPlace[which(BHL_final$Latitude_r=='0')])
length(BHL_final$PublisherPlace[which(BHL_final$Latitude=='0')])
length(BHL_final$Latitude_r[is.na(BHL_final$Latitude_r)])
BHL_final<-BHL_final[!(BHL_final$Latitude_r=='0'),]
colnames(BHL_final)[14:15]<-c("Latitude","Longitude")


####More misc. fixes####
BHL_final$PublicationDate[which(BHL_final$PublicationDate=='nd')]<-NA
BHL_final$USDA_AcceptedName[which(BHL_final$USDA_AcceptedName=="'Hypericum repens")]<-"Hypericum repens"
BHL_final$USDA_AcceptedName<-gsub("×","x ",BHL_final$USDA_AcceptedName,)
BHL_final$USDA_AcceptedName<-gsub("X ","x ",BHL_final$USDA_AcceptedName,)
BHL_final$SearchedName<-gsub("×","x ",BHL_final$SearchedName,)
BHL_final$SearchedName[which(BHL_final$SearchedName=='x solidaster luteus')]<-'x Solidaster luteus'
BHL_final$SearchedName[which(BHL_final$SearchedName=='Uva-ursi uva-ursi')]<-'Uva Ursi uva ursi'
BHL_final$SearchedName[which(BHL_final$SearchedName=='Uva ursi uva ursi')]<-'Uva Ursi uva ursi'
BHL_final$SearchedName[which(BHL_final$SearchedName=='Frangula asplenifolia')]<-'Rhamnus frangula'
BHL_final$SearchedName[which(BHL_final$SearchedName=='Salix sepulcralis')]<-'Salix x sepulcralis'
#update introduction status labels
BHL_final$USDAstatus[which(BHL_final$USDAstatus=='introduced')]<-"I"
BHL_final$USDAstatus[which(BHL_final$USDAstatus=='native')]<-"N"
BHL_final$USDAstatus[which(BHL_final$USDAstatus=='introduced/native')]<-"I/N"
#Remove duplicates from synonyms searches
BHL_final_backup<-BHL_final #backup
#BHL_final<-BHL_final_backup
test <-BHL_final %>%  group_by(ItemID,AcceptedName) %>% filter(n()>1) 
BHL_final<-BHL_final[!duplicated(BHL_final[,c("ItemID","AcceptedName")]),] #removes duplicate rows that resulted from different searched names but same accepted name and are from the same catalog (ItemID)
BHL_final<-BHL_final[!is.na(BHL_final$ItemID),]
colnames(BHL_final)[5]<-"NurseryName"
write.csv(BHL_final,'BHL_final_FULL.csv')

####Add data from 'Restoring American Gardens'#### 
RAGdata<-read.csv('HistUSOrnPlants_Adams_2004.csv',header=TRUE)
RAGdata$TaxonName<-str_replace(RAGdata$TaxonName,"Ã-","× ")
RAGdata<-RAGdata %>%
  dplyr::select(TaxonName,NurseryYear,NurseryCity,NurseryState,NurseryName,NurseryLatitude,NurseryLongitude)
RAGdata$PublisherPlace<-str_c(RAGdata$NurseryCity," ",RAGdata$NurseryState)
RAGdata<-RAGdata[-c(3:4)]
####clean RAG scientific names####
#names to match
colnames(RAGdata)[1]<-"SearchedName"
spList<-unique(RAGdata$SearchedName)
res<-nameMatch(spList=spList,spSource=database,author=FALSE,max.distance=1)
res$Accepted_SPNAME[is.na(res$Accepted_SPNAME)]<-res$Name_spLev[is.na(res$Accepted_SPNAME)]
colnames(res)[2]<-"SearchedName"
test<-data.frame(name=spList)
test$SORTER<-seq(1:length(test$name))
test<-left_join(res,test,by="SORTER")
res2<-test %>%
  select(name,Accepted_SPNAME)
colnames(res2)[1]<-"SearchedName"
RAGdata_2<-plyr::join(RAGdata,res2, by = "SearchedName",type="left",match="first") #only takes the first match 
RAGdata_2<-RAGdata_2[!is.na(RAGdata_2$Accepted_SPNAME),] #a few species are incorrect and were removed (4 records total)
colnames(RAGdata_2)[7]<-"AcceptedName"
####Append RAG USDA codes####
RAGdata_2<-plyr::join(RAGdata_2,usdacodes_BHL, by = "AcceptedName",type="left",match="all") #only takes the first match if there are more than 1 USDAcode name per accepted name
test<-unique(RAGdata_2[c("AcceptedName","USDAcode")])
test<-test %>% group_by(AcceptedName) %>% filter(n() > 1)
#Fix by hand
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Acorus calamus')]<-'ACCA4'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Ampelopsis cordata')]<-'AMCO2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Aster divaricatus')]<-'EUDI16'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Aster longifolius')]<-'SYNON'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Callirhoe pedata')]<-'CAPE23'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Cestrum parqui')]<-'CEPA9'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Setaria palmifolia')]<-'SEPA6'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Chloris barbata')]<-'CHBA10'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Actaea cordifolia')]<-'ACPO11'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Cleome spinosa')]<-'CLSP3'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Ipomoea nil')]<-'IPNI'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Pluchea odorata')]<-'PLOD'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Crataegus coccinea')]<-'CRCHC2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Crocus vernus')]<-'CRVE4'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Eucalyptus cladocalyx')]<-'EUCL'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Eucalyptus obtusiflora')]<-'EUOB11'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Galium boreale')]<-'GABO2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Gnaphalium uliginosum')]<-'GNUL'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Platanthera hyperborea')]<-'PLHY2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Ipomoea hederacea')]<-'IPHE'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Iris sibirica')]<-'IRSI'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Iris orientalis')]<-'IROR'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Salvia virgata')]<-'SAVI18'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Lespedeza violacea')]<-'LEVI6'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Linum lewisii')]<-'LILE3'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Silene latifolia')]<-'SILA21'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Malpighia glabra')]<-'MAGL6'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Monarda fistulosa')]<-'MOFI'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Nothoscordum gracile')]<-'NOGR3'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Oenothera californica')]<-'OECA2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Ophioglossum vulgatum')]<-'OPVU'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Passiflora mollissima')]<-'PATA6'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Pycnanthemum flexuosum')]<-'PYFL'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Quercus prinoides')]<-'QUPR'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Salix babylonica')]<-'SABA'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Salix cordata')]<-'SACO3'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Scutellaria wrightii')]<-'SCWR2'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Silphium terebinthinaceum')]<-'SITE'
RAGdata_2$Accepted.Symbol[which(RAGdata_2$AcceptedName=='Ziziphus jujuba')]<-'ZIMA'
RAGdata_2<-RAGdata_2[-c(9:11)]
RAGdata_2<-distinct(RAGdata_2)#remove duplicates
colnames(RAGdata_2)[8]<-"USDAcode"

##Fix some USDA codes by hand 
usdacodes_resolved=read.table("taxa_to_code_fix_novarspp.txt",sep=",",header=TRUE) #file containing fixes by hand
RAGdata_2<-left_join(RAGdata_2,usdacodes_resolved,by="AcceptedName")
for(i in 1:length(RAGdata_2$SearchedName)){
  if(!(is.na(RAGdata_2$USDAcode.y[i]))){
    RAGdata_2$USDAcode.x[i]<-RAGdata_2$USDAcode.y[i]}
} 
RAGdata_2<-RAGdata_2[-9]
colnames(RAGdata_2)[8]<-'USDAcode'

RAGdata_2$USDAcode<-trimws(RAGdata_2$USDAcode, which = "b") #remove white space from USDAcodes

####Add RAG USDA status +growth habit####
rbind(introduced,natives,introduced_native)->usdaplantstatus
usdaplantstatus<-usdaplantstatus %>%
  dplyr::select(Accepted.Symbol,AcceptedName,status)
colnames(usdaplantstatus)<-c('USDAcode','AcceptedName','USDAstatus')
RAGdata_2<-left_join(RAGdata_2,usdaplantstatus,by="USDAcode")
RAGdata_2<-RAGdata_2[-9]
colnames(RAGdata_2)[7]<-'AcceptedName'
# RAG growth habit
RAGdata_2<-left_join(RAGdata_2,growthhabits,by="USDAcode")

#GPI database (identify invasives)
RAGdata_2<-left_join(RAGdata_2,GPI,by="USDAcode")
RAGdata_2<-RAGdata_2[-11]
#GSID
#GISD web scraping (source: https://naturaldatasolutions.com/2018/11/28/scraping-and-visualizing-the-gisd-with-r/)\
#load in species list
introducedspecies<-unique(RAGdata_2$AcceptedName[which(RAGdata_2$USDAstatus=='introduced'|RAGdata_2$USDAstatus=='introduced/native')])
introducedspecies<-as.data.frame(introducedspecies)
colnames(introducedspecies)<-"Species"
introducedspecies<-introducedspecies[!grepl("X ", introducedspecies$Species,ignore.case=FALSE),]
introducedspecies<-as.data.frame(introducedspecies)

SppList <- introducedspecies
# to display some of this loaded data frame as an HTML table: 
kable(SppList[1:5,]) %>% #first 5 rows to test it
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
#create urls
SppList <- SppList %>% 
  tidyr::separate(introducedspecies, c("genus", "species"), sep = " ", remove = FALSE) %>% 
  tidyr::unite(c(genus, species), col="genspp", sep = "+", remove = FALSE) %>% 
  mutate(url=paste0("http://www.iucngisd.org/gisd/speciesname/", genspp)) %>% 
  select(-genspp)
SppList[1:5,]$url  # display the first 5 URLs


urls <- SppList[1:1186,]$url
sppnames <- SppList[1:1186,]$introducedspecies
a_status <- vector(mode = "list", length = length(urls))
names(a_status) <- sppnames

for (i in 1:length(urls)) {
  sp.url <- urls[i]
  sp.node <- '[id=spe-title]'
  a_status[[i]] <- xml2::read_html(sp.url) %>% html_nodes(sp.node) %>% html_text()
}

a_statuses<-sapply(a_status,function(x) x[1])
a_statuses<-as.data.frame(a_statuses)
a_statuses<-a_statuses[!is.na(a_statuses$a_status),]
a_statuses<-trimws(a_statuses,which="right")
a_statuses<-as.data.frame(a_statuses)
colnames(a_statuses)<-"species"
#append USDA codes to these species
library(data.table)
setwd("C:/Users/mfert/OneDrive - University of Massachusetts/Year1")

a_statuses$USDAcode<-NA

for(i in 1:length(a_statuses$species)){
  which(usdaplantstatus$AcceptedName==a_statuses$species[i])->match
  if(length(match)>=2){
    a_statuses$USDAcode[i]<-usdaplantstatus$Accepted.Symbol[match[1]]}
  if(length(match)==0){
    a_statuses$USDAcode[i]<-'undefined'}
  if(length(match)==1){
    a_statuses$USDAcode[i]<-usdaplantstatus$Accepted.Symbol[match]}
}

#now have invasive species from GSID that are in my dataset
a_statuses$GSID_status<-'invasive'
a_statuses<-a_statuses %>%
  distinct(USDAcode,.keep_all=TRUE)
RAGdata_2<-left_join(RAGdata_2,a_statuses,by="USDAcode")
RAGdata_2<-RAGdata_2[-12]
colnames(RAGdata_2)[2]<-"PublicationDate"
colnames(RAGdata_2)[4]<-"Latitude"
colnames(RAGdata_2)[5]<-"Longitude"
RAGdata_2$ItemID<-NA
RAGdata_2$ItemUrl<-NA
RAGdata_2$Authors<-NA
RAGdata_2$Title<-NA
RAGdata_2$USDAstatus[which(RAGdata_2$USDAstatus=='introduced')]<-"I"
RAGdata_2$USDAstatus[which(RAGdata_2$USDAstatus=='native')]<-"N"
RAGdata_2$USDAstatus[which(RAGdata_2$USDAstatus=='introduced/native')]<-"I/N"

RAGdata_2<-dplyr::select(RAGdata_2,c("USDAcode","ItemID","ItemUrl","SearchedName","NurseryName","AcceptedName","PublisherPlace","PublicationDate","Title","Habit","USDAstatus","GPI_status","GSID_status","Latitude","Longitude"))
BHL_final$Source<-"BHL"
RAGdata_2$Source<-"RAG"
####combine BHL and RAG####
BHL_RAG<-rbind(BHL_final,RAGdata_2)

#combine GPI and GSID into single invasive status column
for(i in 1:length(BHL_RAG$GPI_status)){
  if(is.na(BHL_RAG$GPI_status[i])){
    BHL_RAG$GPI_status[i]<-BHL_RAG$GSID_status[i]}
}

#when above is done remove GSID row and relabel GPI row
BHL_RAG<-BHL_RAG[-13]
colnames(BHL_RAG)[12]<-"invasive_status"

####Add uniform state and municipality from coordinates####
BHL_RAG$Latitude[which(BHL_RAG$PublisherPlace=='Hebronville Mass')]<-'41.938976'
BHL_RAG$Longitude[which(BHL_RAG$PublisherPlace=='Hebronville Mass')]<-'-71.302297'
BHL_RAG$Latitude[which(BHL_RAG$PublisherPlace=='Hebronville Bristol County Mass')]<-'41.938976'
BHL_RAG$Longitude[which(BHL_RAG$PublisherPlace=='Hebronville Bristol County Mass')]<-'-71.302297'
BHL_RAG$Latitude[which(BHL_RAG$PublisherPlace=="Dayton's Bluff Sta  St Paul Minn")]<-'44.9476'
BHL_RAG$Latitude<-as.numeric(BHL_RAG$Latitude)
BHL_RAG$Longitude<-as.numeric(BHL_RAG$Longitude)


coords<-read.csv('coords_geocodio.csv')
coords<-coords %>%
  dplyr::select(Latitude,Longitude,City,State)
coords$Latitude<-as.numeric(coords$Latitude)
coords$Longitude<-as.numeric(coords$Longitude)
BHL_RAG<-left_join(BHL_RAG,coords,by=c("Latitude","Longitude"))
BHL_RAG$PublicationDate[which(BHL_RAG$ItemID=='172378')]<-'1898'
BHL_RAG$PublicationDate[which(BHL_RAG$ItemID=='163528')]<-'1894'
BHL_RAG$PublicationDate[which(BHL_RAG$ItemID=='162639')]<-'1892'
###Misc. fixes####
#some of the most modern records need to be removed - not catalogs
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='... Subtropical Food Technology Conference ...')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='Sugar beet research')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='Record of decision and final environmental impact statement Spears vegetation management project : Lookout Mountain Ranger District, Ochoco National Forest, Crook and Wheeler counties, Oregon')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='Pretty Tree Bench vegetation project : final environmental impact statement')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='A guide for U.S. Customs inspectors sampling seed : offered for importation under the Federal Seed Act')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='Plant biotechnology in China : trip report, September 16-30, 1993')
BHL_RAG<-BHL_RAG%>%
  filter(is.na(Title)|Title!='Effects of agricultural practices upon mycorrhizal fungi')
BHL_RAG$USDAcode[which(BHL_RAG$AcceptedName=='Juniperus macrocarpa')]<-'JUOXM2'
BHL_RAG$Habit[which(BHL_RAG$AcceptedName=='Juniperus macrocarpa')]<-'Shrub'
BHL_RAG$USDAstatus[which(BHL_RAG$AcceptedName=='Cestrum parqui')]<-'I'
BHL_RAG$invasive_status[which(BHL_RAG$AcceptedName=='Cestrum parqui')]<-'invasive'
BHL_RAG$USDAstatus[which(BHL_RAG$AcceptedName=='Salix babylonica')]<-'I'
BHL_RAG$invasive_status[which(BHL_RAG$AcceptedName=='Salix babylonica')]<-'invasive'
#Clean Nursery Names
BHL_RAG$NurseryName<-gsub("Henry G. Gilbert Nursery and Seed Trade Catalog Collection","",BHL_RAG$NurseryName) #remove collection'
BHL_RAG$NurseryName<-gsub("[[:punct:]]+","",BHL_RAG$NurseryName) #remove punctuation
BHL_RAG$NurseryName<-gsub("Liberty Hyde Bailey Hortorium Ethel Z Bailey Horticultural Catalogue Collection","",BHL_RAG$NurseryName) #remove collection
BHL_RAG$USDAstatus[which(!is.na(BHL_RAG$USDAcode)&is.na(BHL_RAG$USDAstatus))]<-'unknown'
#Remove duplicate RAG records with different SearchedName, but same AcceptedName
BHL<-BHL_RAG %>%
  filter(Source=='BHL')
RAG<-BHL_RAG %>%
  filter(Source=='RAG')
RAG2<-RAG[!duplicated(RAG[,c("ItemID","AcceptedName")]),]
BHL_RAG<-rbind(BHL,RAG2)

####add ItemID for RAG records by unique NurseryName and PublicationDate####
RAG_data<-BHL_RAG[which(BHL_RAG$Source=='RAG'),]
RAGcatalogs<-unique(RAG_data[,c('NurseryName','PublicationDate')])
RAGcatalogs$ItemID<-sprintf("RAG%s",seq(001:319))
RAGcatalogs$Source<-'RAG'
BHL_RAG<-merge(BHL_RAG,RAGcatalogs,by=c("NurseryName","PublicationDate","Source"),all.x=TRUE)
BHL_RAG$ItemID.x<-ifelse(is.na(BHL_RAG$ItemID.y),BHL_RAG$ItemID.x,BHL_RAG$ItemID.y)
BHL_RAG<-BHL_RAG[-18]
colnames(BHL_RAG)[5]<-'ItemID'
####Add U.S. regulated plants####
regulated<-read.csv('L48regulatedPlants.csv')
regulated_codes<-data.frame(USDAcode=unique(regulated$USDA.Code))
regulated_codes$Regulated<-"Yes"
BHL_RAG<-left_join(BHL_RAG,regulated_codes,by="USDAcode")
BHL_RAG$Regulated[is.na(BHL_RAG$Regulated)]<-"No"
write.csv(BHL_RAG,'BHL_RAG.csv',row.names=FALSE)
####Create data for Figure 1####
test<-BHL_RAG %>%
  dplyr::select(Latitude, Longitude, AcceptedName) %>%
  dplyr::group_by(Latitude,Longitude) %>%
  #dplyr::mutate(Latitude=as.numeric(Latitude)) %>%
  #dplyr::mutate(Longitude=as.numeric(Longitude)) %>%
  na.omit() %>%
  distinct() %>%
  dplyr::mutate(n_species = n())
test$n_species<-as.numeric(test$n_species)
test<-test[-3]
test<-distinct(test)

write.csv(test,'BHL_RAG_figure_data.csv',row.names=FALSE)

####Summary Stats####
#records by status
test<-BHL_RAG %>%
  group_by(USDAstatus)%>%
  summarise(n=n())
length(BHL_RAG$AcceptedName[which(BHL_RAG$invasive_status=='invasive')]) #746,251

#species by status
test<-BHL_RAG %>%
  filter(!is.na(AcceptedName)) %>%
  group_by(USDAstatus) %>%
  summarise(n=n_distinct(AcceptedName))

test<-BHL_RAG %>%
  filter(!is.na(AcceptedName)) %>%
  group_by(USDAstatus,invasive_status) %>%
  summarise(n=n_distinct(AcceptedName))
length(unique(BHL_RAG$AcceptedName[which(BHL_RAG$invasive_status=='invasive')])) #1716

# of species names in a catalog
test<-BHL_RAG %>%
  filter(!is.na(ItemID)) %>%
  group_by(ItemID) %>%
  summarise(n_distinct(AcceptedName))
sum(test$`n_distinct(AcceptedName)`)/length(test$ItemID)
median(test$`n_distinct(AcceptedName)`)


#number of catalogs per species
test<-BHL_RAG %>%
  filter(!is.na(AcceptedName)) %>%
  group_by(AcceptedName)%>%
  summarise(n_distinct(ItemID))
sum(test$`n_distinct(ItemID)`)/length(test$AcceptedName) #mean
max(test$`n_distinct(ItemID)`)-min(test$`n_distinct(ItemID)`) #range
median(test$`n_distinct(ItemID)`) #median
length(test$AcceptedName[which(test$`n_distinct(ItemID)`<100)]) #num less than 100
length(test$AcceptedName[which(test$`n_distinct(ItemID)`<10)]) #num less than 10
length(test$AcceptedName[which(test$`n_distinct(ItemID)`==1)]) #num equal 1

#number of catalogs by status
#broken down by status
test<-BHL_RAG %>%
  filter(!is.na(AcceptedName)) %>%
  group_by(AcceptedName,USDAstatus,invasive_status)%>%
  summarise(n_distinct(ItemID))
sum(test$`n_distinct(ItemID)`[which(test$USDAstatus=='I')])/length(test$AcceptedName[which(test$USDAstatus=='I')]) #mean introduced
sum(test$`n_distinct(ItemID)`[which(test$USDAstatus=='N')])/length(test$AcceptedName[which(test$USDAstatus=='N')]) #mean native
sum(test$`n_distinct(ItemID)`[which(test$invasive_status=='invasive')])/length(test$AcceptedName[which(test$invasive_status=='invasive')]) #mean invasive
median(test$`n_distinct(ItemID)`[which(test$USDAstatus=='I')])
median(test$`n_distinct(ItemID)`[which(test$USDAstatus=='N')])
median(test$`n_distinct(ItemID)`[which(test$invasive_status=='invasive')])

#avg num years w/ records per species
test<-BHL_RAG %>%
  filter(!is.na(AcceptedName)) %>%
  group_by(AcceptedName) %>%
  summarise(n_distinct(PublicationDate))

sum(test$`n_distinct(PublicationDate)`)/length(test$AcceptedName)
median(test$`n_distinct(PublicationDate)`)
max(test$`n_distinct(PublicationDate)`)
min(test$`n_distinct(PublicationDate)`)
median(test$`n_distinct(PublicationDate)`)

#of records per source
length(BHL_RAG$USDAcode[which(BHL_RAG$Source=='BHL')])
length(BHL_RAG$USDAcode[which(BHL_RAG$Source=='RAG')])

#bar plot
BHL_RAG$PublicationDate<-as.integer(BHL_RAG$PublicationDate)
BHL_RAG$USDAstatus<-factor(BHL_RAG$USDAstatus,levels=c("N","I/N","I",NA))
p <-
  ggplot(BHL_RAG, aes(x=PublicationDate,fill=USDAstatus)) +
  geom_histogram(binwidth=10,boundary=0,closed="left")+
  scale_x_continuous(breaks=seq(1710,1980,10))+
  scale_y_continuous(expand=c(0,0),labels=scales::comma)+
  scale_fill_manual(values=c("grey80","grey65","grey50"),na.value="grey20")+
  labs(fill="USDA status")+
  ylab("Number of offerings")+
  xlab("Year of Publication")+
  theme(panel.grid.major = element_blank(),panel.grid.minor=element_blank(),axis.text.x=element_text(angle=90),panel.background=element_blank(),axis.line=element_line(color="black"))

plot(p)

p <-
  ggplot(BHL_RAG, aes(x=PublicationDate)) +
  geom_histogram(binwidth=10,boundary=0,closed="left",color="white")+
  scale_x_continuous(breaks=seq(1710,1980,10))+
  scale_y_continuous(expand=c(0,0),labels=scales::comma)+
  ylab("Number of records")+
  xlab("Year of publication")+
  theme(panel.grid.major = element_blank(),panel.grid.minor=element_blank(),axis.text.x=element_text(angle=90,vjust=0.25),panel.background=element_blank(),axis.line=element_line(color="black"),plot.margin=margin(5.5,8.5,5.5,5.5))
plot(p)
ggsave('yrs_hist.png',p,dpi=300,width=4.5,height=5.25,units="in")

####Create 2 files####
BHL_RAG$SearchedName<-str_replace(BHL_RAG$SearchedName," ×  "," × ")
BHL_RAG$SearchedName<-str_replace(BHL_RAG$SearchedName," X "," × ")
BHL_RAG$AcceptedName<-str_replace(BHL_RAG$AcceptedName," X "," × ")
BHL_RAG$AcceptedName<-str_replace(BHL_RAG$AcceptedName,"X ","× ")
BHL_RAG$SearchedName<-str_replace(BHL_RAG$SearchedName,"X ","× ")
BHL_RAG$NurseryName<-str_replace(BHL_RAG$NurseryName,"  "," & ")
BHL_RAG[BHL_RAG == ""] <- NA                     # Replace blank with NA

DB1<-BHL_RAG %>%
  dplyr::select(Source,ItemID,SearchedName,AcceptedName,USDAcode,Latitude,Longitude,City,State,PublisherPlace,PublicationDate,NurseryName,Title,ItemUrl)
DB1$Latitude<-as.character(DB1$Latitude)
DB1$Longitude<-as.character(DB1$Longitude)
DB1$PublicationDate<-as.character(DB1$PublicationDate)

DB2<-BHL_RAG %>%
  dplyr::select(USDAcode,AcceptedName, USDAstatus, invasive_status, Regulated, Habit)

DB2<- DB2 %>%
  dplyr::group_by(AcceptedName) %>%
  dplyr::mutate(n_records = n()) %>%
  distinct()
DB2$n_records<-as.character(DB2$n_records)
write.csv(DB1,'HPS_records.csv',row.names=FALSE,fileEncoding = "UTF-8")
write.csv(DB2,'HPS_taxa.csv',row.names=FALSE,fileEncoding = "UTF-8")
