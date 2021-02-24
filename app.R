library(shiny)
library(plotly)
library(tidyverse)
library(shinythemes)
library(leaflet)

# increase max R-Shiny user-input file size from 5 to 30 MB
options(shiny.maxRequestSize = 30 * 1024 ^ 2)

# the ui object has all the information for the user-interface
ui <- fluidPage(
  h1("Viral Space Time"),
  theme = shinytheme("sandstone"),
  leafletOutput("mymap")
)

# define fonts for plot
f1 <- list(family = "Arial, sans-serif",
           size = 24,
           color = "black")

f2 <- list(family = "Arial, sans-serif",
           size = 20,
           color = "black")

f3 <- list(family = "Arial, sans-serif",
           size = 16,
           color = "black")

# set plot margins
m <- list(
  l = 20,
  r = 20,
  b = 10,
  t = 100,
  pad = 4
)


server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet() %>%
      leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
  })
}


shinyApp(ui, server)
