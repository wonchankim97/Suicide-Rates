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
          menuItem(text = 'Machine Learning', icon = icon('laptop-code'), tabName = 'kmeans'),
          menuItem(text = 'Data', icon = icon('database'), tabName = 'data')
          # menuItem()
        )
      ),
      dashboardBody(
        tags$head(
          tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        
        # optional element of allowing user to download data
        # fluidRow(
        #   column(12, downloadButton("downloadDataFromTable", "Download Table Data"))
        # ),
        # fluidRow(
        #   column(12, DT::dataTableOutput("campaign_table", width = "100%"))
        # )
        
        fluidRow()
      )
    )
  )
)









