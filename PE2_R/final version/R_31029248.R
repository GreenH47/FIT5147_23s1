library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)

# load the dataset
frog_data <- read.csv("PE2_frog_data.csv")

# set the color palette for the frog genera
color_palette <- c("#FF0000", "#4197cc", "#07ff00","#858382","#CC00FF")
#color_palette <- rainbow(length(unique(frog_data$Genus)))



ui <- fluidPage(
  
  # Page title
  fluidRow(
    column(12,
           h1("FROGS OBSERVED IN OUTER EASTERN MELBOURNE 2000-2018"))),
  
  # Project description
  fluidRow(
    column(12,
           h4(tags$u("Project Description"))),
    column(12,
           p("This Project is made by Shixin Huang 31029248 for FIT5147 2023S2. The data set for this assignment relates to a survey of the frog population of the state of Victoria. And we shall use R base on this dataset to make an visualisation about the habit of the frog with its observation and count numbers for each genus. the number of observations made of each frog genera and their different preferred terrain. and shows the hours in which observations occurred for each of the top four frog genera"))
  ),
  
  # Main content
  fluidRow(
    # VIS1 and MAP
    column(4,
           HTML("<h4><u>Count of Frog Genera with their preferred terrain</u></h4>")),
    column(8,
           HTML("<h4><u>Observation Locations Map and the number</u></h4>")),
    
    # create a range selection slider for number of observations
    column(
      width = 4,
      sliderInput(
        inputId = "obs_filter",
        label = "observations number range :",
        min = 1,
        max = max(frog_data %>%
                    group_by(Longitude, Latitude) %>%
                    summarize(n = n()) %>%
                    pull(n)),
        #value = c(1,max),
        value = c(1, max(frog_data %>%
                           group_by(Longitude, Latitude) %>%
                           summarize(n = n()) %>%
                           pull(n))),
        #value = 1,
        step = 1
      )
    ),
    # and a checklist for frog genera
    column(
      width = 4,
      checkboxGroupInput(
        # Set the input ID to genus_filter
        inputId = "genus_filter", 
        # Set the label for checkbox group
        label = "Select which frog genera to display:",
        # Load the unique frog genera from the frog_data column 'Genus'
        choices = unique(frog_data$Genus), 
        # Set the default selected frog genera as all unique frog genera
        selected = unique(frog_data$Genus), 
      )
    ),
    
    #  fluid row to display VIS1 plot and map
    fluidRow(
      column(4,
             plotOutput("vis1_plot")),
      column(8,
             leafletOutput("map")),
      
      
    ),
    
    # DES2
    
    column(12,
           HTML("<h4><u>Frog Frequency and Location of Frogs</u></h4>")),
    column(12,
           p("From the Plot we can see that the Crinia and Pseudophryne prefered living near water and it is true on the map. And Limnodynastes, Litoria has no specific prefered terrain and it also can be found everywhere on the map.Geocrinia only like living on land which also true base on the observation map")),
    
    # DES3 and VIS2
    column(6,
           HTML("<h4><u>Observation times of Top 4 Frog Genera</u></h4>")),
    column(6,
           HTML("<h4><u>Observation Hours for Top 4 Frog Genera</u></h4>")),
    
    
    column(6,
           p("The right figure shows the hours in which observations occurred for each of the top four frog genera. From this plot we can find that the Crinia and Litoria active alround all days. And all frogs keep active from 18:00 to 20:00 and it reach the highest value for all this four kinds.")),
    column(6,
           plotOutput("vis2_plot")),
    
    
  )
)

# server logic
server <- function(input, output) {
  
  # VIS1 bar chart the count of frog genera by preferred terrain
  output$vis1_plot <- renderPlot({
    ggplot(frog_data, aes(x = Genus, fill = Habitat)) +
      # Create a stack bar chart
      # position = "stack" - this stacks the bars on top of each other, which can be useful for showing the total value of each category.
      # position = "fill" - this fills the chart with the bars, so that each bar represents a proportion of the total value for each category.
      # position = "identity" - this leaves the bars in their original position, which is useful if you have already calculated the position of the bars manually.
      geom_bar(position = "stack") +
      
      # Set title, x-axis label, and y-axis label
      labs(title = "Count of Frog Genera by Preferred Terrain",
           x = "Genus",
           y = "Count") +
      
      # set the name of the scale fill legend
      scale_fill_discrete(name = "Preferred Terrain") +
      
      # Add count labels to each category of the chart
      geom_text(stat="count", aes(label=..count..),
                position=position_dodge(width=0.9), vjust=-0.5) +
      
      # set the position of legend to top
      theme(legend.position = "top") +
      
      # set the legend title and layout   
      guides(fill=guide_legend(title="Preferred Terrain", ncol=2,
                               byrow=TRUE, label.position="top"))
  })
  
  
  # round the longitude and latitude values to 3 decimal places
  frog_data$Longitude <- round(frog_data$Longitude, 3)
  frog_data$Latitude <- round(frog_data$Latitude, 3)
  
  # MAP leaflet map
  output$map <- renderLeaflet({
    frog_data %>%
      # Filter data based on user input from checkbox input
      filter(Genus %in% input$genus_filter) %>%
      
      # Group data by longitude, latitude, and genus
      group_by(Longitude, Latitude, Genus) %>%
      
      # Summarize data by count
      summarize(n = n()) %>%
      
      filter(n >= input$obs_filter[1] & n <= input$obs_filter[2]) %>%
      #filter(n >= input$obs_filter) %>%
      
      # Filter data based on oberservations count
      select(Longitude, Latitude, Genus, n) %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lng = ~Longitude, lat = ~Latitude, 
                       # Set the radius of circle markers based on square root of observation count
                       radius = ~sqrt(n)*3, 
                       #col = ~color,
                       #color = ~color[match(Genus, unique(Genus))],
                       #color = ~genus_colors[match(Genus, unique(Genus))],
                       color = ~color_palette[match(Genus, unique(Genus))], 
                       #color = ~genus_colors，
                       # circle marker has a border
                       stroke = TRUE, 
                       #  opacity of the fill color inside the circle marker.
                       fillOpacity = 0.5, 
                       # thickness of the border of the circle marker.
                       weight = 1, 
                       
                       # Set the label text for each marker
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
      geom_bar(stat = "identity") +
      #geom_bar(stat = "identity", position = "identity") +
      
      # Add the labels
      geom_text(aes(label = count), position = position_stack(vjust = 0.5)) +
      
      # Set chart title and axis labels
      labs(title = "Observation for Top 4 Frog Genera By Hour",
           x = "Hour of Day",
           y = "Count",
           fill = "Genus") +
      scale_fill_manual(values=color_palette)
  })
  
  
}

# shiny app and server
shinyApp(ui = ui, server = server)