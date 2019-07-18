library(shinydashboard)
library(tidyverse)
library(googleVis)
library(leaflet)
library(maps)
library(countrycode)



shinyServer(function(input, output){
  #### Selector Values Update #####################################################
  
  # for the check box
  output$value <- renderPrint({ input$checkGroup })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #### Render Map #################################################################
  # show map using googleVis
  output$map <- renderGvis({
    gvisGeoChart(data = aggdf, locationvar = "country", colorvar = "suicides",
                 options=list(region="world", displayMode="auto",
                              resolution="countries",
                              width=800, height=400))
  })
  
  
  
  
  #### Render Data Table with Filtering Options ###################################
  
  output$table = DT::renderDataTable({
    suicide_rates
  })
  
  
  
  
  
})












