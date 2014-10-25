# ui.R for Calorie Calculator
# By: Tyler Byers
# For Coursera 'Developing Data Products' course
# Course 9 of 9 in Data Science Series
# October 2014

library(shiny)


shinyUI(fluidPage(    
    titlePanel('Calories Burned Calculator'),
    sidebarLayout(
        sidebarPanel(
            h3('Enter Workout Information'),
            radioButtons(inputId = 'GenderSelect', label = h5('Gender:'),
                         choices = list('Male' = 'Male', 'Female' = 'Female'),
                         inline = TRUE),
            numericInput(inputId = 'AgeSelect', label = h5('Age (Years):'),
                        min = 5, max = 120, value = 40, step = 1),
            fluidRow(
                column(4, numericInput(inputId = 'WeightSelect', 
                                    label = h5('Weight:'),value = 150,
                                    min = 25, max = 600, step = 1)),
                column(4, selectInput(inputId = 'WtUnitSelect', 
                                      label = h5('lb/kg'),
                                 choices = list('lb' = 'lb', 'kg' = 'kg')))
                     ),
            numericInput(inputId = 'DurationSelect',
                         label = h5('Duration (min):'), value = 30,
                                    min = 0, max = 1440, step = 1),
            sliderInput(inputId = 'HRSelect', label = h5('Avg. Heart Rate'),
                        value = 120, min = 50, max = 250, step = 1),
            actionButton(inputId = 'addLeg', label = 'Add Leg'),
            actionButton(inputId = 'resetLegs', label = 'Reset Workout'),
            br(),
            br(),
            h3('How To Use this Site'),
            helpText('This calculator helps you to estimate the number',
                     'of calories you burn during the course of',
                     'a workout.'),
            helpText('In the \'Enter Workout Information\' panel,',
                     'enter your gender, your age, and',
                     'your weight (in lbs or kg -- select the proper units',
                     'from the drop-down box).'),
            helpText('Then enter the duration of your workout and your average ',
                     'heart rate in beats/minute.  The calculator automatically',
                     'outputs your estimated calories burned in the third line',
                     'in the \'Calculated Results\' panel.  If you only want a ',
                     'quick estimate of calories burned, then you are done.'),
            helpText('If, however, your workout was more complex, and you ',
                     'would like to see a plot and table of your calories ',
                     'burned over time, then you can use the \'Add Leg\'',
                     'feature.  For instance, take the example of a runner who',
                     'warms up for 10 minutes at 120 beats per minute (bpm),',
                     'then runs for 20 minutes at 140 bpm, 5 minutes at 160 bpm,',
                     'and then 15 minutes at 110 bpm.  This runner ran 4 legs',
                     'for her workout.  For each leg, she would enter the stats',
                     'individually, click the \'Add Leg\' button, and watch',
                     'the table and chart of her calories burned build up. If ',
                     'you would like to try this for yourself, enter 30-yr-old,',
                     '130 lb Female with the above stats.  You should see ',
                     'that the table and chart show an elapsed workout time ',
                     'of 50 minutes with a total of 383 calories burned.'),
            helpText('Of note, most of the column names in the table are',
                     'self-explanatory. A couple potentially confusing ones',
                     'are \'Leg.Time\' and \'Leg.Calories\'.  These are simply',
                     'the amount of time elapsed and calories burned during',
                     'that leg of the workout.'),
            helpText('If you make a mistake and/or would just like to start',
                     'over, hit the \'Reset Workout\' button.')
            
            ),
        
        mainPanel(
            h3('Calculated Results'),
            #p('You Are A:'),
            #verbatimTextOutput('gender'),
            #p('Your Age Is:'),
            #verbatimTextOutput('age'),
            strong(textOutput('aboutyou')),
            br(),
            strong(textOutput('aboutexercise')),
            br(),
            strong(textOutput('calburned')),
            br(),
            br(),
            plotOutput('plots', width = 800, height = 250),
            br(),
            tableOutput('legsdisplay')
            )
        )
    
))