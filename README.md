# Suicide-Rates
Suicide is a topic that has been avoided until more recently. This is due to the fact that it is a naturally sensitive topic and there is a stigma that is associated to it. There are movements that have led the way for more mental health awareness from the government level to a college level and so much more. Through this Shiny app, I wanted to delve into the data of suicides itself, in order to produce visual representations that could highlight some notable issues that the general conversation around this topic may not be discussing.

## Shiny App
For this project, I segmented the project into three different R files. One was the global file, which imported all of my libraries necessary for this project, loaded in the raw dataset and cleaned it accordingly.

The second file was my UI file which incorporated all of the features of my web app. In this file, I had to incorporate the shiny dashboard which made a layout for all the tabs my web app would use. There were 5 different tabs that I segmented my app into and each one contained specific areas of interest I wanted to focus on. In this UI file, I also had to incorporate slider inputs as well as radio buttons and more so that the user could control the features of the app in order to hone in on specific details of the dataset.

In the server file of this app, I had to make sure that everything in my UI side was rendered properly in order to display the graphs, maps, images, links, and more so that there would not be anything that fell apart due to the user changing certain inputs.

## Future Improvements
To improve upon this project, there are several points I want to address.

*In each tab, I would like to put an extra page tab to describe what exactly the use of my graphs, maps, etc. are and how the user should toggle with the inputs in order to maximize their understanding of the web app in order to draw more significant conclusions.
*I would like to do the k means clustering once over but by segmenting the dataset into different groups or by standardizing some of the values.

