library(shiny)
library(bslib)
library(leaflet)
library(dplyr)
library(htmltools)

# Load datasets
exhibitions_df <- read.csv("data/exhibitions.csv", stringsAsFactors = FALSE)
coords_df <- read.csv("data/museum_coords.csv", stringsAsFactors = FALSE)

# Merge datasets
full_df <- exhibitions_df %>%
  left_join(coords_df, by = "Museum")

# Extract unique filter choices
regions <- c("All Regions", sort(unique(coords_df$Region)))
genres <- c("All Genres", sort(unique(exhibitions_df$Genre)))
artifact_types <- c("All Types", sort(unique(exhibitions_df$Artifact.Type)))
age_groups <- c("All Ages", sort(unique(exhibitions_df$Age.Group)))

ui <- page_navbar(
  theme = bs_theme(
    bootswatch = "lux",
    primary = "#1A365D",
    secondary = "#2B6CB0",
    success = "#2F855A",
    font_scale = 0.95
  ),
  title = div(
    class = "d-flex align-items-center gap-2",
    tags$span(style = "font-size: 1.4rem; font-weight: 700; color: #1A365D;", "🏛️ California Museum & Exhibition Guide")
  ),
  sidebar = sidebar(
    width = 320,
    title = h5("Exhibition Filters", class = "mb-3 font-weight-bold"),
    
    selectInput("region_filter", "Region", choices = regions, selected = "All Regions"),
    selectInput("genre_filter", "Exhibition Genre", choices = genres, selected = "All Genres"),
    selectInput("artifact_filter", "Artifact / Art Type", choices = artifact_types, selected = "All Types"),
    selectInput("age_filter", "Age Group", choices = age_groups, selected = "All Ages"),
    selectInput("cost_filter", "Admission Cost", choices = c("All Options", "Free Admission", "Paid Admission"), selected = "All Options"),
    
    textInput("search_filter", "Search Keyword / Artist", placeholder = "e.g. Monet, Space, Fossil..."),
    
    hr(),
    actionButton("reset_btn", "Reset All Filters", class = "btn-outline-secondary w-100 mb-2"),
    
    div(
      class = "small text-muted mt-3",
      "Click on any map marker to view exhibitions for that specific museum."
    )
  ),
  
  nav_panel(
    title = "Interactive Explorer",
    layout_sidebar(
      sidebar = NULL,
      div(
        class = "container-fluid p-0",
        
        # Summary & Map Card
        card(
          card_header(
            div(
              class = "d-flex justify-content-between align-items-center",
              tags$span(class = "fw-bold", "🗺️ Museum Map"),
              uiOutput("summary_badge")
            )
          ),
          card_body(
            class = "p-0",
            leafletOutput("museum_map", height = "420px")
          )
        ),
        
        # Exhibitions Card Section
        card(
          class = "mt-3",
          card_header(
            div(
              class = "d-flex justify-content-between align-items-center",
              tags$span(class = "fw-bold", "🎨 Current & Upcoming Exhibitions"),
              uiOutput("selected_museum_title")
            )
          ),
          card_body(
            uiOutput("exhibitions_list")
          )
        )
      )
    )
  ),
  
  nav_panel(
    title = "About & Metadata",
    card(
      card_header("About this Application"),
      card_body(
        p("This dashboard provides an interactive guide to 30 major museums across California."),
        p("Features include:"),
        tags$ul(
          tags$li("Interactive Leaflet map showing museum locations across Los Angeles, SF Bay Area, San Diego, Sacramento, and the Central Coast."),
          tags$li("Dynamic filtering by Genre, Artifact Type, Age Group, Cost, Region, and Keyword."),
          tags$li("Comprehensive metadata on current exhibitions including Artist, Country of origin, Cost, and Target Audience.")
        ),
        p(class = "text-muted mt-3", "Data automatically crawled and structured from official museum portals.")
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive state for clicked museum on the map
  clicked_museum <- reactiveVal(NULL)
  
  # Reset filters observer
  observeEvent(input$reset_btn, {
    updateSelectInput(session, "region_filter", selected = "All Regions")
    updateSelectInput(session, "genre_filter", selected = "All Genres")
    updateSelectInput(session, "artifact_filter", selected = "All Types")
    updateSelectInput(session, "age_filter", selected = "All Ages")
    updateSelectInput(session, "cost_filter", selected = "All Options")
    updateTextInput(session, "search_filter", value = "")
    clicked_museum(NULL)
  })
  
  # Filtered Dataset
  filtered_exhibitions <- reactive({
    df <- full_df
    
    # Filter by Region
    if (input$region_filter != "All Regions") {
      df <- df %>% filter(Region == input$region_filter)
    }
    
    # Filter by Genre
    if (input$genre_filter != "All Genres") {
      df <- df %>% filter(Genre == input$genre_filter)
    }
    
    # Filter by Artifact Type
    if (input$artifact_filter != "All Types") {
      df <- df %>% filter(Artifact.Type == input$artifact_filter)
    }
    
    # Filter by Age Group
    if (input$age_filter != "All Ages") {
      df <- df %>% filter(Age.Group == input$age_filter)
    }
    
    # Filter by Cost
    if (input$cost_filter == "Free Admission") {
      df <- df %>% filter(grepl("Free", Cost, ignore.case = TRUE))
    } else if (input$cost_filter == "Paid Admission") {
      df <- df %>% filter(!grepl("Free", Cost, ignore.case = TRUE))
    }
    
    # Filter by Keyword / Search
    if (nchar(trimws(input$search_filter)) > 0) {
      kw <- trimws(input$search_filter)
      df <- df %>% filter(
        grepl(kw, Exhibition.Title, ignore.case = TRUE) |
        grepl(kw, Museum, ignore.case = TRUE) |
        grepl(kw, Artists, ignore.case = TRUE) |
        grepl(kw, Genre, ignore.case = TRUE) |
        grepl(kw, Artifact.Type, ignore.case = TRUE)
      )
    }
    
    # Filter by map click selection if active
    if (!is.null(clicked_museum())) {
      df <- df %>% filter(Museum == clicked_museum())
    }
    
    df
  })
  
  # Filtered Museum Locations
  filtered_museums <- reactive({
    df <- filtered_exhibitions()
    df %>%
      group_by(Museum, City, Region, Lat, Lng, Website) %>%
      summarise(Exhibition_Count = n(), .groups = "drop")
  })
  
  # Map Click Observer
  observeEvent(input$museum_map_marker_click, {
    click <- input$museum_map_marker_click
    if (!is.null(click$id)) {
      clicked_museum(click$id)
    }
  })
  
  # Summary Badge Output
  output$summary_badge <- renderUI({
    m_count <- nrow(filtered_museums())
    e_count <- nrow(filtered_exhibitions())
    tags$span(
      class = "badge bg-primary fs-6 fw-normal",
      sprintf("%d Museums | %d Exhibitions Available", m_count, e_count)
    )
  })
  
  # Selected Museum Title Output
  output$selected_museum_title <- renderUI({
    if (!is.null(clicked_museum())) {
      tags$span(
        class = "badge bg-info text-dark fs-6",
        sprintf("Filter Active: %s (Click Reset to view all)", clicked_museum())
      )
    } else {
      tags$span(class = "text-muted small", "Showing exhibitions for all matching museums")
    }
  })
  
  # Leaflet Map Output
  output$museum_map <- renderLeaflet({
    museums <- filtered_museums()
    
    map <- leaflet(museums) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -119.4179, lat = 36.7783, zoom = 6)
    
    if (nrow(museums) > 0) {
      for (i in seq_len(nrow(museums))) {
        m <- museums[i, ]
        is_selected <- !is.null(clicked_museum()) && m$Museum == clicked_museum()
        marker_color <- if (is_selected) "#D69E2E" else "#2B6CB0"
        
        popup_html <- sprintf(
          "<div style='font-family: sans-serif;'>
            <h6 style='margin:0 0 5px 0; color:#1A365D;'><b>%s</b></h6>
            <p style='margin:0 0 5px 0; font-size:12px; color:#4A5568;'>📍 %s (%s)</p>
            <p style='margin:0 0 5px 0; font-size:12px;'><b>Exhibitions:</b> %d</p>
            <a href='%s' target='_blank' style='font-size:12px; color:#2B6CB0; text-decoration:none;'>🌐 Official Website &rarr;</a>
          </div>",
          m$Museum, m$City, m$Region, m$Exhibition_Count, m$Website
        )
        
        map <- map %>% addCircleMarkers(
          lng = m$Lng,
          lat = m$Lat,
          layerId = m$Museum,
          radius = if (is_selected) 12 else 8,
          color = marker_color,
          fillColor = marker_color,
          fillOpacity = 0.8,
          weight = 2,
          popup = popup_html
        )
      }
    }
    
    map
  })
  
  # Exhibitions Cards List Output
  output$exhibitions_list <- renderUI({
    exhibs <- filtered_exhibitions()
    
    if (nrow(exhibs) == 0) {
      return(
        div(
          class = "text-center py-5 text-muted",
          h5("No exhibitions found matching your criteria."),
          p("Try adjusting your filters or search terms.")
        )
      )
    }
    
    cards <- lapply(seq_len(nrow(exhibs)), function(i) {
      row <- exhibs[i, ]
      
      div(
        class = "col-md-6 col-lg-4 mb-3",
        div(
          class = "card h-100 shadow-sm border-0 bg-light",
          div(
            class = "card-body d-flex flex-column justify-content-between p-3",
            div(
              div(
                class = "d-flex justify-content-between align-items-start mb-2",
                span(class = "badge bg-secondary me-1", row$Genre),
                span(class = "badge bg-success", row$Age.Group)
              ),
              h6(class = "card-title text-primary fw-bold mb-1", row$Exhibition.Title),
              p(class = "card-subtitle text-muted small mb-2", sprintf("🏛️ %s (%s)", row$Museum, row$City)),
              p(class = "small mb-1", tags$b("📅 Dates: "), row$Dates),
              p(class = "small mb-1", tags$b("🎨 Artists: "), row$Artists),
              p(class = "small mb-1", tags$b("🏺 Artifact Type: "), row$Artifact.Type),
              p(class = "small mb-1", tags$b("🌍 Origin / Country: "), row$Country)
            ),
            div(
              class = "mt-3 pt-2 border-top d-flex justify-content-between align-items-center",
              span(class = "fw-bold text-dark small", sprintf("💰 %s", row$Cost)),
              a(
                href = row$Website,
                target = "_blank",
                class = "btn btn-sm btn-outline-primary",
                "Visit Website ↗"
              )
            )
          )
        )
      )
    })
    
    div(class = "row", cards)
  })
}

shinyApp(ui = ui, server = server)
