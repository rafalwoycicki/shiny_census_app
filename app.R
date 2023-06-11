# Load packages
library(shiny)
library(maps)
library(mapproj)

# Source helper functions
source("helpers.R")

# Load data
countries <- readRDS("data/countries.rds")

# Define UI ---
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      selectInput("race", "Choose a variable to display", 
                  choices = list("Percent White", "Percent Black",
                                 "Percent Hispanic", "Percent Asian"), selected = "Percent White"),
      sliderInput("range", "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    mainPanel(
      plotOutput("map")
    )
  )
)

# Define server logic ---

server <- function(input, output) {
  output$map <- renderPlot({
    args <- switch(input$race,
                   "Percent White" = list(countries$white, "darkgreen", "% White"),
                   "Percent Black" = list(countries$black, "black", "% Black"),
                   "Percent Hispanic" = list(countries$hispanic, "darkorange", "% Hispanic"),
                   "Percent Asian" = list(countries$asian, "darkviolet", "% Asian"))
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
}


#server <- function(input, output) {
 # output$map <- renderPlot({
  #  data <- switch(input$race,
   #                "Percent White" = countries$white,
    #               "Percent Black" = countries$black,
     #              "Percent Hispanic" = countries$hispanic,
      #             "Percent Asian" = countries$asian)
    #title <- switch(input$race,
     #               "Percent White" = "White",
      #              "Percent Black" = "Black",
       #             "Percent Hispanic" = "Hispanic",
        #            "Percent Asian" = "Asian")
    #color <- switch(input$race,
     #               "Percent White" = "darkgreen",
      #              "Percent Black" = "black",
       #             "Percent Hispanic" = "darkorange",
        #            "Percent Asian" = "darkviolet")
    #
    #percent_map(var = data, color = color, legend.title = paste("%",title), min = input$range[1], max = input$range[2])
  #})
#}

# Run the application 
shinyApp(ui = ui, server = server)
