library(shiny)

server <- function(input, output) {
  
  pred <- 0.5
  output$contents <- renderTable({
    
    req(input$file)
    
    #Ruta donde se encuentra el archivo cargado para hacerle la predicción
    input$file$datapath
    
    input$file
    
  })
  
  #Mostrar el resultado basándose en la condición
  output$result <-
    if (pred > 0.5) {
      renderText("Tiene gafas")
    }
    else {
      renderText("No tiene gafas")
    }
}