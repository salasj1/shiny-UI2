library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(leaflet)
library(shinyWidgets)
library(PaquetePrueba)
library(htmltools)
library(httpuv)
library(shinyjs)
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard 2"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Tab 1", tabName = "tab1"),
      menuItem("Tab 2", tabName = "tab2")
    )
  ),
  dashboardBody(
    class = "dashboard",
    tags$head(mypackageDependencies()),
    useShinyjs(),
    tabItems(
      tabItem(tabName = "tab1",
              fluidRow(
                box(id= "plotBox", plotlyOutput("hist")),
                box(id = "myTableBox", DTOutput("table"))
              )
      ),
      tabItem(tabName = "tab2",
              fluidRow(
                box(plotOutput("histPlotAle", height = 300)),
                box(selectInput("variable", "Selecciona una variable", choices = names(mtcars))),
                box(textInput("textInputAle", "Escribe algo aquí")),
                box(sliderInput("sliderInputAle", "Desliza", min = 1, max = 100, value = 50)),
                box(id = "myTableBox",tags$button(id = "myButton", "Haz clic en mí", class = "btn action-button"))
              )
      )
    )
  )
)

server <- function(input, output) {
  options(httpuv.cors = TRUE)
  output$hist <- renderPlotly({
    plot_ly(data = iris, x = ~Sepal.Length, y = ~Petal.Length)
  })

  output$table <- renderDT({
    datatable(mtcars)
  })

  output$histPlotAle <- renderPlot({
    req(input$variable)
    hist(mtcars[[input$variable]], main = paste("Histograma de", input$variable), xlab = input$variable)
  })
  #Cambiar el color de fondo del dashboard
  runjs("applyDashboardStyle('blue');")
}

# Define la aplicación Shiny
app <- shinyApp(ui, server)

# Ejecuta la aplicación en un host y puerto específicos
runApp(app, host = "127.0.0.1", port = 8086)