#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-05-26/cocktails.csv')
boston_cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-05-26/boston_cocktails.csv')

library(tidytuesdayR)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
tuesdata <- tidytuesdayR::tt_load('2020-05-26')
tuesdata <- tidytuesdayR::tt_load(2020, week = 22)


cocktails <- tuesdata$cocktails
x    <- cocktails
ingredient_cols <- grep("^ingredient$", names(cocktails), value = TRUE)
## pop ingredient dropdown
all_ingredients <- cocktails['ingredient'] %>%
  unlist(use.names= FALSE) %>%
  na.omit() %>%
  str_to_title() %>%
  sort () %>% 
  unique()


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Cocktail Ingredients"),

    sidebarLayout(
        sidebarPanel(
            selectInput("ingredient",
                        "Select Ingredients",
                        choices = all_ingredients,
                        selected = NULL,
                        multiple = TRUE
                       )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("barPlot")
        )
    )
)


server <- function(input, output, session) {

  
    output$barPlot <- renderPlot({
      filter(cocktails, ingredient %in% input$ingredient) %>%
        ggplot2::ggplot(aes(x= drink, fill= alcoholic))+ 
      geom_bar(position= "stack")
        })
        

    }

# Run the application 
shinyApp(ui = ui, server = server)

