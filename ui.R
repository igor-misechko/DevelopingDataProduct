

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(WDI)

shinyUI(navbarPage(theme = "bootstrap.css",
    "World Bank Open Data",
    tabPanel(
        "Plot",
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(
            sidebarPanel(
                helpText('Please select parameter below.'),
                helpText('Information about dataset and instruction for using application you can look on tab About.'),
                br(),
                h4('Input Years for analysis'),
                fluidRow(column(
                    5,
                    numericInput(
                        'id1',
                        'From',
                        2000,
                        min = 1960,
                        max = 2014,
                        width = "100px"
                    )
                ),
                column(
                    5,
                    numericInput(
                        'id2',
                        'To',
                        2014,
                        min = 1960,
                        max = 2014,
                        width = "100px"
                    )
                )),
                helpText("Inputting any Years between 1960 and 2014."),
                br(),
                selectizeInput(
                    "country",
                    "Select Country for analysis:",
                    choices = NULL,
                    selected = NULL,
                    multiple = TRUE,
                    options = list(placeholder = 'Choose up to 5 Country', maxItems = 5),
                    size = 5
                ),
                br(),
                selectInput(
                    "indicator",
                    "Select Indicator for analysis:",
                    choices = NULL,
                    selected = NULL,
                    multiple = FALSE
                ),
                helpText("Please, notice that not all indicators are available."),
                br(),
                actionButton("goButton", "Go!"),
                helpText(
                    "Click the button to visualize or update the diagram that displays in the main panel."
                )
                ),
            
            # Show a plot of the generated distribution
            mainPanel(h3("Visualize selected data"),
                      plotOutput("distPlot"),
                      hr())
            )
        ),
    tabPanel(
        "Table",
        h3("Output raw Dataset in table"),
        h4(textOutput("text1")),
        DT::dataTableOutput('rawdata'),
        br(),
        downloadButton('downloadData', 'Download'),
        hr()
    ),
    tabPanel("About",
             tags$body(
                 h3('World Development Indicators'),
                 p(
                     "World Bank provide open data about development in countries around the globe."
                 ),
                 p(
                     "This data include information about 215 country and 49 regions,
                     and 148 indicators that measured by year from 1960 year."
                 ),
                 a(href = "http://data.worldbank.org/",
                   "Source link")
                 ),
             hr(),
             tags$body(
                 h3('Instructions'),
                 p('In this application used only data about 215 country, and 49 regions excluded.'),
                 p('This application provide simple interface to select up to 5 country and 1 indicator
                    that you want to analysis. Also you can change years to observed data.'),
                 p('When you select all parameters please press button <Go!>. After that data 
                   downloaded from World Bank database and build diagram and render table.'),
                 p('All downloaded data you can save to your PC on tab <Table>.')
                 )
             )
    ))
