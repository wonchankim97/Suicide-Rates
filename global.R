library(shiny)
library(shinydashboard)
library(tidyverse)
library(googleVis)
library(maps)
library(countrycode)
library(plotly)
library(ggthemes)
library(gganimate)

suicide_rates <- read_csv(file = "./suicide_rates.csv")
df  =
  suicide_rates %>%
  select(-`country-year`) %>% 
  rename(suicides.per.100k = `suicides/100k pop`,
         hdi = `HDI for year`,
         gdp.capita = `gdp_per_capita ($)`,
         gdp.year = `gdp_for_year ($)`,
         suicides = suicides_no)
  
df = df %>% 
  mutate(continent = countrycode(sourcevar = df$country,
                            origin = "country.name",
                            destination = "continent"),
         country = ifelse(country == "Republic of Korea", "South Korea", country))

df3 = df %>%
  filter(country %in% c("United States", "Canada", "Australia", "Mexico", "South Korea")) %>% 
  select(-hdi, -age, -continent, -gdp.year, -sex) %>% 
  select(-generation, -year)

## explore the years (wars, etc.)

