library(shiny)
library(plotly)
library(dplyr)
library(tidyverse)


function(input, output, session) {
    
    output$user_manual_text <- renderUI({
            if (input$active_panel == 3){
            (HTML(paste('1. You can consider one or several functions from the following:', 
                        'y = sin(x);',
                        'y = 1/(20*x);',
                        'y = exp(x)/400.',
                        '<br/>',
                        '2. General options:',
                        '- Use checkbox to select function(s);',
                        '- Use slider to select range of selected function(s) argument x.',
                        '<br/>',
                        '3. Other options:',
                        'Use radio buttons to choose color-scheme of the graph',
                        '<br/>',
                        '4. Graph:',
                        'Use lasso select of box select option on the top of the graph to select some points.',
                        'Ones you select some points their x coordinates  will be detected then corresponded y will be shown in the table below the graph',
                        sep = '<br/>')))
            }
    })
                
    df_processing <- reactive({
            x_min <- input$x_range[1]
            x_max <- input$x_range[2]
            step = (x_max - x_min)/100
            xx <- seq(from = x_min, 
                      to = x_max, 
                      by = step)
            funcs <- input$math_function_selection
            length_funcs <- length(funcs)
            df <- data.frame(x = xx)
            if (length_funcs > 0 ){
                    for (i in 1:length_funcs){
                            if (funcs[i] == 'sin'){
                                    temp_vect <- sin(xx)
                                    df_col_name <- funcs[i]
                            }
                            if (funcs[i] == 'hyp'){
                                    temp_vect <- 1/(20*xx)
                                    df_col_name <- funcs[i]
                            }
                            if (funcs[i] == 'exp'){
                                    temp_vect <- exp(xx)/400
                                    df_col_name <- funcs[i]
                            }
                            df_temp <- data.frame(temp_name = temp_vect)
                            names(df_temp) <- df_col_name
                            df <- df %>% bind_cols(df_temp)
                    }
            }
            all_options <- c('sin', 'hyp', 'exp')
            if (sum(!(all_options %in% names(df))) > 0){
                    not_choosen_funcs <- all_options[!(all_options %in% names(df))]
                    length_not_choosen_funcs <- length(not_choosen_funcs)
                    for (i in 1:length_not_choosen_funcs){
                            df_col_name <- not_choosen_funcs[i]
                            temp_df <- data.frame(temp_name = rep(x = NA, nrow(df)))
                            names(temp_df) <- df_col_name
                            df <- df %>% bind_cols(temp_df)
                    }
            }
            df
    })
    
    output$plot <- renderPlotly({
            if (input$active_panel != 3){
            df <- df_processing()
            color_selection <- input$radio
            if (color_selection == 'mh'){
                    line_prop3 <- line_prop2 <- line_prop1 <- list(color = 'rgb(0, 0, 0)')
                    
            } else {
                    line_prop1 <- list(color = 'rgb(255, 0, 0)')
                    line_prop2 <- list(color = 'rgb(0, 128, 0)')
                    line_prop3 <- list(color = 'rgb(0, 0, 255)')
            }
            plot_ly(data = df, type = 'scatter',mode = 'markers', source = 'imgLink') %>% # key - опционально (выбирается из названий столбиков датасета, например, key = ~hyp)
                    add_trace(x = ~x, y = ~sin, line = line_prop1, marker = line_prop1, name = 'y = sin(x)', mode = 'lines+markers') %>%
                    add_trace(x = ~x, y = ~hyp, line = line_prop2, marker = line_prop2, name = 'y = 1/x', mode = 'lines+markers') %>%
                    add_trace(x = ~x, y = ~exp, line = line_prop3, marker = line_prop3, name = 'y = exp(x)', mode = 'lines+markers') %>%
                    layout(hovermode = "x") %>% 
                    layout(xaxis = list(spikecolor = 'rgb(0, 0, 0)', 
                                        spikemode = 'across',
                                        spikethickness = 1, 
                                        title = 'x'),
                           yaxis = list(title = 'y')
                    )
            } else {NULL}
    })
    
    #output$value <- renderText({
    #        input$active_panel
    #})
    
    output$table <- renderTable({
            if (input$active_panel != 3){
                    event.data <- event_data(event = "plotly_selected", source = "imgLink")
                    df <- df_processing()
                    df[df$x %in% event.data$x, ] %>% select(x, input$math_function_selection)
            } else {NULL}
    })
    
}


