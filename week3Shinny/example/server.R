library(shiny)
library(datasets)
library(ggplot2)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    paste("mpg ~", input$variable)
  })
  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  output$mpgPlot <- renderPlot({
    
    # Check for the input variable
    if (input$variable == "am") {
      # am
      mpgData <- data.frame(mpg = mtcars$mpg, 
                            var = factor(mtcars[[input$variable]], 
                                         labels = c("Automatic", "Manual")))
    } else {
      # cyl and gear
      mpgData <- data.frame(mpg = mtcars$mpg, 
                            var = factor(mtcars[[input$variable]]))
    }
    
    p <- ggplot(mpgData, aes(var, mpg)) + 
      geom_boxplot(outlier.size = ifelse(input$outliers, 2, NA)) + 
      xlab(input$variable)
    
    print(p)
  })
  
})
