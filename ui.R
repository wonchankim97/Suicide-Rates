library(shiny)
library(shinydashboard)

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
          menuItem(text = 'Data', icon = icon('database'), tabName = 'data'),
          menuItem(text = '   r/oddlysatisfying', icon = icon('reddit'), tabName = 'gif')
        )
      ),
      dashboardBody(
        tags$head(
          tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        
        tabItems(
          tabItem(tabName = "maps",
                  fluidRow(infoBoxOutput("maxBox"),
                           infoBoxOutput("avgBox"),
                           infoBox("Average US Suicides", subtitle = "in 2018 (/100k)", 13.9,
                                   icon = icon("globe-americas"), fill = TRUE,
                                   href = "https://www.americashealthrankings.org/explore/annual/measure/Suicide/state/ALL", color = "light-blue")),
                  fluidRow(
                    column(9, box(htmlOutput("map"), height = "auto", width = "auto")),
                    column(3,
                      radioButtons("type", label = h3("Display map by: "),
                                   choices = list("Suicides" = "suicides",
                                                  "Suicides (/100k)" = "suicides100"),
                                   selected = "suicides"),
                      checkboxGroupInput("checkGroup", label = h3("Filter by age group: "),
                                   choices = list("5-14 years", "15-24 years",
                                                  "25-34 years", "35-54 years",
                                                  "55-74 years", "75+ years"),
                                   selected = c("5-14 years", "15-24 years", "25-34 years",
                                                "35-54 years", "55-74 years","75+ years")),
                      sliderInput("slider", label = h3("Year Range"), min = 1985, 
                                  max = 2016, value = c(1985, 2016), sep = "")
                      
                    )
                  ),
                  fluidRow(
                    infoBoxOutput("minBox", width = 12)
                  )
          ),
          tabItem(tabName = "graphs",
                  fluidRow(
                    column(2, h3("Filter graphs by:"), align = "center"),
                    column(2,
                      selectInput("cont", label = h3("Continent"), 
                                  choices = list("Americas", "Africa",
                                                 "Asia", "Europe", "Oceania"))),
                    column(2,
                      radioButtons("sex", label = h3("Sex"), 
                                  choices = list("Female" = "female", "Male" = "male"))),
                    column(3,
                      sliderInput("gdp", label = h3("GDP Range"), min = 251, 
                                    max = 126352, value = c(251, 126352))),
                    column(3,
                      sliderInput("year", label = h3("Year Range"), min = 1985, 
                                    max = 2016, value = c(1985, 2016), sep = ""))
                    
                  ),
                  fluidRow(
                    box(plotlyOutput("line"), height = 420),
                    box(plotlyOutput("hist"), height = 420)
                  ),
                  fluidRow(
                    box(plotlyOutput("scat"), height = 420, width = 12)
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
          ),
          tabItem(tabName = "gif",
                  fluidRow(
                    column(1),
                    column(7, tags$img(src = "reddit.gif", height = 900, width = 800)),
                    column(3, h3("Thank you for taking the time to look through this project :')",
                                 align = "center"))
                  )
          )
        )
        
      )
    )
  )
)









