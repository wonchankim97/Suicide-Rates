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
    if(is.null(input$checkGroup)){
      df1 = df %>% 
        filter(year %in% input$slider) %>%
        group_by(country, age) %>%
        summarise(suicides100 = round(mean(suicides.per.100k)),
                  suicides = round(mean(suicides)))
    }
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
    gvisGeoChart(data = df1(), locationvar = "country", colorvar = "suicides100",
                 options = list(region="world", displayMode="auto",
                                resolution="countries", width="100%", height="100%"))
  })

  output$maxBox <- renderInfoBox({
    max_value <- max(df1()$suicides100)
    max_state <-
      df1()$country[df1()$suicides100 == max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"), color = "light-blue")
  })
  output$avgBox <- renderInfoBox({
    avg_value <- round(mean(df1()$suicides100), 2)
    infoBox("Average Global Suicides: ", avg_value, icon = icon("calculator"), color = "light-blue")
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
  output$bar <- renderPlot({
    gvisColumnChart(suicide_rates, xvar = suicides100, yvar = gdp.capita)
  })
  # ## Example
  # 
  # # Column <- gvisColumnChart(df)
  # # plot(Column)
  # # 
  # # df=data.frame(country=c("US", "GB", "BR"),
  # #               val1=c(10,13,14),
  # #               val2=c(23,12,32))
  output$line <- renderPlot({
    gvisLineChart(df1(), xvar="country", yvar=c("suicides100","suicides"),
                  options=list(
                    title="Suicides",
                    titleTextStyle="{color:'black', 
                                           fontName:'Courier', 
                                           fontSize:16}",                          
                    vAxis="{gridlines:{color:'red', count:3}}",
                    hAxis="{title:'Country', titleTextStyle:{color:'grey'}}",
                    series="[{color:'blue', targetAxisIndex: 0}, 
                             {color: 'light-blue',targetAxisIndex:1}]",
                    vAxes="[{title:'Suicides (/100k)'}, {title:'Suicides'}]",
                    legend="bottom",
                    curveType="function",
                    width=500,
                    height=300)
    )
  })
  
  output$hist <- renderPlot({
    gvisHistogram(df1())
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












