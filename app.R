library(shiny)
library(plotly)
library(tidyverse)
library(shinythemes)
library(leaflet)
library(leaflet.extras)

# increase max R-Shiny user-input file size from 5 to 30 MB
options(shiny.maxRequestSize = 30 * 1024 ^ 2)

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

# the ui object has all the information for the user-interface
ui <- fluidPage(
  h1("Viral Space Time"),
  theme = shinytheme("sandstone"),
  leafletOutput("mymap")
)


server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng=174.768, lat=-36.852, zoom=17 ) %>%
      # Add two tiles
      addProviderTiles("Esri.WorldImagery", group="Satellite Map") %>%
      addTiles(options = providerTileOptions(noWrap = TRUE), group="Street Map") %>%
      addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R") %>%
      #addCircleMarkers(lng=174.767, lat=-36.852, radius=19 , color="black",  fillColor="red", stroke = FALSE, fillOpacity = 0.8, group="Red") %>%
      #addCircleMarkers(lng=174.769, lat=-36.852, radius=18 , color="black",  fillColor="blue", stroke = FALSE, fillOpacity = 0.8, group="Blue") %>%
      #addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("Satellite Map","Street Map"), options = layersControlOptions(collapsed = FALSE)) %>%
      addLayersControl(baseGroups = c("Satellite Map","Street Map"), options = layersControlOptions(collapsed = FALSE)) %>%
      addHeatmap(
        lng=174.767, lat=-36.852,intensity = 2,
        blur = 20, max = 0.05, radius = 15
      ) %>%
      addHeatmap(
        lng=174.769, lat=-36.852,intensity = 3,
        blur = 10, max = 0.05, radius = 15
      )
  })
}


shinyApp(ui, server)
