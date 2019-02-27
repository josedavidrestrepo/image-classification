library(shiny)
library(keras)
library(EBImage)

#options(repos = BiocInstaller::biocinstallRepos())

# Cargar Modelo Guardado
model <- load_model_hdf5("./model.hdf5")

predict <- function(path) {
  pics <- c(path)
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
  
  if (preds == 1) {
    result <- "¿Tiene gafas de sol? SI"
  }
  else {
    result <- "¿Tiene gafas de sol? NO"
  }
  
  return (result)
}

server <- function(input, output) {
  
  active <- reactiveValues(
    control = 'select'
  )
  
  observeEvent(input$select, {
    active$control <- 'select'
  })
  
  observeEvent(input$file, {
    active$control <- 'file'
  })
  
  path <- reactive({
    if (active$control == 'select')
      paste("faces/", input$select, sep="")
    else
      input$file$datapath
  })
  
  output$raster <- renderPlot({
      req(path())
      img <- readImage(path())
    
      plot(img, all=TRUE)
  })
  
  output$result <- renderText({
    predict(path())
  })
}