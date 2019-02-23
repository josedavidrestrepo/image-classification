library(shiny)
library(keras)

server <- function(input, output) {
  
  # Cargar Modelo Guardado
  model <- load_model_hdf5("./model.hdf5")
  model %>% compile(
    loss = "binary_crossentropy",
    optimizer = optimizer_rmsprop(lr = 2e-5),
    metrics = c("accuracy")
  )
  
  
  observeEvent(input$file,{
    
    # Obtener y preparar imagen
    test_img <- image_load(input$file$datapath, target_size = c(32, 32))
    x = image_to_array(test_img)
    x <- array_reshape(x, c(1, dim(x)))
    x <- imagenet_preprocess_input(x)
    
    # Calcular prediccion de la imagen x
    preds <- model %>% predict_classes(x)
    print(preds)
    
    #Mostrar el resultado basándose en la condición
    output$result <-
      
      if (preds < 0.5) {
        renderText("Tiene gafas")
      }
      else {
        renderText("No tiene gafas")
      }
  })
  
  output$contents <- renderTable({
    
    req(input$file)
    
    #Ruta donde se encuentra el archivo cargado para hacerle la predicción
    print(input$file$datapath)
    
    input$file
    
  })
}