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
    un_grafico <- ggplot(mtcars, aes_string(x = input$variable)) + geom_histogram()
    un_grafico %>% aplicaEstilo(
      background_color = 'green',
      fill_color = 'lightblue',
      border_color = 'black',
      titulo = "Mi Gráfico",
      etiqueta_x = "Variable",
      etiqueta_y = "Frecuencia",
      posicion_leyenda = "bottom",
      family_title = "Times New Roman",
      size_title = 21,
      family_axis_x = "Arial",
      size_axis_x = 14,
      family_axis_y = "Comic Sans",
      size_axis_y = 14
    )
  })
  #Cambiar el color de fondo del dashboard
  runjs("applyDashboardStyle('blue');")
}

# Define la aplicación Shiny
app <- shinyApp(ui, server)

# Ejecuta la aplicación en un host y puerto específicos
runApp(app, host = "127.0.0.1", port = 8086)