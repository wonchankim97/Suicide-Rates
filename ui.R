library(shiny)
library(shinydashboard)
library(tidyverse)

shinyUI(
  fluidPage(
    dashboardPage(
      dashboardHeader(
        title = "Suicide Rates",
        titleWidth = 230,
        tags$li('Wonchan Kim',
                style = 'text-align: right; padding-right: 13px; padding-top:17px; font-family: Arial, Helvetica, sans-serif;
                              font-weight: bold;  font-size: 13px;',
                class='dropdown'),
        tags$li(a(href = 'https://www.linkedin.com/in/wonchankim/',
                  img(src = 'linkedin.png',title = "Wonchan's LinkedIn", height = "19px")),
                class = "dropdown"),
        tags$li(a(href = 'https://github.com/wonchankim97/Suicide-Rates',
                  img(src = 'github.png',title = "Github Repository", height = "19px")),
                class = "dropdown")
        ),
      dashboardSidebar(
        sidebarUserPanel(
          "Wonchan Kim",
          image = "Me.png",
          subtitle = 'NYC Data Science Fellow'
        ),
        sidebarMenu(
          menuItem(text = 'Maps', icon = icon('globe'), tabName = 'maps'),
          menuItem(text = 'Graphs', icon = icon('chart-bar'), tabName = 'graphs'),
          menuItem(text = 'Machine Learning', icon = icon('laptop-code'), tabName = 'ml'),
          menuItem(text = 'Data', icon = icon('database'), tabName = 'data')
        )
      ),
      dashboardBody(
        tags$head(
          tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        
        tabItems(
          tabItem(tabName = "maps",
                  fluidRow(infoBoxOutput("maxBox"),
                           infoBoxOutput("minBox"),
                           infoBoxOutput("avgBox")),
                  fluidRow(
                    column(9, box(htmlOutput("map"), height = 500, width=1000)),
                    column(3,
                      checkboxGroupInput("checkGroup", label = h3("Filter by age group: "),
                                   choices = list("5-14" = "5-14", "15-24" = "15-24",
                                                  "25-34" = "25-34", "35-54" = "35-54",
                                                  "55-74" = "55-74", "75+" = "75+"),
                                   selected = c("5-14", "15-24", "25-34" = "25-34",
                                                "35-54", "55-74","75+"))
                    )
                  ),
                  fluidRow(
                    column(9,
                           sliderInput("slider", label = h3("Year Range"), min = 1985, 
                                       max = 2016, value = c(1985, 2016))
                    ),
                    column(3)
                  )
          ),
          tabItem(tabName = "graphs",
                  fluidRow(
                    box(htmlOutput("lines"), height = 300),
                    box(htmlOutput("hist"), height = 300)
                  )
          ),
          tabItem(tabName = "ml",
                  fluidRow(
                    column(6),
                    column(6)
                  )
          ),
          tabItem(tabName = "data",
                  fluidRow(box(DT::dataTableOutput("table"), width = 12))
          )
        )
        
        # optional element of allowing user to download data
        # fluidRow(
        #   column(12, downloadButton("downloadDataFromTable", "Download Table Data"))
        # ),
        # fluidRow(
        #   column(12, DT::dataTableOutput("campaign_table", width = "100%"))
        # )
        
      )
    )
  )
)









