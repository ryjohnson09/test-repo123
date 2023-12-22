library(shiny)
library(bslib)
library(ggplot2)
library(palmerpenguins)
library(thematic)

# This edit was made by publisher2
# publisher1


# Setup -------------------------------------------------------------------

data(penguins, package = "palmerpenguins")

# Turn on thematic for theme-matched plots
thematic::thematic_shiny(font = "auto")
theme_set(theme_bw(base_size = 16))

# Calculate column means for the value boxes
means <- colMeans(
  penguins[c("bill_length_mm", "bill_length_mm", "body_mass_g")],
  na.rm = TRUE
)


# UI ----------------------------------------------------------------------

ui <- page_sidebar(
  title = "Palmer Penguins dashboard",
  sidebar = sidebar(
    varSelectInput(
      "color_by", "Color by", 
      penguins[c("species", "island", "sex")], 
      selected = "species"
    )
  ),
  layout_columns(
    fill = FALSE,
    value_box(
      title = "Average bill length",
      value = scales::unit_format(unit = "mm")(means[[1]]),
      showcase = bsicons::bs_icon("align-bottom")
    ),
    value_box(
      title = "Average bill depth",
      value = scales::unit_format(unit = "mm")(means[[2]]),
      showcase = bsicons::bs_icon("align-center"),
      theme = "dark"
    ),
    value_box(
      title = "Average body mass",
      value = scales::unit_format(unit = "g", big.mark = ",")(means[[3]]),
      showcase = bsicons::bs_icon("handbag"),
      theme = "secondary"
    )
  ),
  layout_columns(
    card(
      full_screen = TRUE,
      card_header("Bill Length"),
      plotOutput("bill_length")
    ),
    card(
      full_screen = TRUE,
      card_header("Bill depth"),
      plotOutput("bill_depth")
    )
  ),
  card(
    full_screen = TRUE,
    card_header("Body Mass"),
    plotOutput("body_mass")
  )
)


# Server ------------------------------------------------------------------

server <- function(input, output) {
  gg_plot <- reactive({
    ggplot(penguins) + 
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme_bw(base_size = 16) +
      theme(axis.title = element_blank())
  }) 
  
  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}


# Shiny App ---------------------------------------------------------------

shinyApp(ui, server)