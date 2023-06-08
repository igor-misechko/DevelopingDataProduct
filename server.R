
library(shiny)
library(WDI)
library(ggplot2)
library(plotly)
library(dplyr)

# tt <- WDIcache()
tt <- readRDS(file = "tt.rds")
tt2 <- as.data.frame(tt$country, stringsAsFactors = FALSE)
tt2 <- dplyr::filter(tt2, region != "Aggregates")
tt2 <- cbind(tt2, value = seq_len(nrow(tt2)))
ind <- as.data.frame(WDIsearch())
ind2 <- as.data.frame(WDIsearch(short = F), stringsAsFactors = FALSE)

iso <- function(n) tt2$iso2c[tt2$country %in% n]
indicatorFUN <- function(n) ind2$indicator[ind2$name %in% n]

shinyServer(function(input, output, session) {
    updateSelectizeInput(session, "country", label = "Select Country to view:", choices = tt2$country,
                         selected = NULL, server = T)
    
    
    updateSelectizeInput(session, "indicator", label = "Select Indicator to view:", choices = (ind2$name),
                         selected = "GDP (current US$)", options = list(), server = T)
    
    datasetInput <- eventReactive(input$goButton, {
        WDI(indicator = c("Value" = indicatorFUN(as.character(input$indicator))),
             country = iso(as.character(input$country)),
             start = input$id1,
             end = input$id2)
    })
    
    datasetInput2 <- reactive({
        datasetInput() %>% rename("Country" = "country", 'Year' = 'year')
    })
    
    datasetInput3 <- reactive({
        select(datasetInput2(), Country, Value, Year)
    })

    
  # output$distPlot <- renderPlot({
  #   ggplot(datasetInput2(), aes(x = Year, y = Value, color=Country)) + geom_line() +
  #         labs(title = input$indicator) + scale_x_continuous('Year', breaks = seq(input$id1,input$id2)) 
  #         
  # })
    output$distPlot <- renderPlotly({
        p <- ggplot(datasetInput2(), aes(x = Year, y = Value, color=Country)) + geom_line() +
            labs(title = input$indicator) + 
            scale_x_continuous('Year', breaks = seq(input$id1, input$id2)) 
        return(ggplotly(p) %>% rangeslider(input$id1, input$id2)) #)
    })
  
  
  # show raw data
  output$text1 <- renderText({if (input$indicator == '') '' else
      paste(input$indicator)})
  output$rawdata <- DT::renderDataTable(DT::datatable(
      datasetInput3(),
      options = list(pageLength = 10), rownames = FALSE
  ))
  
  output$downloadData <- downloadHandler(
      filename = function() { 
          paste(input$indicator, '.csv', sep='') 
      },
      content = function(file) {
          write.csv(datasetInput3(), file)
      },
      contentType = "text/csv"
  )
})
