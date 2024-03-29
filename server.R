shinyServer(function(input, output){
  #### Map Tab #########################################################
  ## Filter
  df1 <- reactive({
    if(is.null(input$checkGroup)){
      df1 = df %>% 
        filter(between(year, input$slider[1], input$slider[2])) %>%
        group_by(country, age) %>%
        summarise(suicides100 = sum(suicides.per.100k),
                  suicides = sum(suicides))
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
      scale_y_continuous(labels = function(x) sprintf("%.2f", x)) +
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
      group_by(country) %>% 
      summarise(population = mean(population), suicides = sum(suicides)) %>% 
      ggplot() +
      geom_point(aes(x = population, y = suicides, size = population, color = country),
                 show.legend = FALSE, alpha = 0.5) +
      theme_gdocs() +
      labs(title = "Suicides vs. Population", x = "Population", y = "Suicides"))
  )

  #### ML Tab ##########################################################
  ## reactive function for the kmeans?
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    df3[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlotly({
    vcol = (c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    ggplotly(ggplot(selectedData(), aes(x = selectedData()[[1]], y = selectedData()[[2]],
                     col = vcol[clusters()$cluster])) +
      geom_point(alpha = 0.5, show.legend = FALSE) +
      theme_gdocs() +
      scale_fill_manual("Clusters") +
      labs(title = "K Means Clustering", x = as.character(input$xcol), y = as.character(input$ycol))) %>% 
      layout(showlegend = FALSE)
    
    # par(mar = c(5.1, 4.1, 0, 1))
    # plot(selectedData(),
    #      col = c(clusters()$cluster),
    #      pch = 20, cex = 1.5)
    # points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  output$plot2 <- renderPlotly(
    ggplotly(ggplot(selectedData(), aes(x = selectedData()[[1]], y = selectedData()[[2]],
                               col = df3$country)) +
      geom_point(alpha = 0.5) +
      theme_gdocs() +
      labs(title = "Original Data", x = as.character(input$xcol), y = as.character(input$ycol)))
  )
  
  output$scat <- renderPlotly(
    ggplotly(df2() %>%
               group_by(country) %>% 
               summarise(population = mean(population), suicides = sum(suicides)) %>% 
               ggplot() +
               geom_point(aes(x = population, y = suicides, size = population, color = country),
                          show.legend = FALSE, alpha = 0.5) +
               theme_gdocs() +
               labs(title = "Suicides vs. Population", x = "Population", y = "Suicides"))
  )
  
  #### Table Tab #######################################################
  ## Render Data Table with Filtering Options
  output$table = DT::renderDataTable({
    suicide_rates
  })
  
  #### Reddit Tab ######################################################
  ## Shiny doesn't render images well so will just attach with tag
  # output$reddit = renderImage(
  #   df %>%
  #     filter(country %in% c("United States", "Canada", "Australia", "Mexico", "South Korea")) %>% 
  #     group_by(year,country) %>% 
  #     summarise(suicides = sum(suicides), population = mean(population), gdp.capita = mean(gdp.capita)) %>% 
  #     ggplot(aes(suicides, population, color = country, size = gdp.capita, shape = country)) + 
  #     geom_point(alpha = 0.7) +
  #     scale_shape_manual(values=c(0,1,2,5,6)) +
  #     theme_gdocs() +
  #     labs(title = 'Year: {frame_time}', x = 'Suicides', y = 'Population') +
  #     transition_time(as.integer(year)) +
  #     view_follow(fixed_y = TRUE) +
  #     shadow_wake(wake_length = 0.05, alpha = FALSE)
  # )
  # 
  # df %>%
  #   filter(country == "United States", sex == "male") %>%
  #   group_by(year, country) %>%
  #   summarise(suicides = sum(suicides), population = mean(population), gdp.capita = mean(gdp.capita)) %>%
  #   ggplot(aes(suicides, population, color = country, size = gdp.capita, shape = country)) +
  #   geom_point(alpha = 0.7, show.legend = FALSE) +
  #   theme_gdocs() +
  #   scale_color_manual(values="#56B4E9") +
  #   labs(title = 'United States Males Year: {frame_time}', x = 'Suicides', y = 'Population') +
  #   transition_time(as.integer(year)) +
  #   shadow_wake(wake_length = 0.05, alpha = FALSE)
  # 
  # df %>%
  #   filter(country == "United States", sex == "female") %>%
  #   group_by(year, country) %>%
  #   summarise(suicides = sum(suicides), population = mean(population), gdp.capita = mean(gdp.capita)) %>%
  #   ggplot(aes(suicides, population, color = country, size = gdp.capita, shape = country)) +
  #   geom_point(alpha = 0.7, show.legend = FALSE) +
  #   theme_gdocs() +
  #   labs(title = 'United States Females Year: {frame_time}', x = 'Suicides', y = 'Population') +
  #   transition_time(as.integer(year)) +
  #   shadow_wake(wake_length = 0.05, alpha = FALSE)
})












