# server.R for Calorie Calculator
# By: Tyler Byers
# For Coursera 'Developing Data Products' course
# Course 9 of 9 in Data Science Series
# October 2014
library(shiny); library(ggplot2)

shinyServer(
    function(input, output) {
        #output$gender <- renderPrint({input$GenderSelect})
        #output$age <- renderPrint({input$AgeSelect})
        wts <- reactiveValues(wtkg = 0, wtlb = 0)
        vals <- reactiveValues(cals = 0)
        legs <<- data.frame(Leg = 0, Leg.Time = 0, Elapsed.Time = 0,
                            HeartRate = NA, HeartRate.Avg = 0,
                            Leg.Calories = 0, 
                            Total.Calories = 0, Gender = NA,
                            Wt.kg = NA, Wt.lb = NA, Age = NA)
        leg <<- 0
        resets <<- -1 # Set to -1 so table renders correctly on first launch
        totCals <<- 0
        totTime <<- 0
        beats <<- 0
        
        output$aboutyou <-
            renderText({
                unit <- input$WtUnitSelect
                if(unit == 'lb') {
                    wts$wtlb <- as.numeric(input$WeightSelect)
                    wts$wtkg <- wts$wtlb*0.453592
                }
                else {
                    wts$wtkg <- as.numeric(input$WeightSelect)
                    wts$wtlb <- wts$wtkg/0.453592
                }
                paste0('You said you are a ', input$AgeSelect, 
                              '-year-old, ', round(wts$wtlb,1),
                              ' pound (', round(wts$wtkg,1), ' kg) ', 
                       input$GenderSelect, '.')})
        
        output$aboutexercise <- 
            renderText({
                paste0('You worked out for ', input$DurationSelect,
                       ' minutes at an average heart rate of ', 
                       input$HRSelect, ' beats per minute.')
            })
        
        output$calburned <- renderText({
                age <- as.numeric(input$AgeSelect)
                mf <- input$GenderSelect
                hr <- as.numeric(input$HRSelect)
                duration <- as.numeric(input$DurationSelect)
                wtkg <- wts$wtkg
                if(mf == 'Male') {
                    mf = 1
                }
                else { mf = 0 }
                cals <- (mf*(-55.0969 + 0.6309*hr + 0.1988*wtkg + 0.2017 * age) + 
                    (1-mf)*(-20.4022+0.4472*hr - 0.1263*wtkg + 0.074 * age)) *
                    duration/4.184
                cals <- round(cals, 1)
                vals$cals <- cals
                paste0('Using the above information, I calculate that ',
                        'you burned ', cals, ' calories. Click Add Leg ',
                       'if you wish to add this to your workout.')
            })
        
        output$legsdisplay <- renderTable({
            input$addLeg
            leg <<- leg + 1
            isolate(totTime <<- totTime + input$DurationSelect)
            isolate(totCals <<- totCals + vals$cals)
            isolate(beats <<- beats + input$HRSelect * input$DurationSelect)
            avghr <- beats/totTime
            isolate(newrow <- data.frame(Leg = leg, 
                                         Leg.Time = input$DurationSelect,
                                         Elapsed.Time = totTime,
                                         HeartRate = input$HRSelect,
                                         HeartRate.Avg = avghr,
                                         Leg.Calories = vals$cals, 
                                         Total.Calories = totCals,
                                         Gender = input$GenderSelect,
                                         Wt.kg = round(wts$wtkg,1),
                                         Wt.lb = round(wts$wtlb,1),
                                         Age = input$AgeSelect))
            isolate(legs <<- rbind(legs, newrow))
            if (input$resetLegs > resets) {
                leg <<- 0
                legs <<- legs[1,]
                resets <<- resets + 1
                totCals <<- 0
                totTime <<- 0
                beats <<- 0
            }
            if (nrow(legs) == 1) {
                legs
            }
            else {
                legs[2:nrow(legs),]   
            }
        }, digits = 0)
        
        output$plots <- renderPlot({
            input$addLeg
            input$resetLegs
            
            if (nrow(legs) == 1) {
                p1 <- ggplot(aes(x = Elapsed.Time, y = Total.Calories), 
                             data = legs) + geom_point(size = 4)
            }
            else {
                p1 <- ggplot(aes(x = Elapsed.Time, y = Total.Calories), 
                             data = legs) + 
                    geom_line(size = 2, color = 'navy') + geom_point(size = 4)
            }
            
            p1 <- p1 + xlab('Elapsed Time (min)') + 
                ylab('Total Calories Burned') +
                ggtitle('Calories Burned During Workout') +
                theme(plot.title=element_text(family="Times", 
                                              face="bold", size=20),
                      axis.title=element_text(family = 'Times', face = 'bold',
                                          size = 16))
            print(p1)
#             p2 <- ggplot(aes(x = Elapsed.Time, y = HeartRate.Avg), data = legs) + 
#                 geom_line()
#             grid.arrange(p1, p2, ncol = 2)
        })
    }
)

# Formula used to calculate: 
# EE = (gender x (-55.0969 + 0.6309 x heart rate + 0.1988 x weight + 0.2017 x age)
# + (1 - gender) x (-20.4022 + 0.4472 x heartrate - 0.1263 x weight + 0.074 x age))
#  * duration in minutes/4.184
#  wt in kilograms, where gender = 1 for males and 0 for females.
# Source: Publication: Journal of Sports Sciences,
# http://www.braydenwm.com/cal_vs_hr_ref_paper.pdf, pg 11
