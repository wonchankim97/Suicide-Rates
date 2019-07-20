library(shinydashboard)
library(tidyverse)
library(googleVis)
library(leaflet)
library(maps)
library(countrycode)
library(plotly)
library(ggthemes)



shinyServer(function(input, output){
  #### Map Tab #########################################################
  ## Filter
  df1 <- reactive({
    if(is.null(input$checkGroup)){
      df1 = df %>% 
        filter(between(year, input$slider[1], input$slider[2])) %>%
        group_by(country, age) %>%
        summarise(suicides100 = round(mean(input$type)),
                  suicides = round(mean(suicides)))
    }
    else{
      df1 = df %>%
        filter(age %in% input$checkGroup) %>%
        filter(between(year, input$slider[1], input$slider[2])) %>% 
        group_by(country, age) %>%
        summarise(suicides100 = sum(suicides.per.100k),
                  suicides = sum(suicides))
    }
  })
  
  
  ## Render Map
  # show map using googleVis
  output$map <-renderGvis({
    gvisGeoChart(data = df1(), locationvar = "country", colorvar = input$type,
                 options = list(region="world", displayMode="auto",
                                resolution="countries", width="100%", height="100%",
                                colorAxis="{colors:['#6f92e6', '#f9897e']}"))
  })

  output$maxBox <- renderInfoBox({
    max_value <- max(df1()$suicides100)
    max_state <- df1()$country[df1()$suicides100 == max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"), color = "light-blue")
  })
  output$avgBox <- renderInfoBox({
    avg_value <- round(mean(df1()$suicides100), 2)
    infoBox("Average Global Suicides (/100k)", avg_value, icon = icon("calculator"), color = "light-blue")
  })
  output$minBox <- renderInfoBox({
    min_state <-
      df1()$country[df1()$suicides100 == 0]
    min_state = paste(min_state, collapse = ", ")
    infoBox(min_state, title = "Countries w/ 0 Suicides (/100k): ",
            icon = icon("user-times"), color = "navy")
  })
  
  #### Graphs Tab ######################################################
  ## Graphs and Histograms
  # cont, sex, gdp, year
  df2 <- reactive({
    df2 = df %>% 
      filter(continent == input$cont) %>%
      filter(sex == input$sex) %>%
      filter(between(gdp.capita, input$gdp[1], input$gdp[2])) %>%
      filter(between(year, input$year[1], input$year[2])) %>% 
      arrange(desc(suicides))
  })
  
  output$line <- renderPlotly(
    # check by gdp.capita for each country in the eu of suicides per 100k by generation (density)
    ggplotly(df2() %>%
      group_by(country, year) %>%
      summarise(suicides100 = mean(suicides.per.100k)) %>% 
      ggplot(aes(year, suicides100)) +
      geom_line(aes(color = country), show.legend = FALSE,
                  alpha = 0.25) +
      labs(title = "Suicides (/100k) vs. Year", x = "Year", y = "Suicides (/100k)") +
      theme_gdocs()) %>% 
      layout(legend = list(x = 100, y = 0.5))
  )
  
  output$hist <- renderPlotly(
    ggplotly(df2() %>% 
      group_by(country, year) %>% 
      ggplot(aes(year, gdp.capita)) + 
      geom_col(aes(fill = country), position = "dodge") +
      theme_gdocs() +
      labs(title = "GDP per Capita vs. Year", x = "Year", y = "GDP per Capita"))
    # ggplot(df1()) + geom_smooth()
  )
  
  output$scat <- renderPlotly(
    ggplotly(df2() %>%
      group_by(country, year) %>% 
      ggplot() +
      geom_point(aes(x = population, y = suicides, size = population, color = country),
                 show.legend = FALSE, alpha = 0.25) +
      theme_gdocs() +
      labs(title = "Suicides vs. Population", x = "Population", y = "Suicides"))
  )
  
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












