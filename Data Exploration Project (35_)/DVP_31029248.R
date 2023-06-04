
library(shiny)
library(openxlsx)
library(ggplot2)
library(ggrepel)
library(plotly)
library(tidyverse)
library(readxl)

# Read data for Combined Attack
combined_Defend <- read.xlsx("data_clean/combined_Defend.xlsx", sheet = 1, startRow = 1)
# Read data for combined_Pass
combined_Pass <- read.xlsx("data_clean/combined_Pass.xlsx", sheet = 1, startRow = 1)
# Load the files into dataframes
combined_pass <- read_excel("data_clean/combined_Pass.xlsx")
combined_attack <- read_excel("data_clean/combined_attack.xlsx")

attack_data <- read.xlsx("data_clean/combined_attack.xlsx", sheet = 1, startRow = 1)
# Read the team data
team_data <- read.xlsx("data_clean/team_data.xlsx", sheet = 1)

# Define UI for application
ui <- fluidPage(
  #===================================================
  #Hearder ui
  #===================================================
  fluidRow(
    column(12, align = "center", h1("Evaluation of football from the FIFA World Cup 2022")),
  ),
  
  
  fluidRow(
    column(12, align = "center", h4(
      "Name: Shixin Huang;  Student ID: 31029248; 
      Tutor: Bruno Mendivez, Deep Mendha, Tutorial 5 "
    )
    ),
  ),
  
  fluidRow(
    column(12, align = "center", p(
      "Football is one of the most popular sports in the world, 
      and the FIFA World Cup is considered the most prestigious 
      soccer tournament. In modern soccer, data analysis has become 
      an integral part of team strategy, helping teams to identify 
      their strengths and weaknesses, analyze their performance and 
      that of their opponents, and devise effective game plans. 
      In this project, we will use data analysis and visualization 
      to research the evolution of football from the FIFA World Cup Qatar 2022. "
      )
      ),
  ),
  
  fluidRow(
    column(12, align = "center", h3("It called football not soccer!!!")),
  ),
  
  
  
  #===================================================
  #Passing and Attacking Statistics plot ui
  #===================================================
  fluidRow(
    column(12, align = "center", h2("Passing and Attacking Statistics")),
  
  ),
  fluidRow(
    column(9, align = "center", p(
      " bar charts with a dropdown menu allow the user to 
      select a team and compare their attacking and passing 
      statistics per location. The dropdown menu is located 
      at the top and allows the user to select the team to compare 
      This design is used to allow the user to quickly compare the 
      selected team's performance in attacking and passing in each 
      location. It provides a straightforward visualization that 
      can help the user identify patterns and trends in the team's 
      performance. The dropdown menu offers the user greater control 
      over the information they want to see, while the side-by-side charts 
      make it possible to compare the statistics conveniently and quickly.
      
      "
    )
    ),
    column(
      width = 3,
      selectInput(
        inputId = "PassingAttackingTeam",
        label = "Select team:",
        choices = c(
          "Total",
          sort(unique(c(combined_pass$Team, combined_attack$Team)))
        )
      )
    )
  ),
  
  fluidRow(
    column(
      width = 6,
      plotOutput("passPlot")
    ),
    column(
      width = 6,
      plotOutput("attackPlot")
    )
  ),
  
  #===================================================
  #scatter plot ui
  #===================================================
  fluidRow(
    column(12, align = "center", h2("Attacking Statistics for each team")),
    
  ),
  
  fluidRow(
    column(12, align = "center", 
    p("On the left, there is a scatterplot, displaying the shots 
    on target in the bubble format. The user can click on any bubble 
    to learn more about each shot. After clicking the bubble, a bar 
    chart on the left will display information about the selected 
    team's shots with detailed angles and positions. Furthermore, 
    the Goals and Expected Goals will also be highlighted in the 
    scatterplot. On the right-hand side, two tabs display the data 
    about the shot angle and shot range.
    This design is selected because it provides an easy-to-read and 
    interactive way of presenting the team's attacking performance 
    data. The scatterplot allows the user to quickly see how each 
    shot has performed, while a box displaying detailed information 
    on each selected shot.
                                   
                                   ")),
    
  ),
  
  
  fluidRow(
    column(6,
           h3("Goals and Expected per game")),
    column(6,
           h3("Average Shots Taken by Team"))
  ),
  
  fluidRow(
    column(width = 6, plotOutput("goalsVsXgPlot", click = "plotClick"), verbatimTextOutput("clickedPoint")),
    
    column(width = 6, 
           tabsetPanel(
             tabPanel("By Angle", plotOutput("shotAnglePlot")),
             tabPanel("By Location", plotOutput("shotRangePlot"))
           )
    )
  ),
  
  #===================================================
  #radar plot ui
  #===================================================
  fluidRow(
    column(12, align = "center", h2("Team statistics compare average as Radar Plot")),
   
  ),
  
  fluidRow(
    column(9, align = "center", 
           p("
             To operate the comparison, the user simply needs to select 
             the desired team from the dropdown menu. The defend statistics 
             plot will show how the team performs in defense, and the pass 
             statistics plot will show how the team performs in passing. Both 
             plots have different indicators that the user can hover over to 
             gain more detailed information about the statistics.
             
             The reason this design is selected because radar plots offer 
             an intuitive way to compare statistics between different teams. 
             These plots display multiple variables and show how they compare 
             to each other, which can be useful for identifying areas in which 
             the team is lacking. By using two separate radar plots, the user 
             can easily compare the team's performance in different aspects of 
             the game, defensing, and passing, in a more visually appealing way.

             
             ")),
    
    column(3, align = "center", selectInput("radar_team", "Select a team:",
                                           choices = unique(combined_Defend$Team)))
    
  ),
  
  fluidRow(
    column(6, align = "center", h3("Defend Statistics Plot")),
    column(6, align = "center", h3("Pass Statistics Plot")),
    
  ),
  
  hr(),
  
  hr(),
  
  # Show a plot of the selected team's defend statistics
  fluidRow(
    column(6, plotlyOutput("defend_radar_plot")),
    column(6, plotlyOutput("pass_radar_plot")),
  )
  
  
)

# Define server logic
server <- function(input, output) {
  #===================================================
  #Passing and Attacking Statistics plot logic
  #===================================================
  # Define the reactive function for team selection
  selected_team <- reactive({
    if (input$PassingAttackingTeam == "Total") {
      list(pass_data = combined_pass %>%
             select(Touch_Defend, Touch_Middle, Touch_Attck) %>%
             rename("Defensive Third" = Touch_Defend,
                    "Middle Third" = Touch_Middle,
                    "Final Third" = Touch_Attck)%>%
             mutate_all(~.x / 32),
           
           
           attack_data = combined_attack %>%
             select(Attack_Left, Attack_middle, Attack_right) %>%
             rename("Left side" = Attack_Left,
                    "Middle side" = Attack_middle,
                    "Right side" = Attack_right)%>%
             mutate_all(~.x / 32))
    } else {
      list(pass_data = combined_pass %>%
             filter(Team == input$PassingAttackingTeam) %>%
             select(Touch_Defend, Touch_Middle, Touch_Attck) %>%
             rename("Defensive Third" = Touch_Defend,
                    "Middle Third" = Touch_Middle,
                    "Final Third" = Touch_Attck),
           attack_data = combined_attack %>%
             filter(Team == input$PassingAttackingTeam) %>%
             select(Attack_Left, Attack_middle, Attack_right) %>%
             rename("Left side" = Attack_Left,
                    "Middle side" = Attack_middle,
                    "Right side" = Attack_right))
    }
  })
  
  # Create a reactive function for plot title
  selected_team_title <- reactive({
    if (input$PassingAttackingTeam == "Total") {
      "Total Attacks pass average per game  by Location"
    } else {
      paste0(input$PassingAttackingTeam, " Total Attacks pass average per game  by Location")
    }
  })
  
  # Create a reactive bar chart for the pass data
  output$passPlot <- renderPlot({
    selected_team_data <- selected_team()
    
    pass_sum <- selected_team_data$pass_data %>% summarise(across(everything(), sum))
    pass_sum <- pass_sum %>% pivot_longer(cols = everything(), names_to = "Location", values_to = "Touches")
    
    pass_plot_title <- ifelse(input$PassingAttackingTeam == "Total",
                              "Total Passes average per game by Location",
                              paste0(input$PassingAttackingTeam, " Total Passes average per game by Location"))
    
    ggplot(pass_sum, aes(x = Location, y = Touches, fill = Location)) +
      geom_bar(stat = "identity") +
      labs(title = pass_plot_title, y = "Percentage of Total Passes", x = "Location") +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      scale_fill_brewer(palette = "Paired") +
      geom_label(aes(label = paste0(scales::percent(Touches), "\n")),
                 position = position_stack(vjust = 0.5),
                 color = "white")
  })
  
  # Create a reactive bar chart for the attack data
  output$attackPlot <- renderPlot({
    selected_team_data <- selected_team()
    
    attack_sum <- selected_team_data$attack_data %>% summarise(across(everything(), sum))
    attack_sum <- attack_sum %>% pivot_longer(cols = everything(), names_to = "Location", values_to = "Attacks")
    
    attack_plot_title <- ifelse(input$PassingAttackingTeam == "Total",
                                "Total Attacks pass average per game by Location",
                                paste0(input$PassingAttackingTeam, " Total Attacks pass average per game by Location"))
    
    ggplot(attack_sum, aes(x = Location, y = Attacks, fill = Location)) +
      geom_bar(stat = "identity") +
      labs(title = attack_plot_title, y = "Percentage of Total Attacks", x = "Location") +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      scale_fill_brewer(palette = "Paired") +
      geom_label(aes(label = paste0(scales::percent(Attacks), "\n")),
                 position = position_stack(vjust = 0.5),
                 color = "white")
  })
  
  #===================================================
  #scatter plot logic
  #===================================================
  # Select team, games, goals per 90, and xg per 90 columns
  selected_cols <- team_data %>% select(team, games, goals_per90, xg_per90)
  
  # Filter the rows where games = 3, 4, 5, and 7
  filtered_data <- selected_cols %>%
    filter(games %in% c(3, 4, 5, 7))
  
  # Select the team, goals per 90, and xg per 90 columns
  plot_data <- filtered_data %>% select(team, games, goals_per90, xg_per90)
  
  # Create a plot of goals_per90 and xg_per90 for each team
  output$goalsVsXgPlot <- renderPlot({
    
    ggplot(plot_data, aes(x = goals_per90, y = xg_per90, label = team, col = as.factor(games))) + 
      geom_point(size = 3) + 
      geom_text(size = 3, nudge_x = 0.2, nudge_y = 0.2) +
      labs(x = "goals per game", y = "Expected goals per game", title = "Goals and Expected per game") +
      labs(col="Match")+
      scale_color_manual(values = c("#228B22", "#BDB76B", "#FF0000", "#0000FF"),
                         breaks = c(3, 4, 5, 7), 
                         labels = c("3 games", "4 games", "5 games", "7 games")) +
      theme_classic()
  })
  
  # Handle clicks on the plot
  
  # Define reactive variable to store team selection
  teamSelect <- reactiveVal()
  
  output$clickedPoint <- renderPrint({
    click <- input$plotClick
    if (is.null(click)){
      return()
    }
    nearPointData <- nearPoints(plot_data, click, allRows = FALSE, maxpoints = 1)
    if (nrow(nearPointData) == 0) {
      return()
    }
    team <- unique(nearPointData$team)
    goals <- unique(nearPointData$goals_per90)
    xg <- unique(nearPointData$xg_per90)
    #teamSelect <- unique(nearPointData$team)
    teamSelect(unique(nearPointData$team))
    paste("Team:", team, 
          ",Goals pergame:", goals, 
          ",Expected goals pergame:", xg)
  })
  
  
  
  
  # Create the plot by angle
  output$shotAnglePlot <- renderPlot({
    
    # Get the selected team
    teamSelect <- ifelse(is.null(teamSelect()), "Average", teamSelect())
    
    #if (input$teamSelect == "Average")
    if (teamSelect == "Average") {
      avg_left_angle <- mean(attack_data$Shot_left)
      avg_middle_angle <- mean(attack_data$Shot_middle)
      avg_right_angle <- mean(attack_data$Shot_right)
    } else {
      team_data <- attack_data[attack_data$Team == teamSelect,]
      avg_left_angle <- mean(team_data$Shot_left)
      avg_middle_angle <- mean(team_data$Shot_middle)
      avg_right_angle <- mean(team_data$Shot_right)
    }
    
    
    # Create a data frame for plotting by angle
    avg_df_angle <- data.frame(location = c("Left", "Middle", "Right"), 
                               average = c(avg_left_angle, avg_middle_angle, avg_right_angle))
    
    
    ggplot(data = avg_df_angle, aes(x = location, y = average, fill = location)) +
      geom_bar(stat = "identity", color = "black", alpha = .8) +
      ggtitle(teamSelect," Team Average Shots Taken by Angle") +
      xlab("Shot Location") +
      ylab("Average Shots per game") +
      theme_minimal() +
      theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
            axis.title = element_text(size = 14, face = "bold"),
            axis.text = element_text(size = 12),
            legend.position = "none") +
      geom_text(aes(label = round(average, 2)), vjust = -0.5, size = 4)
  })
  
  
  
  # Create the plot by location
  output$shotRangePlot <- renderPlot({
    
    # Get the selected team
    teamSelect <- ifelse(is.null(teamSelect()), "Average", teamSelect())
    
    # Calculate average values by location
    # if (input$teamSelect == "Average") 
    if (teamSelect == "Average") {
      avg_left_location <- mean(attack_data$Shot_in_6_yard_box)
      avg_middle_location <- mean(attack_data$Shot_in_18_yard_box)
      avg_right_location <- mean(attack_data$Shot_outsie_box)
    } else {
      team_data <- attack_data[attack_data$Team == teamSelect,]
      avg_left_location <- mean(team_data$Shot_in_6_yard_box)
      avg_middle_location <- mean(team_data$Shot_in_18_yard_box)
      avg_right_location <- mean(team_data$Shot_outsie_box)
    }
    
    # Create a data frame for plotting by location
    avg_df_location <- data.frame(location = c("Goal", "Penalty", "Out of Box"), 
                                  average = c(avg_left_location, avg_middle_location, avg_right_location))
    
    ggplot(data = avg_df_location, aes(x = location, y = average, fill = location)) +
      geom_bar(stat = "identity", color = "black", alpha = .8) +
      ggtitle(teamSelect,"Team Average Shots Taken by Location") +
      xlab("Shot Location") +
      ylab("Average Shots per game") +
      theme_minimal() +
      theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
            axis.title = element_text(size = 14, face = "bold"),
            axis.text = element_text(size = 12),
            legend.position = "none") +
      geom_text(aes(label = round(average, 2)), vjust = -0.5, size = 4)
  })
  
  
  
  
  #===================================================
  #radar plot logic
  #===================================================
  # Create a reactive plot based on the selected team
  output$defend_radar_plot <- renderPlotly({
    # Find selected team's row
    choice_team_row <- combined_Defend[combined_Defend$Team == input$radar_team, ][, -1]
    
    # Calculate the average statistic values across all teams
    avg_stats <- colMeans(combined_Defend[, -1])
    
    team_row <- (choice_team_row - avg_stats) * 100 / avg_stats
    
    # Create a data frame for plotting
    diff_df <- data.frame(statistic = colnames(team_row),
                          value = as.numeric(team_row),
                          stringsAsFactors = FALSE)
    
    # Create the plot
    plot_ly(diff_df, type = "scatterpolar", mode = "lines", line = list(width = 2, color = '#636EFA')) %>%
      add_trace(r = diff_df$value, theta = diff_df$statistic,
                name = paste0(input$radar_team, "'s Defend Statistics")) %>%
      layout(
        title = paste0(input$radar_team, "'s Defend Statistics"),
        polar = list(radialaxis = list(visible = TRUE, range = c(-50, 80))),
        showlegend = TRUE,
        legend = list(
          x = 0.1, y = 0.9,
          bgcolor = "rgba(255, 255, 255, 0.85)",
          bordercolor = "#FFFFFF",
          borderwidth = 2
        ),
        margin = list(l = 20, r = 20, b = 20, t = 40),
        paper_bgcolor = "white",
        plot_bgcolor = "white"
      )
  })
  
  # Create a reactive plot based on the selected team
  output$pass_radar_plot <- renderPlotly({
    # Find selected team's row
    choice_team_row <- combined_Pass[combined_Pass$Team == input$radar_team, ][, -1]
    
    # Calculate the average statistic values across all teams
    avg_stats <- colMeans(combined_Pass[, -1])
    
    team_row <- (choice_team_row - avg_stats) * 100 / avg_stats
    
    # Create a data frame for plotting
    diff_df <- data.frame(statistic = colnames(team_row),
                          value = as.numeric(team_row),
                          stringsAsFactors = FALSE)
    
    # Create the plot
    plot_ly(diff_df, type = "scatterpolar", mode = "lines", line = list(width = 2, color = '#636EFA')) %>%
      add_trace(r = diff_df$value, theta = diff_df$statistic,
                name = paste0(input$radar_team, "'s Pass Statistics")) %>%
      layout(
        title = paste0(input$radar_team, "'s Pass Statistics"),
        polar = list(radialaxis = list(visible = TRUE, range = c(-50, 50))),
        showlegend = TRUE,
        legend = list(
          x = 0.1, y = 0.9,
          bgcolor = "rgba(255, 255, 255, 0.85)",
          bordercolor = "#FFFFFF",
          borderwidth = 2
        ),
        margin = list(l = 20, r = 20, b = 20, t = 40),
        paper_bgcolor = "white",
        plot_bgcolor = "white"
      )
  })
  
}

# Run the application
shinyApp(ui, server)
