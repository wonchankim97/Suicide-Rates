library(shinydashboard)
library(tidyverse)
library(googleVis)
library(leaflet)
library(maps)
library(countrycode)



shinyServer(function(input, output){
  #### Selector Values Update #####################################################
  
  # for the check box
  # output$value <- reactive({renderPrint({ input$checkGroup }) })
  # output$value <- renderPrint({ input$radio })
  # observe({
  #   case_when(input$checkGroup == )
  # })
  
  # reactive if you are using something two times for a dependent thing
  # colm <- reactive({
  #   as.numeric(input$var)
  # })
  
  df1 <- reactive({
    if(is.null(input$checkGroup))
      df
    df[df$age %in% input$checkGroup, ]
  })
  
  
  
  
  #### Map Tab #########################################################
  ## Filter
  df1 <- reactive({
    if(is.null(input$checkGroup))
      df1 = df
    df %>%
    filter(origin %in% input$checkGroup) %>%
    group_by(carrier) %>%
    summarise(n = n(),
                departure = mean(dep_delay),
                arrival = mean(arr_delay))
  })
  
  ## Render Map
  # show map using googleVis
  output$map <-renderGvis({
    if(is.null(input$checkGroup))
      df1 = df
    df1 = df[df$age %in% input$checkGroup, ]
    gvisGeoChart(data = df1, locationvar = "country", colorvar = "suicides",
                 options=list(region="world", displayMode="auto",
                              resolution="countries", width=900, height=500))
    output$map <- renderGvis({
      gvisGeoChart(state_stat, "state.name", input$selected,
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                width="auto", height="auto"))
    })
  })

  output$maxBox <- renderInfoBox({
    max_value <- max(state_stat[,input$selected])
    max_state <- 
      state_stat$state.name[state_stat[,input$selected] == max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  output$minBox <- renderInfoBox({
    min_value <- min(state_stat[,input$selected])
    min_state <- 
      state_stat$state.name[state_stat[,input$selected] == min_value]
    infoBox(min_state, min_value, icon = icon("hand-o-down"))
  })
  output$avgBox <- renderInfoBox(
    infoBox(paste("AVG.", input$selected),
            mean(state_stat[,input$selected]), 
            icon = icon("calculator"), fill = TRUE))
  
  
  #### Graphs Tab ######################################################
  ## Graphs and Histograms
  output$hist <- renderGvis({
    gvisHistogram(suicide_rates[,input$selected, drop=FALSE])
  })

  #### ML Tab ##########################################################
  
  
  #### Table Tab #######################################################
  ## Render Data Table with Filtering Options
  output$table = DT::renderDataTable({
    suicide_rates
  })
  # output$table <- DT::renderDataTable({
  #   datatable(suicide_rates, rownames=FALSE) %>% 
  #     formatStyle(input$selected, background="skyblue", fontWeight='bold')
  # })
  
  
  
  
  
})












