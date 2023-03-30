library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)

# load the dataset
frog_data <- read.csv("PE2_frog_data.csv")

# set the color palette for the frog genera
color_palette <- rainbow(length(unique(frog_data$Genus)))

# round the longitude and latitude values to 3 decimal places
frog_data$Longitude <- round(frog_data$Longitude, 3)
frog_data$Latitude <- round(frog_data$Latitude, 3)



# create a range selection slider for number of observations
# and a checklist for frog genera
ui <- fluidPage(
  
  # Page title
  fluidRow(
    column(12,
           h1("FROGS OBSERVED IN OUTER EASTERN MELBOURNE 2000-2018"))),
  
  # Project description
  fluidRow(
    column(12,
           h4("Project Description")),
    column(12,
           p("This Project is made by Shixin Huang 31029248 for FIT5147 2023S2. "))
  ),
  
  # Main content
  fluidRow(
    # VIS1 and MAP
    column(6,
           h4("Count of Frog Genera and Observation Points")),
    column(6,
           h4("Map of Observation Locations")),
    fluidRow(
      column(6,
             plotOutput("vis1_plot")),
      column(6,
             leafletOutput("map")),
      column(
        width = 6,
        sliderInput(
          inputId = "obs_filter",
          label = "Number of observations required for symbol to be visible:",
          min = 1,
          max = max(frog_data %>%
                      group_by(Longitude, Latitude) %>%
                      summarize(n = n()) %>%
                      pull(n)),
          value = 1,
          step = 1
        )
      ),
      column(
        width = 6,
        checkboxGroupInput(
          inputId = "genus_filter",
          label = "Select which frog genera to display:",
          choices = unique(frog_data$Genus),
          selected = unique(frog_data$Genus)
        )
      )
      
    ),
    
    # DES2
    column(12,
           h4("Frog Frequency and Location Description")),
    column(12,
           p("{{DES2_text Create a visualisation using ggplot2 that shows the number of observations made of each frog genera and their different preferred terrain (VIS 1). The visualisation should display the totals for each of the frog genera.}}")),
    
    # DES3 and VIS2
    column(6,
           h4("{{DES3_title}}")),
    column(6,
           h4("Observation Hours for Top 4 Frog Genera")),
    
    fluidRow(
      column(6,
             p("{{DES3_text Create a visualisation using ggplot2 that shows the number of observations made of each frog genera and their different preferred terrain (VIS 1). The visualisation should display the totals for each of the frog genera.}}")),
      column(6,
             plotOutput("vis2_plot")),
      
    )
  )
)

# server logic
server <- function(input, output) {
  
  # VIS1 bar chart
  output$vis1_plot <- renderPlot({
    ggplot(frog_data, aes(x = Genus, fill = Habitat)) +
      geom_bar(position = "dodge") +
      labs(title = "Count of Frog Genera by Preferred Terrain",
           x = "Genus",
           y = "Count") +
      scale_fill_discrete(name = "Preferred Terrain") +
      geom_text(stat="count", aes(label=..count..), position=position_dodge(width=0.9), vjust=-0.5)
  })
  
  # MAP leaflet map
  output$map <- renderLeaflet({
    frog_data %>%
      filter(Genus %in% input$genus_filter) %>%
      group_by(Longitude, Latitude, Genus) %>%
      summarize(n = n()) %>%
      filter(n >= input$obs_filter) %>%
      select(Longitude, Latitude, Genus, n) %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lng = ~Longitude, lat = ~Latitude, 
                       radius = ~sqrt(n)*3, 
                       color = ~color_palette[match(Genus, unique(Genus))], 
                       stroke = TRUE, 
                       fillOpacity = 0.5, 
                       weight = 1, 
                       label = ~paste0("Genus name: ",Genus, "\nNumber of observations: ", n), 
                       labelOptions = labelOptions(noHide = FALSE))
  })
  
  # VIS2 bar chart
  # Prepare data for plot 
  frog_data_counts <- reactive({
    data <- frog_data
    data$hour <- format(as.POSIXct(data$Time_Start), format="%H")
    data %>%
      group_by(Genus, hour) %>%
      summarise(count = n(), .groups = "drop")
    
  })
  
  # Select top 4 genera based on count
  top_genera <- reactive({
    frog_data_counts() %>%
      group_by(Genus) %>%
      summarise(total = sum(count)) %>%
      top_n(4)
  })
  
  # Filter the frog_data_counts to include only the top 4 genera
  frog_data_counts_top <- reactive({
    frog_data_counts() %>%
      filter(Genus %in% top_genera()$Genus)
  })
  
  
  # Create plot
  output$vis2_plot <- renderPlot({
    ggplot(frog_data_counts_top(), aes(x = hour, y = count, fill = Genus)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Observation Hours for Top 4 Frog Genera",
           x = "Hour of Day",
           y = "Count",
           fill = "Genus") +
      scale_fill_brewer(palette="Set1") +
      theme_minimal()
  })
}

# shiny app and server
shinyApp(ui = ui, server = server)