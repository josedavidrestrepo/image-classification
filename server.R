library(shiny)
library(keras)
library(EBImage)

#options(repos = BiocInstaller::biocinstallRepos())

server <- function(input, output) {
  
  # Cargar Modelo Guardado
  model <- load_model_hdf5("./model.hdf5")
  
  img <- reactive({
    req(input$file$datapath)
    readImage(input$file$datapath)
  })
  
  output$raster <- renderPlot({
      plot(img(), all=TRUE)
  })
  
  observeEvent(input$file,{
    
    pics <- c(input$file$datapath)
    app <- list()
    for (i in 1:length(pics)){ app[[i]] <- readImage(pics[i])}
    for (i in 1:length(app)) {app[[i]] <- resize(app[[i]], w=64,h=60)}
    for (i in 1:length(app)) {app[[i]] <- channel(app[[i]], "gray")}
    for (i in 1:length(app)){ dim(app[[i]])<-c(64,60,1) }
    
    la<-length(app)
    
    app <- combine(app)
    dim(app)<-c(64,60,la,1)
    app <- aperm(app, c(3,1, 2, 4))
    
    pred <- model %>% predict_classes(app)
    prob <- model %>% predict_proba(app)
    
    x <- cbind(prob, Predicted_class = pred)
    preds <- x[1,3]
    
    output$result <-
      
      if (preds == 1) {
        renderText("Tiene gafas de sol")
      }
      else {
        renderText("No tiene gafas de sol")
      }
  })
}