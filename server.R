library(shiny)
library(keras)
library("EBImage")

server <- function(input, output) {
  
  # Cargar Modelo Guardado
  model <- load_model_hdf5("./model.hdf5")
  # model %>% compile(
  #   loss = "binary_crossentropy",
  #   optimizer = optimizer_rmsprop(lr = 2e-5),
  #   metrics = c("accuracy")
  # )
  
  img <- reactive({
    readImage(input$file$datapath)
  })
  
  output$widget <- renderDisplay({
    display(img())
  })
  
  output$raster <- renderPlot({
    plot(img(), all=TRUE)
  })
  
  observeEvent(input$file,{
    
    pics <- c(input$file$datapath)
    app <- list()
    for (i in 1:length(pics)){ app[[i]] <- readImage(pics[i])}
    for (i in 1:length(app)){ dim(app[[i]])<-c(64,60,1) }
    
    la<-length(app)
    display(app[[i]], method="raster")
    
    app <- combine(app)
    dim(app)<-c(64,60,la,1)
    app <- aperm(app, c(3,1, 2, 4))
    
    pred <- model %>% predict_classes(app)
    prob <- model %>% predict_proba(app)
    
    x <- cbind(prob, Predicted_class = pred)
    preds <- x[1,3]
    print(preds)
    
    # Obtener y preparar imagen
    # test_img <- image_load(input$file$datapath, target_size = c(64,60))
    # x = image_to_array(test_img)
    # x <- array_reshape(x, c(1, dim(x)))
    # x <- imagenet_preprocess_input(x)
    # 
    # # Calcular prediccion de la imagen x
    # preds <- model %>% predict_classes(x)
    # print(preds)
    
    #Mostrar el resultado basándose en la condición
    output$result <-
      
      if (preds == 1) {
        renderText("Tiene gafas")
      }
      else {
        renderText("No tiene gafas")
      }
  })
}