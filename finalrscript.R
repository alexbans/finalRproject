library(dplyr)
library(readxl)
library(ggplot2)
library(maps)
library(mapproj)
library(leaflet)
library(mapview)
library(sf)
library(tidyr)
#These are all the packages I will use in this project
ggplot() + borders("state", region= "Oregon") + coord_map() + geom_point(aes(x=-122.59611111, y=45.59555556)) + ggtitle("The Location of the Ecoroof in Oregon") + theme(plot.title = element_text(hjust = 0.5))+ labs(y= "Latitude", x= "Longitude")
#this is map of site on the state level
m <- leaflet() %>% addTiles() %>% addMarkers(lng=-122.59611111, lat=45.59555556, popup="Walmart Ecoroof")
m  # Print the map
we2flow<-read.csv("data/flow/we2 flow.csv")
we3flow<-read.csv("data/flow/we3 flow.csv")
icp<-read_excel("data/icpdata.xlsx")
#Imports datasets
we2flow$Time <- as.POSIXlt(we2flow$Inst.Time, format="%m/%d/%Y %H:%M %p")
we3flow$Time<-as.POSIXct(we3flow$Inst.Time, format="%m/%d/%Y %H:%M %p")
#this takes the "instrument time" and turns it into data time which I can seperate into data and time
icp$Pb.ppb<-as.numeric(icp$Pb.ppb)
#this turns my concentration values into numbers
we2.Fe.ppb<-icp%>%select("roof","DateTime","Fe.ppb")%>%filter(roof == "WE2")
we3.Fe.ppb<-icp%>%select("roof","DateTime","Fe.ppb")%>%filter(roof == "WE3")
we2.Pb.ppb<-icp%>%select("roof","DateTime","Pb.ppb")%>%filter(roof == "WE2")
we3.Pb.ppb<-icp%>%select("roof","DateTime","Pb.ppb")%>%filter(roof == "WE3")
#This filters my icp results between roofs and chemicals
plot(type= "o",we3flow$Time, we3flow$Flow..gpm., main = "Conventional Roof Runoff Over Time",xlab = "Time", ylab = "Flow (gpm)")
plot(type= "o",we2flow$Time,we2flow$Flow.2..gpm., main = "Ecoroof Runoff Over Time", xlab="Time", ylab= "Flow (gpm)")
plot(we2.Fe.ppb$DateTime, we2.Fe.ppb$Fe.ppb,main = "The Change in Fe Concentration over Time On An Ecoroof", xlab="Time", ylab= "Concentration (ppb)")
plot(we3.Fe.ppb$DateTime, we3.Fe.ppb$Fe.ppb,main = "The Change in Fe Concentration over Time On An Conventional Roof", xlab="Time", ylab= "Concentration (ppb)")
plot(we2.Pb.ppb$DateTime,we2.Pb.ppb$Pb.ppb, main = "The Change in Pb Concentration over Time On An Ecoroof", xlab="Time", ylab= "Concentration (ppb)")
plot(we3.Pb.ppb$DateTime,we3.Pb.ppb$Pb.ppb,main = "The Change in Pb Concentration over Time On An Conventional Roof", xlab="Time", ylab= "Concentration (ppb)")
#These are plots of discharge, Fe and Pb concentrations for both roofs over time
summary(we3flow$Flow..gpm.)
summary(we2flow$Flow.2..gpm.)
summary(we3.Fe.ppb$Fe.ppb)
summary(we2.Fe.ppb$Fe.ppb)
summary(we3.Pb.ppb$Pb.ppb)
summary(we2.Pb.ppb$Pb.ppb,na.rm = "TRUE")
#These are summmary stats of my things I'm looking at. How do I turn this into a table? 
boxplot(we2.Fe.ppb$Fe.ppb,we3.Fe.ppb$Fe.ppb, names=c("Ecoroof", "Conventional Roof"), xlab="Roof Type", ylab= "Concentration (ppb)", main="The Range of Concentrations of Fe between Roof Types")
boxplot(we2.Pb.ppb$Pb.ppb, we3.Pb.ppb$Pb.ppb, names=c("Ecoroof", "Conventional Roof"), xlab="Roof Type", ylab= "Concentration (ppb)", main="The Range of Concentrations of Pb between Roof Types" )
boxplot(we2flow$Flow.2..gpm., we3flow$Flow..gpm., names=c("Ecoroof", "Conventional Roof"), xlab="Roof Type", ylab="Discharge (gpm)", main= "The Range of Discharge Between Roof Types")
#These are boxplots comparing the ranges of flow, Fe and Pb concentrations between the two roofs
mean(we3flow$Flow..gpm.)
mean(we2flow$Flow.2..gpm.)
range(we3flow$Flow..gpm.)
