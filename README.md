# Global Suicide Rates

This repository contains the files that make up a web application that visualizes global suicide rates from the years of 1985 to 2016. The dataset was supplied by [Kaggle](https://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016). There are various toggles that help you visualize the data. Feel free to clone this to your own machine and mess around with different features.

Take a look at the blog for more details: [Suicide Rates Across the Globe](https://nycdatascience.com/blog/student-works/suicide-rates-exploratory-data-analysis/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Installing

In order to run the app, make sure to have the following packages:
* tidyverse
* googleVis
* ggthemes
* gganimate
* shiny
* shinydashboard

Use the following line of code in R to download whichever ones you do not have:
```
install.packages('')
```

Then, clone this repository into your local machine and try manipulating our tools yourself! The dataset is included in this repo.

```
git clone https://github.com/wonchankim97/Suicide-Rates
```

## Run the app!

https://wonchan.shinyapps.io/suicide_data/

## Future Improvements
To improve upon this project, there are several points I want to address:
* In each tab, I would like to put an extra page tab to describe what exactly the use of my graphs, maps, and more are. It would explain to the user how to toggle with the inputs in order to maximize their understanding of the web app to draw more significant conclusions
* I would like to do the k means clustering once over but by segmenting the dataset into different groups or by standardizing the values

