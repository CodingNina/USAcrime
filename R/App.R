#install.packages(c("maps", "mapproj"))

library(maps)
library(mapproj)


USArrests <- read.csv(file = '~/CrimeRateUS/data/USArrests.csv')

source("~/CrimeRateUS/helpers.R")

# User interface ----
ui <- fluidPage(
  titlePanel("USA: Major Crimes that occurred in each US State"),

  sidebarLayout( position = "right",
    sidebarPanel(
      helpText("Create criminal maps, based on the type of crime and numbers of it"),


      selectInput("var",
                  label = "Type of crime",
                  choices = c("Percent Murder", "Percent Assault",
                              "Percent UrbanPop", "Percent Rape"),
                  selected = "Percent Murder"),

      sliderInput("range",
                  label = "Range of %cases:",
                  min = 0, max = 80, value = c(0, 80))
    ),

    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent Murder" = USArrests$Murder,
                   "Percent Assault" = USArrests$Assault,
                   "Percent UrbanPop" = USArrests$UrbanPop,
                   "Percent Rape" = USArrests$Rape)

    color <- switch(input$var,
                    "Percent Murder" = "darkgreen",
                    "Percent Assault" = "black",
                    "Percent UrbanPop" = "darkorange",
                    "Percent Rape" = "darkviolet")

    legend <- switch(input$var,
                     "Percent Murder" = " % Murder",
                     "Percent Assault" = "% Assault",
                     "Percent UrbanPop" = " % UrbanPop",
                     "Percent Rape" = " % Rape")

    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)
