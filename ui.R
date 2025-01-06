#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
fluidPage(
    # Application title
    titlePanel(windowTitle =  "Shiny App", 
               title = 'Course project: Shiny App'),
    # Sidebar with input options
    sidebarLayout(
            sidebarPanel(
                    tabsetPanel(
                            id = 'active_panel',
                            tabPanel('General options', value = 1, 
                                     br(), 
                                     checkboxGroupInput(inputId = 'math_function_selection', 
                                       label = 'Please, choose functions:', 
                                       choices = c( 
                                               "y = sin(x)" = 'sin', 
                                               "y = 1/(20*x)" = 'hyp', 
                                               "y = exp(x)/400" = 'exp'
                                       ), 
                                       selected = c('sin', 'hyp', 'exp')),
                                     sliderInput( 
                                             "x_range", "Specify x-range:",
                                             min = 0, max = round(4*pi, 1),
                                             value = c(0, 2*pi) ),
                                     #submitButton('Submit')
                                     ),
                            tabPanel('Other options', value = 2, 
                                     br(), 
                                     radioButtons( 
                                             inputId = "radio", 
                                             label = "Plese choose color scheme", 
                                             choices = list( 
                                                     "Monochrome" = 'mh', 
                                                     "Multicolor" = 'mc'
                                             ), 
                                             selected = 'mc'
                                     ),
                                     #submitButton('Submit')
                            ),
                            tabPanel('Help', value = 3,
                                     br(),
                                     htmlOutput("user_manual_text")
                            )
                    )
            ),
        # Output of the app 
        mainPanel(
                #textOutput("value"), 
                htmlOutput("user_manual_text"),
                plotlyOutput(outputId = "plot"),
                tableOutput("table")
        )
    )
)