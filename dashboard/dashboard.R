##############################################################################################
# Creator        : Robby Lysander Aurelio                                                    #
# Creation Date  : June 25, 2023                                                             #
# Project Title  : Why are the IT Sector-Related Jobs Compelling from the Financial Aspect?  #
#                  And Where is The Best Place to Work in the IT Sector in the US?           #
##############################################################################################

# =======================================================================
# THIS BLOCK OF CODE IS FOR installing and loading the necessary packages 
# =======================================================================

# List of the required packages
required_packages = c('plyr', 'dplyr', 'scales', 'forecast', 'shiny', 'shinydashboard', 
                      'ggplot2', 'plotly', 'dygraphs', 'leaflet', 'RColorBrewer')

# Check if each package is installed and load it
for (package in required_packages){
  if(!require(package, character.only = TRUE)){
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

# Load all the necessary packages
library(plyr)              # For data manipulation (only use the round_any function)
library(dplyr)             # For data manipulation
library(scales)            # To scale the data for clustering
library(forecast)          # For forecasting
library(shiny)             # To make interactive visualization
library(shinydashboard)    # To make dashboard for the shiny package
library(ggplot2)           # Create a plot
library(plotly)            # Create an interactive plot
library(dygraphs)          # Create an interactive time series plot
library(leaflet)           # Create an interactive map
library(RColorBrewer)      # For color palette


# ============================================
# THIS BLOCK OF CODE IS FOR loading the data
# ============================================

# Load the US sectors data and aggregate them by sector
sector_data = read.csv('./data/salary_by_sector.csv') %>%
  group_by(sector) %>%
  summarise(salary = mean(annual_median_wage, na.rm = TRUE), no_of_workers = sum(total_employment, na.rm = TRUE))

# Load the IT sector growth data
growth_data = read.csv('./data/it_sector_growth.csv')

# Aggregate the data for the national level
national_growth_data = growth_data %>%
  group_by(year) %>%
  summarise(no_of_workers = sum(total_employee, na.rm = TRUE), salary = mean(annual_median_wage, na.rm = TRUE), no_of_comps = sum(no_of_comp, na.rm = TRUE))

# Load the IT sector by state data
state_data = read.csv('./data/it_sector_by_state.csv')


# =====================================================
# THESE BLOCK OF CODE IS FOR creating the dashboard ui
# =====================================================

ui = dashboardPage(
  dashboardHeader(title = 'IT Sector in the US'),
  
  # ---------------------------------------
  # Creating the sidebars for the dashboard
  # ---------------------------------------
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Home', tabName = 'home', icon = icon('house')),
      menuItem('Sectors Comparison', tabName = 'sector_compare', icon = icon('bars')),
      menuItem('IT Sector Growth', tabName = 'it_growth', icon = icon('bars')),
      menuItem('States Comparison', tabName = 'state_compare', icon = icon('bars'),
               menuSubItem('Salary Map', tabName = 'sal_map', icon = icon('globe')),
               menuSubItem('Salary VS Living Cost', tabName = 'sal_vs_cost', icon = icon('globe')))
    )),
  
    # -------------------------------------
  # Defining the content of each sidebar
  # -------------------------------------
  
  dashboardBody(
    tabItems(
      
      # ++++++++++++++++
      # The "Home Page"
      # ++++++++++++++++
      
      tabItem(tabName = 'home',
              headerPanel('Why are the IT Sector-Related Jobs Compelling from the Financial Aspect?
                          And Where is The Best Place to Work in the IT Sector in the US?'),
              fluidRow(
                box(width = 12,
                    h2('Project Description'),
                    p(style = 'text-align: justify;',
                      'Many people said that we are now in the ', strong('"Digital Age"'), ' where technology is ', strong('highly used in day-to-day life.'),  
                      'This new', strong('“digital culture”'), 'causes the rapid development of the IT sector. 
                      According to the', strong('US Bureau of Labor Statistics'), 'the IT Sector itself had an average salary of', strong('$108,130 annually'), 'on May 2022, which was relatively higher than other sectors. 
                      Thus, many regard working in the IT sector as really', strong('“attractive”'), 'in this digital age. But, is it true that the job itself is really compelling? 
                      That is why, this project is carried out', strong('to investigate whether the IT sector is really promising or not from a financial point of view.'), 
                      'In addition to investigating the prospect, it is also worth knowing', strong('where is the most promising location to work in the IT sector in the US,'), 'also seen from its financial aspect.'),
                    p(style = 'text-align: justify;',
                      'This visualization will aim to answer these questions:'),
                    HTML(
                      '<ol>
                        <li> What makes the IT sector more compelling than other sectors in the US from the financial point of view? </li>
                        <li> Based on past historical data, what does the future prospect of the IT sector in the US look like from several parameters? </li>
                        <li> Where is the best location (state) in the US to work in the IT sector based on its financial aspect? </li>
                      </ol>'
                    ))
              )),
      
      # ++++++++++++++++++++++++++++++++
      # The "US Sectors Comparison" menu
      # ++++++++++++++++++++++++++++++++
      
      tabItem(tabName = 'sector_compare',
              headerPanel('US Sectors Comparison'),
              sidebarLayout(
                sidebarPanel(
                  p('Pick the number of clusters shown'),
                  numericInput('sector_k', 'Number of Clusters',
                               min = 2, max = 8,
                               value = 4),
                  h2('Page Description'),
                  p('*Put your cursor on the scatter plot to see the annotations.'),
                  p('Page description:'),
                  HTML("<ul>
                        <li> This page aims to compare the sectors in the US from financial point of view. </li>
                        <li> The parameters compared in this chart are annual median salary and number of workers. </li>
                        <li> The IT sector in the scatter plot is represented as the 'Computer and Mathematical' sector. </li>
                       </ul>
                      ")),
                mainPanel(
                  plotlyOutput('sector_scatter_plot'),
                  br()
                  )),
              fluidRow(
                box(width = 12,
                  h2('Discoveries'),
                  HTML("<ul>
                          <li> The IT sector has higher salary almost other sectors, except for the management sector. </li>
                          <li> The number of workers in the IT sector is relatively lower than most of the other sectors. </li>
                          <li> The IT sector is located in the middle of two 'clusters/groups' which are:
                          <ul>
                            <li> The management and healthcare practitioner sector group. </li>
                            <li> The architecture and engineering, life, physical, and social science, and legal sector group. </li>
                          </ul>
                          <li> Therefore, sometimes, the clustering result will group the IT sector with one of those two sector groups, or with both, or even a lone data point. </li>
                        </ul>"))
              )
              ),
      
      # +++++++++++++++++++++++++++
      # The "IT Sector Growth" menu
      # +++++++++++++++++++++++++++
      
      tabItem(tabName = 'it_growth',
              headerPanel("US IT Sector's Growth"),
              tabsetPanel(
                type = 'tabs',
                
                # **************************
                # Tab for the national level
                # **************************
                
                tabPanel('National Level',
                         sidebarPanel(
                           p('Choose the parameter to be shown'),
                           radioButtons('nat_para', 'Parameters',
                                        choices = c('Salary', 'Number of Workers', 'Number of Companies'),
                                        selected = 'Salary'),
                           h2('Page Description'),
                           p('*Put your cursor on the line chart to see the annotations.'),
                           p('Page description:'),
                           HTML("<ul>
                                  <li> This page aims to show the growth of the IT sector in the US from 1997 to 2022. </li>
                                  <li> A forecast using ARIMA model had also been done to show the future prospect of the IT sector. </li>
                                  <li> The parameters shown in this chart are annual median salary, number of workers, and number of IT companies. </li>
                                 </ul>")),
                         mainPanel(
                           h2('National Level Growth'),
                           dygraphOutput('nat_forecast'),
                           br()
                         )),
                
                # *******************
                # Tab for State Level
                # *******************
                
                tabPanel('State Level',
                         sidebarPanel(
                           p('Choose a state'),
                           selectInput('state', 'State',
                                       choices = unique(growth_data$state)),
                           p('Choose the parameter to be shown'),
                           radioButtons('state_para', 'Parameters',
                                        choices = c('Salary', 'Number of Workers', 'Number of Companies'),
                                        selected = 'Salary'),
                           h2('Page Description'),
                           p('*Put your cursor on the line chart to see the annotations.'),
                           p('Page description:'),
                           HTML("<ul>
                                  <li> This page aims to show the growth of the IT sector in the US from 1997 to 2022 for each state. </li>
                                  <li> Moreover, a forecast using ARIMA model had also been done to show the future prospect of the IT sector. </li>
                                  <li> The parameters shown in this chart are annual median salary, number of workers, and number of IT companies. </li>
                                 </ul>")),
                         mainPanel(
                           h2('State Level Growth'),
                           dygraphOutput('state_forecast'),
                           br()
                         ))),
              fluidRow(
                box(width = 12,
                    h2('Discoveries'),
                    HTML("<ul>
                            <li> The salary and number of companies have positive growth since 1997, both for national level and for each state. </li>
                            <li> The forecasting result also gives an increasing number for both parameters. </li>
                            <li> However, interestingly, for the number of workers, there was a sudden decrease from 1998 to 1999, but gradually increased from then on. </li>
                            <li> This decrease causes some interesting results when doing the forecast: </li>
                            <ul>
                              <li> The forecasting result gives a constant value for the number of workers, except for: California, Colorado, Utah, Virginia, and Washington. </li>
                              <li> Both confidence levels (80% and 95%) have a wide range, even the national level and some states give negative values. </li>
                              <li> Those states include: Alaska, Arizona, Arkansas, California, Florida, Georgia, Louisiana, Maine, Minnesota, Mississippi, Montana, Nevada, North Carolina, Texas, Vermont, Washington, West Virginia, Wisconsin, and Wyoming. </li>
                            </ul>
                          </ul>"))
              )),
      
      # +++++++++++++++++++++++++++++
      # The "Salary Mapping" sub-menu
      # +++++++++++++++++++++++++++++
      
      tabItem(tabName = 'sal_map',
              headerPanel('Salary Mapping'),
              fluidRow(
                box(width = 12,
                    h2('Page Description'),
                    HTML("<ul>
                            <li> This page aims to compare the IT sector's salary between states in the US. </li>
                            <li> The parameters shown in this chart are annual median salary and number of IT companies in the state. </li>
                            <li> The colour of the circle shows the salary, in which darker colour means higher salary. </li>
                            <li> The size of the circle shows the number of IT companies in the state. </li>
                          </ul>")),
                box(width = 12,
                    h2('Salary Map'),
                    p('Select the salary range to be shown'),
                    sliderInput('map_sal_range', 'Salary Range',
                                min = round_any(min(state_data$annual_median_wage), 10000, floor), 
                                max = round_any(max(state_data$annual_median_wage), 10000, ceiling),
                                value = c(round_any(min(state_data$annual_median_wage), 10000, floor), 
                                          round_any(max(state_data$annual_median_wage), 10000, ceiling)),
                                step = 1000,
                                ticks = FALSE),
                    p('*Put your cursor on the bubble map to see the annotations.'),
                    leafletOutput('salary_map')),
                column(width = 6,
                  box(width = 12,
                      h2('Top 5 States'),
                      HTML("<ol>
                              <li> California </li>
                              <li> New York </li>
                              <li> Texas </li>
                              <li> Illinois </li>
                              <li> Massachusetts </li>
                            </ol>"))),
                column(width = 6,
                  box(width = 12,
                      h2('Bottom 5 States'),
                      HTML("<ol>
                              <li> Wyoming </li>
                              <li> West Virginia </li>
                              <li> Mississippi </li>
                              <li> Montana </li>
                              <li> North Dakota </li>
                            </ol>")))
              )),
      
      # ++++++++++++++++++++++++++++++++
      # The "Salary Comparison" sub-menu
      # ++++++++++++++++++++++++++++++++
      
      tabItem(tabName = 'sal_vs_cost',
              headerPanel('Salary VS Living Cost Comparison by State'),
              sidebarLayout(
                sidebarPanel(
                  p('Pick the salary range to be shown'),
                  sliderInput('sal_range', 'Salary Range',
                              min = round_any(min(state_data$annual_median_wage), 10000, floor), 
                              max = round_any(max(state_data$annual_median_wage), 10000, ceiling),
                              value = c(round_any(min(state_data$annual_median_wage), 10000, floor), 
                                        round_any(max(state_data$annual_median_wage), 10000, ceiling)),
                              step = 1000,
                              ticks = FALSE),
                  p('Pick the living cost range to be shown'),
                  sliderInput('cost_range', 'Living Cost Range',
                              min = round_any(min(state_data$living_cost), 10000, floor), 
                              max = round_any(max(state_data$living_cost), 10000, ceiling),
                              value = c(round_any(min(state_data$living_cost), 10000, floor), 
                                        round_any(max(state_data$living_cost), 10000, ceiling)),
                              step = 1000,
                              ticks = FALSE),
                  h2('Page Description'),
                  p('*Put your cursor on the scatter plot to see the annotations.'),
                  p('Page description:'),
                  HTML("<ul>
                            <li> This page aims to compare the IT sector's salary and living cost between states in the US. </li>
                            <li> The parameters shown in this chart are annual median salary and average annual living cost in the state. </li>
                            <li> The size of the point shows the number of IT companies in the state. </li>
                            <li> The horizontal line is the annual median salary for the IT sector at national level ($100,440). </li>
                            <li> The vertical line is the average living cost in the US at national level ($25,344). </li>
                          </ul>")),
                mainPanel(
                  plotlyOutput('state_scatter_plot'),
                  br(),
                  box(width = 12,
                      h2('Discoveries'),
                      HTML("<ul>
                            <li> Target quadrant: top-left (higher salary than the median and lower living cost than average). </li>
                            <li> The only state in the targeted quadrant: <b> North Carolina </b>. </li>
                            <li> Other states located near the border: <b> Georgia </b>, <b> Minnesota </b>,<b> Illinois </b>, and <b> Virginia </b>. </li>
                            <li> <b> Hawaii </b> is an outlier, in which it has the highest living cost, but below average salary. </li>
                          </ul>"))
              ))
    ))))


# ===========================================================
# THESE BLOCK OF CODE IS FOR the dashboard server processing
# ===========================================================

server = function(input, output){
 
  # -------------------------------------------------
  # Create the scatter plot for the sector comparison
  # -------------------------------------------------
  
  output$sector_scatter_plot = renderPlotly({
    
    # ++++++++++
    # Clustering
    # ++++++++++
    
    # Reference for clustering: lecture's notes
    # Scale the necessary data
    sector_scaled_data = sector_data %>%
      select(no_of_workers, salary) %>%
      scale()
    
    # Create the clustersing model using K-means
    sector_kmeans_model = kmeans(sector_scaled_data, centers = input$sector_k, nstart = 1)
    
    # Add the clustering result to the sector dataset
    sector_data$cluster = as.factor(sector_kmeans_model$cluster)
    
    # +++++++++++++++
    # Create the plot
    # +++++++++++++++
    
    plot1 = ggplot(sector_data, aes(no_of_workers, salary, color = cluster,
                                   text = paste0('Sector: ', sector,
                                                 '\nNo. of Workers: ', formatC(no_of_workers, big.mark = ',', format = 'd'),
                                                 '\nSalary: $', formatC(salary, big.mark = ',', format = 'd')))) +
      geom_point(size = 3) +
      scale_x_continuous(labels = comma) + 
      scale_y_continuous(labels = comma) +
      labs(x = 'Number of Workers', y = 'Salary (in USD)', color = 'Clusters')
    ggplotly(plot1, tooltip = 'text')
  })
  
  # ------------------------------------------------------------------------
  # Create the line chart for showing the IT Sector Growth at national level
  # ------------------------------------------------------------------------
  
  output$nat_forecast = renderDygraph({ 
    
    # +++++++++++++++++++++++++++++++++++++
    # Filtering the data and do forecasting
    # +++++++++++++++++++++++++++++++++++++
    
    # Reference for forecasting: lecture's notes
    if(input$nat_para == 'Salary'){
      # Only pick the selected column
      selected_growth_data = national_growth_data %>%
        select(year, salary)
      
      y_lab = 'Salary (in USD)'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$salary, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    else if(input$nat_para == 'Number of Workers'){
      # Only pick the selected column
      # Remove the empty (zero) values
      selected_growth_data = national_growth_data %>%
        select(year, no_of_workers) %>%
        filter(no_of_workers != 0)
      
      y_lab = 'Number of Workers'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$no_of_workers, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    else{
      # Only pick the selected column
      # Remove the empty (zero) values
      selected_growth_data = national_growth_data %>%
        select(year, no_of_comps) %>%
        filter(no_of_comps != 0)
      
      y_lab = 'Number of Companies'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$no_of_comps, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    # +++++++++++++++
    # Create the plot
    # +++++++++++++++
    
    # Reference: towardsdatascience.com/how-to-create-better-interactive-forecast-plots-using-r-and-dygraph-29bdd7146066
    # By: Thomas Bierhance
    # Modification:
    #   1. Write the tooltip format inside the block, not creating a new function
    #   2. Change the writing format for the 80% and 95% boundaries
    #   3. Change the y-axis formatting into KMG (Kilo, Mega, Giga) format
    #   4. Change the y-axis label depending on the parameter selected
    #   5. Remove the range selector
    
    # Plot the historical data and forecasted values
    forecast_values %>%
      {cbind(actual =.$x, mean =.$mean,
             l95 =.$lower[,'95%'], u95 =.$upper[,'95%'],
             l80 =.$lower[,'80%'], u80 =.$upper[,'80%'])} %>%
      dygraph(ylab = y_lab) %>%
      dyAxis('y', valueFormatter = "function(num, opts, seriesName, graph, row, col){
                                        value = graph.getValue(row, col)
                                        if(value[0] != value[2]){
                                          lower = Dygraph.numberValueFormatter(value[0], opts)
                                          upper = Dygraph.numberValueFormatter(value[2], opts)
                                          return lower + ' - ' + upper
                                        }
                                        else{
                                          return Dygraph.numberValueFormatter(num, opts)
                                        }
                                      }")  %>%
      dySeries('actual', label = 'Actual', color = 'black') %>%
      dySeries('mean', label = 'Forecast', color = 'blue') %>%
      dySeries(c('l80', 'mean', 'u80'),
               label = '80%', color = 'blue') %>%
      dySeries(c('l95', 'mean', 'u95'),
               label = '95%', color = 'blue') %>%
      dyLegend(labelsSeparateLines = TRUE) %>%
      dyOptions(digitsAfterDecimal = 1, labelsKMG = TRUE)
  })
  
  # ---------------------------------------------------------------------
  # Create the line chart for showing the IT Sector Growth at state level
  # ---------------------------------------------------------------------
  
  # References and modifications are the same as the national level
  output$state_forecast = renderDygraph({
    
    # +++++++++++++++++++++++++++++++++
    # Data filtering and do forecasting
    # +++++++++++++++++++++++++++++++++
    
    # Filter the data by state
    state_growth_data = growth_data %>%
      filter(state == input$state)
    
    if(input$state_para == 'Salary'){
      # Only pick the selected column
      selected_growth_data = state_growth_data %>%
        select(year, annual_median_wage)
      
      y_lab = 'Salary (in USD)'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$annual_median_wage, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    else if(input$state_para == 'Number of Workers'){
      # Only pick the selected column
      # Remove the empty (zero) values
      selected_growth_data = state_growth_data %>%
        select(year, total_employee) %>%
        filter(total_employee != 0)
      
      y_lab = 'Number of Workers'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$total_employee, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    else{
      # Only pick the selected column
      # Remove the empty (zero) values
      selected_growth_data = state_growth_data %>%
        select(year, no_of_comp) %>%
        filter(no_of_comp != 0)
      
      y_lab = 'Number of Companies'
      
      # Generate forecasts for a specified time horizon by using ARIMA
      forecast_values = ts(selected_growth_data$no_of_comp, frequency = 1, start = min(selected_growth_data$year)) %>%
        auto.arima() %>%
        forecast(h = 20)
    }
    
    # +++++++++++++++
    # Create the plot
    # +++++++++++++++
    
    # Plot the historical data and forecasted values
    forecast_values %>%
      {cbind(actual =.$x, mean =.$mean,
             l95 =.$lower[,'95%'], u95 =.$upper[,'95%'],
             l80 =.$lower[,'80%'], u80 =.$upper[,'80%'])} %>%
      dygraph(ylab = y_lab) %>%
      dyAxis('y', valueFormatter = "function(num, opts, seriesName, graph, row, col){
                                        value = graph.getValue(row, col)
                                        if(value[0] != value[2]){
                                          lower = Dygraph.numberValueFormatter(value[0], opts)
                                          upper = Dygraph.numberValueFormatter(value[2], opts)
                                          return lower + ' - ' + upper
                                        }
                                        else{
                                          return Dygraph.numberValueFormatter(num, opts)
                                        }
                                      }")  %>%
      dySeries('actual', label = 'Actual', color = 'black') %>%
      dySeries('mean', label = 'Forecast', color = 'blue') %>%
      dySeries(c('l80', 'mean', 'u80'),
               label = '80%', color = 'blue') %>%
      dySeries(c('l95', 'mean', 'u95'),
               label = '95%', color = 'blue') %>%
      dyLegend(labelsSeparateLines = TRUE) %>%
      dyOptions(digitsAfterDecimal = 1, labelsKMG = TRUE)
  })
  
  # -------------------
  # Create a bubble map
  # -------------------
  
  output$salary_map = renderLeaflet({
    
    # ++++++++++++++++
    # Data preparation
    # ++++++++++++++++
    
    # Filter the salary in the range
    selected_salary_data = state_data %>%
      filter(annual_median_wage >= input$map_sal_range[1] & annual_median_wage <= input$map_sal_range[2])
    
    # Create a color palette
    my_bins = c(60000, 70000, 80000, 90000, 100000, 110000, Inf)
    my_palette = colorBin(palette = brewer.pal(8,'YlOrRd')[3:8], domain = 'state_data$annual_median_wage', na.color = 'transparent', bins = my_bins)
    
    # Define the labels for legend/color palette
    my_label = c('≤ $70,000', '$70,000 - $80,000', '$80,000 - $90,000', '$90,000 - $100,000', '$100,000 - $110,000', '≥ $110,000')
    
    # Define the text for marker/tooltip
    my_text = paste0(
      'State: ', selected_salary_data$state, '<br/>',
      'IT Sector Salary: $', formatC(selected_salary_data$annual_median_wage, big.mark=',', format = 'd'), '<br/>',
      'No. of Companies: ', formatC(selected_salary_data$no_of_comp, big.mark=',', format = 'd'), '<br/>') %>%
      lapply(htmltools::HTML)
    
    # +++++++++++++++++++++
    # Create the bubble map
    # +++++++++++++++++++++
    
    # Reference: r-graph-gallery.com/19-map-leafletr.html
    # By: Yan Holtz
    # Modification:
    #   1. Modify the size of the circle depending on the number of IT companies in the state
    #   2. Manually define the legend texts
    #   3. Manually choose the colors from the palette
    
    # Create the bubble map
    leaflet(selected_salary_data) %>%
      addTiles() %>%
      setView(lat = 48, lng = -96, zoom = 3) %>%
      addCircleMarkers(~long, ~lat,
                       fillColor = ~my_palette(annual_median_wage),
                       fillOpacity = 0.7,
                       color = 'white',
                       radius = ~rescale(no_of_comp, c(8,18)),
                       stroke = FALSE,
                       label = my_text,
                       labelOptions = labelOptions(style = list('font-weight' = 'normal',
                                                                padding = '3px 8px'),
                                                   textsize = '13px',
                                                   direction = 'auto')) %>%
      addLegend(pal = my_palette, values = ~annual_median_wage,
                opacity = 1, title = 'Salary (in USD)',
                position = 'bottomright',
                labFormat = function(type, cuts, p){
                  paste0(my_label)
                })
  })
  
  # -------------------------------------------------
  # Create the scatter plot for the states comparison
  # -------------------------------------------------
  
  output$state_scatter_plot = renderPlotly({
    
    # ++++++++++++++
    # Data filtering
    # ++++++++++++++
    
    # Filter the selected range
    selected_state_data = state_data %>%
      filter(annual_median_wage >= input$sal_range[1] & annual_median_wage <= input$sal_range[2]) %>%
      filter(living_cost >= input$cost_range[1] & living_cost <= input$cost_range[2])
    
    # +++++++++++++++
    # Create the plot
    # +++++++++++++++
    
    plot2 = ggplot(selected_state_data, aes(living_cost, annual_median_wage, 
                                  size = no_of_comp,
                                  text = paste0('State: ', state,
                                                '\nLiving Cost: $', formatC(living_cost, big.mark = ',', format = 'd'),
                                                '\nSalary: $', formatC(annual_median_wage, big.mark = ',', format = 'd'),
                                                '\nNo. of Company: ', formatC(no_of_comp, big.mark = ',', format = 'd')))) +
      geom_point(aes(fill = 'salmon'), color = 'red', alpha = 0.7) +
      scale_x_continuous(labels = comma) + 
      scale_y_continuous(labels = comma) +
      geom_hline(aes(yintercept = 100440, alpha = 0.5)) +    # Median annual wage for IT sector in US
      geom_vline(aes(xintercept = 25344, alpha = 0.5)) +     # Average annual living cost in the US
      theme(legend.position = 'none') +
      labs(x = 'Living Cost (in USD)', y = 'Salary (in USD)')
    
    ggplotly(plot2, tooltip = 'text')
  })
}

shinyApp(ui, server)