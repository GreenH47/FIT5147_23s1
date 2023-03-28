library(shiny)
library(ggplot2)

ui <- fluidPage(
  headerPanel("Miles per gallon box plots"),
  sidebarLayout(
    sidebarPanel(
      selectInput("myVariable", "Variable:", choices = names(mtcars)[-1]),
      checkboxInput("chkOutliers", "Show outliers", value = F)
    ),
    mainPanel(
      plotOutput("myPlot")
    )
  )
)

server <- function(input, output) {
  
  my_df <- reactive({
    data.frame(
      mpg = mtcars[, "mpg"], # mtcars$mpg
      my_var = as.factor(mtcars[, input$myVariable])
    )
  })
  
  output$myPlot <- renderPlot({
    ggplot(data=my_df(), aes(y=mpg, x=my_var)) +
      geom_boxplot(outlier.size = ifelse(input$chkOutliers, 5, 0))
  })
}

shinyApp(ui, server)