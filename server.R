library(shinydashboard)
library(tidyverse)
library(googleVis)
library(leaflet)
library(maps)
library(countrycode)



shinyServer(function(input, output){
  #### Map Tab #########################################################
  ## Filter
  df1 <- reactive({
    if(is.null(input$checkGroup))
      df1 = df
    else{
      df1 = df %>%
      filter(age %in% input$checkGroup) %>%
      filter(year %in% input$slider) %>% 
      group_by(country, age) %>%
      summarise(suicides100 = round(mean(suicides.per.100k)),
                suicides = round(mean(suicides)))
    }
  })
  
  ## Render Map
  # show map using googleVis
  output$map <-renderGvis({
    gvisGeoChart(data = df1(), locationvar = "country", colorvar = "suicides",
                 options=list(region="world", displayMode="auto",
                              resolution="countries", width="100%", height="100%"))
  })

  output$maxBox <- renderInfoBox({
    max_value <- max(df1()$suicides100)
    max_state <-
      df1()$country[df1()$suicides100 == max_value]
      # df1()$country[df()[,input$suicides100] == max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  output$minBox <- renderInfoBox({
    min_value <- min(df1()$suicides100)
    min_state <-
      df1()$country[df1()$suicides100 == min_value]
    infoBox(min_state, min_value, icon = icon("hand-o-up"))
  })
  output$avgBox <- renderInfoBox({
    avg_value <- mean(df1()$suicides100)
    avg_state <-
      df1()$country[df1()$suicides100 == avg_value]
    infoBox(avg_state, avg_value, icon = icon("calculator"))
  })
  
  #### Graphs Tab ######################################################
  ## Graphs and Histograms
  output$hist <- renderGvis({
    gvisHistogram(suicide_rates[,input$selected, drop=FALSE])
  })
  
  output$lines <- renderPlot({
    gvisColumnChart(suicide_rates[,input$selected, drop=FALSE])
  })
  # 
  # output$hist <- renderPlot(
  #   flights_delay() %>%
  #     ggplot(aes(x = carrier, y = n)) +
  #     geom_col(fill = "lightblue") +
  #     ggtitle("Number of flights")
  # )
  
  # Bubble <- gvisBubbleChart(Fruits, idvar="Fruit", 
  #                           xvar="Sales", yvar="Expenses",
  #                           colorvar="Year", sizevar="Profit",
  #                           options=list(
  #                             hAxis='{minValue:75, maxValue:125}'))
  # plot(Bubble)

  #### ML Tab ##########################################################
  
  
  #### Table Tab #######################################################
  ## Render Data Table with Filtering Options
  output$table = DT::renderDataTable({
    suicide_rates
  })
  
})












