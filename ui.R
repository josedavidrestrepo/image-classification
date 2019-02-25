library(shiny)
library(shinydashboard)
library("EBImage")

ui <- dashboardPage(
  dashboardHeader(title = "Image Classification"),
  skin = "purple",
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predicciones", tabName = "predicts", icon = icon("calendar", lib = "glyphicon")),
      menuItem("Reporte técnico", tabName = "report", icon = icon("briefcase", lib = "glyphicon")),
      menuItem("Código fuente", icon = icon("file-code-o"), href = "https://github.com/josedavidrestrepo/image-classification"),
      menuItem("Acerca de", tabName = "about", icon = icon("info-sign", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "predicts",
              fluidRow(
                  box(status = "warning", width = 5,
                      fileInput("file", "Seleccione una imagen",
                                multiple = FALSE,
                                accept = c("image/*,.pgm"
                                           
                                           ))
                  ),
                  box(width = 12,
                      tableOutput("contents")
                  ),
                  box(width = 4,
                      plotOutput("raster")
                  ),
                  box(width = 4,
                      displayOutput("widget")
                  ),
                  box(width = 4,
                      h1(textOutput("result"))
                  )
            )
      ),
      tabItem(tabName = "report",
               includeHTML("reporte.html")
      ),
      tabItem(tabName = "about",
              tags$div(
                tags$h1("Esta aplicación ha sido desarrollada por:"), 
                tags$br(),
                tags$ul(
                  tags$li("Angie Valeria Lopez Echeverry - anvlopezec@unal.edu.co"),
                  tags$li("Wendy Karen Rivera Tamayo - wkriverat@unal.edu.co"),
                  tags$li("Jose David Restrepo Duque - jodrestrepodu@unal.edu.co"),
                  tags$li("Helber Santiago Padilla Rocha - hspadillar@unal.edu.co"),
                  tags$li("Jose Alejandro Aristizabal Hoyos - jaaristizabalh@unal.edu.co"),
                  tags$li("Santiago Alvarez Soto - saalvarezso@unal.edu.co")
                ),
                tags$br(),
                tags$h4("No dudes en contactarnos si tienes alguna duda que podamos resolverte, o para que nos compartas tus necesidades y hacerte una solución a tu medida.")
                
              )
      )
    )
  )
)