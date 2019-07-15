library(shiny)
library(shinydashboard)
library(tidyverse)

shinyUI(
  dashboardPage(
    # change font
    # tags$head(
    #   tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    # ),
    
    
    dashboardHeader(
      title = "Suicide Rates",
      titleWidth = 230,
      tags$li('By Wonchan Kim',
              style = 'text-align: right; padding-right: 5px; padding-top:17px; font-family: Arial, Helvetica, sans-serif;
                            font-weight: bold;  font-size: 13px;',
              class='dropdown'),
      tags$li(a(href = 'https://github.com/wonchankim97',
                img(src = 'GitHub_Logo.png',title = "github link", height = "18px")),
              class = "dropdown")
      ),
    dashboardSidebar(
      sidebarUserPanel(
        "Wonchan Kim",
        image = "Me.png"
      ),
      sidebarMenu(
        menuItem(text = 'Maps', icon = icon('globe'), tabName = 'maps'),
        menuItem(text = 'Graphs', icon = icon('chart-bar'), tabName = 'graphs'),
        menuItem(text = 'Machine Learning', icon = icon('laptop-code'), tabName = 'kmeans'),
        menuItem(text = 'Data', icon = icon('database'), tabName = 'data')
      )
    ),
    dashboardBody()
  )
)









