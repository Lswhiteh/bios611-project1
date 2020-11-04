library(tidyverse)
library(plotly)
library(shiny)
library(klaR)
library(FactoMineR)
library(factoextra)
source('utils.r')
set.seed(42)

mushrooms <- get_cleaned_mushroom_data()

args <- commandArgs(trailingOnly=T)
port <- as.numeric(args[[1]])

ui <- navbarPage(
    tabPanel("All Samples",
        sidebarLayout(
            sidebarPanel("How does adjusting the number of k-means affect an MCA clustering 1?\n",
                        selectInput(inputId="all_k",
                                    label="Number of K means:",
                                    choices=c(1:10),
                                    selected=1)
            ),
            mainPanel(
                plotlyOutput("kmeans_all")
            )
        )
    ),

    tabPanel("Edible Mushroom Samples",
        sidebarLayout(
            sidebarPanel("How does adjusting the number of k-means affect an MCA clustering 2?\n",
                        selectInput(inputId="edible_k",
                                    label="Number of K means:",
                                    choices=c(1:10),
                                    selected=1)
            ),
            mainPanel(
                plotlyOutput("kmeans_edible")
            )
        )
  ),

    tabPanel("Poisonous Mushroom Samples",
        sidebarLayout(
            sidebarPanel("How does adjusting the number of k-means affect an MCA clustering 3?\n",
                        selectInput(inputId="poisonous_k",
                                    label="Number of K means:",
                                    choices=c(1:10),
                                    selected=1)
            ),
            mainPanel(
            plotlyOutput("kmeans_poisonous")
            )
        )
    )
)

server <- function(input, output) {
    

    output$kmeans_all <- renderPlotly({
        mush_mca <- MCA(mushrooms[,2:ncol(mushrooms)])
        mush_kmeans <- kmeans(mush_mca$ind$coord, input$all_k)

        fviz_cluster(mush_kmeans, 
                    mush_mca$ind$coord,
                    title=paste("All Samples Kmeans Clustered with", input$all_k, "Clusters"),
                    geom="point",
                    label=mushrooms$class)
    })

    output$kmeans_edible <- renderPlotly({
        edibles_mca <- MCA(mushrooms[class=="e",2:ncol(mushrooms)])
        edibles_kmeans <- kmeans(edibles_mca$ind$coord, input$edible_k)

        fviz_cluster(edibles_kmeans, 
                    edibles_mca$ind$coord,
                    title=paste("Edible Samples Kmeans Clustered with", input$edible_k, "Clusters"),
                    geom="point",
                    label=mushrooms$class)
    })

    output$kmeans_poisonous <- renderPlotly({
        poisonous_mca <- MCA(mushrooms[class=="p",2:ncol(mushrooms)])
        poisonous_kmeans <- kmeans(poisonous_mca$ind$coord, input$poisonous_k)

        fviz_cluster(poisonous_kmeans, 
                    poisonous_mca$ind$coord,
                    title=paste("Poisonous Samples Kmeans Clustered with", input$poisonous_k, "Clusters"),
                    geom="point",
                    label=mushrooms$class)
    })
}

print(sprintf("Starting shiny on port %d", port))
shinyApp(ui=ui, server=server, options=list(port=port, host="0.0.0.0"))