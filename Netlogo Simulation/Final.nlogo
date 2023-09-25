extensions [csv]

globals [
  selected-car
  current-lane
  lanes
  header-skipped?
  csv_file
  data
  timestamp
  gps_speed
  no_of_veh_det
  overspeeding
  acc_Z
  file-is-open
  simulation-on
  at_estimates_nor
  at_estimates_acc
  at_estimates_brk
  at_estimates_chosen
  selected-car-id
  no_of_veh_det_prev
  stop-flag
  spawned_due_to_no_of_veh_det
]

turtles-own [
  id
  speed
  top-speed
]

to setup
  clear-all
  set-default-shape turtles "car"
  set selected-car-id user-input-id ; user-input-id is obtained from a chooser
  set file-is-open false
  set simulation-on false
  draw-road
  create-cars
  set stop-flag false
  set current-lane one-of lanes
  ;initialize-plots
  set no_of_veh_det 0
  set no_of_veh_det_prev 0
  reset-ticks
end

to draw-road
  ask patches [
    ; the road is surrounded by green grass of varying shades
    set pcolor green - random-float 0.5
  ]

  ; Drawing street lamps along the sides of the road
  let lamp-interval 5
  ask patches with [pxcor mod lamp-interval = 0 and abs pycor = number-of-lanes + 1] [
    set pcolor yellow
  ]

  ; Drawing Sidewalks
  ask patches with [abs pycor = number-of-lanes + 2] [
    set pcolor grey + 2
  ]

  ; Drawing Road
  set lanes n-values number-of-lanes [ n -> number-of-lanes - (n * 2) - 1 ]
  ask patches with [ abs pycor <= number-of-lanes ] [
    set pcolor grey - 2.5 + random-float 0.25
  ]

  ;ask patches [
    ; the road is surrounded by green grass of varying shades
    ;set pcolor green - random-float 0.5
  ;]
  ;set lanes n-values number-of-lanes [ n -> number-of-lanes - (n * 2) - 1 ]
  ;ask patches with [ abs pycor <= number-of-lanes ] [
    ; the road itself is varying shades of grey
    ;set pcolor grey - 2.5 + random-float 0.25
  ;]
  draw-road-lines
end

to-report number-of-lanes
  ; To make the number of lanes easily adjustable, remove this
  ; reporter and create a slider on the interface with the same
  ; name. 8 lanes is the maximum that currently fit in the view.
  report 3
end

to draw-road-lines
  let y (last lanes) - 1 ; start below the "lowest" lane
  while [ y <= first lanes + 1 ] [
    if not member? y lanes [
      ; draw lines on road patches that are not part of a lane
      ifelse abs y = number-of-lanes
        [ draw-line y yellow 0 ]  ; yellow for the sides of the road
        [ draw-line y white 0.5 ] ; dashed white between lanes
    ]
    set y y + 1 ; move up one patch
  ]
end

to draw-line [ y line-color gap ]
  ; We use a temporary turtle to draw the line:
  ; - with a gap of zero, we get a continuous line;
  ; - with a gap greater than zero, we get a dasshed line.
  create-turtles 1 [
    setxy (min-pxcor - 0.5) y
    hide-turtle
    set color line-color
    set heading 90
    repeat world-width [
      pen-up
      forward gap
      pen-down
      forward (1 - gap)
    ]
    die
  ]
end

to create-cars
  create-turtles number-of-cars [
    set color blue
    print (word "number of cars " number-of-cars)
    set id who ; assign unique ID to each turtle
    ;set color ifelse-value (id = selected-car-id)
    ; Set the color for the label text to white for better visibility
    set label-color white
    if id = selected-car-id [
      set label (word "ID: " id)
    ]

   print (word "spawned_due_to_no_of_veh_det primary ;" spawned_due_to_no_of_veh_det)
  print (word "selected-car primary:" selected-car)

    ; Remove excess cars if needed
  if (count turtles > number-of-cars + no_of_veh_det) [
    let excessCars count turtles - number-of-cars - no_of_veh_det
    ask n-of excessCars turtles with [self != selected-car] [ die ]
  ]

   ; Randomly assign turtles to one of the three lanes if not selected-car or spawned due to no_of_veh_det
   ;; ask turtles with [self != selected-car and spawned_due_to_no_of_veh_det = false] [
     ; print("inside lane change")
     ; print (word "spawned_due_to_no_of_veh_det " spawned_due_to_no_of_veh_det)
     ; print (word "selected-car " selected-car)
     ; let availableLanes [-1 0 1]  ; Assuming lanes are at pycor = -1, 0, 1
     ; let randomLane one-of availableLanes  ; Pick a lane randomly
      ;move-to one-of patches with [pycor = randomLane]  ; Move to the chosen lane
    ;]


    set heading 90
    set speed user-speed / 10
  ]

  ; Select one car and mark it yellow
  set selected-car one-of turtles
  ask selected-car [ set color yellow ]
  ask turtles with [id = selected-car-id] [
    ; Move it to the 'current-lane', if you need to (optional)
    ; move-to one-of patches with [pycor = current-lane]
    set color yellow
  ]
end

to simulate
  print "Simulate button pressed"
  set csv_file (word "D:\\thesis\\Simulation\\UAH_" driver-tag-input".csv")
  set simulation-on true
  if not file-is-open [
    ifelse file-exists? csv_file [
      file-open csv_file
      set file-is-open true
      read-csv-file
      file-close
      set file-is-open false
    ] [
      print (word "File does not exist: " csv_file)
    ]
  ]
end

to read-csv-file
  print "Reading CSV file"
  let _ file-read-line

   ;Create new turtles based on the number of detected vehicles
   create-turtles no_of_veh_det [
    set color cyan
    set id who ; assign unique ID to each turtle
    set label-color white ; Set the color for the label text to white for better visibility
    move-to one-of patches with [ pycor = 0 ] ; Set initial position
    set heading 90 ; Set initial heading
    set speed (user-speed + 10) / 10 ; Set initial speed

  ; Determine the selected car's position
  ;let selected-car-ycor [ycor] of selected-car
  ;let selected-car-xcor [xcor] of selected-car

  ; Create new turtles based on no_of_veh_det
  ;create-turtles no_of_veh_det [
    ;set color cyan
    ;set id who
    ;set label-color white
    ;set heading 90
    ;set speed (gps_speed + 10) / 10

    ; Move to a patch that is slightly ahead of the selected car in the same lane
    ;let target-patch one-of patches with [pycor = selected-car-ycor and pxcor > selected-car-xcor]
    ;if target-patch != nobody [
      ;move-to target-patch
    ;]
  ]


  while [ not file-at-end? and simulation-on ] [
    let row csv:from-row file-read-line
    set-data-variables row
    follow selected-car
    update-turtle
    plot-gps-speed
    plot-at-estimates at_estimates_chosen at_estimates_nor at_estimates_acc at_estimates_brk
    ;plot-probability
    tick
  ]
end

to set-data-variables [row]
    set timestamp (item 1 row)
    set gps_speed (item 2 row)
    set no_of_veh_det (item 3 row)
    set overspeeding (item 4 row)
    set acc_Z (item 5 row)
    set at_estimates_nor (item 6 row)
    set at_estimates_acc (item 7 row)
    set at_estimates_brk (item 8 row)
    set at_estimates_chosen (item 9 row)
end

to update-turtle

  ; Maintain road occupancy within the limits
  let laneSpaces patches with [ member? pycor lanes ]
  ask selected-car [forward gps_speed / 10]

  ; Update the selected car's color based on speed
  if (overspeeding = 1) [
    ask selected-car [ set color red ]
    print("Overspeeding!")
  ]
  if (overspeeding = 0) [
    ask selected-car [ set color yellow ]
  ]

  ; Move other cars if a change in detected vehicles occurs
  if (no_of_veh_det != no_of_veh_det_prev) [
    ask turtles with [self != selected-car] [ forward 1 ]
  ]

  ; Add or remove cars based on change in detected vehicles
  if (no_of_veh_det != no_of_veh_det_prev) [
    ; If more cars detected, create them
    if (no_of_veh_det > no_of_veh_det_prev) [
      set spawned_due_to_no_of_veh_det true  ; Set attribute for newly spawned turtles
      create-turtles (no_of_veh_det - no_of_veh_det_prev) [
        move-to one-of vacant laneSpaces
        set heading 90
        forward gps_speed / 10
      ]
    ]
    ; If fewer cars detected, remove the extra
    if (no_of_veh_det < no_of_veh_det_prev) [
      let toBeRemoved abs(no_of_veh_det_prev - no_of_veh_det)
      ask n-of toBeRemoved turtles with [self != selected-car] [ die ]
      ask turtles with [self != selected-car] [ forward (gps_speed + 10) / 10 ]
    ]
    set no_of_veh_det_prev no_of_veh_det
  ]

end

to-report vacant [ laneSpaces ]  ; turtle procedure
  let presentCar self
  report laneSpaces with [
    not any? turtles-here with [ self != presentCar ]
  ]
end

to simulate-once
  print "Simulate Once button pressed"
  set csv_file (word "D:\\thesis\\Simulation\\UAH_" driver-tag-input ".csv") ; Added a space before the concatenation
  set simulation-on true
  print (word "Debug: csv_file = " csv_file) ; Debugging statement

  if not file-is-open [
    ifelse file-exists? csv_file [
      file-open csv_file
      set file-is-open true
      set header-skipped? false ; Reset the header-skipped flag
    ] [
      print (word "File does not exist: " csv_file)
      stop
    ]
  ]

  if not header-skipped? [ ; Skip header if it hasn't been skipped yet
    let _ file-read-line
    set header-skipped? true
  ]

  if file-at-end? [
    print "Reached the end of the CSV file."
    file-close
    set file-is-open false
    stop
  ]

  let line file-read-line ; read the line from file
  let row csv:from-row line ; parse CSV line into a list

  set-data-variables row
  update-turtle
  plot-gps-speed
  plot-at-estimates at_estimates_chosen at_estimates_nor at_estimates_acc at_estimates_brk

  tick
end

to-report freelane [ road-patches ] ; turtle procedure
  let this-car self
  report road-patches with [
    not any? turtles-here with [ self != this-car ]
  ]
end

to stop-simulation
  set stop-flag true
end

to plot-gps-speed
  set-current-plot "GPS Speed vs Time"
  set-current-plot-pen "GPS Speed"
  ;set-plot-pen-mode 1  ; 0 for line plot
  plot gps_speed
end

to plot-at-estimates [chosen nor acc brk]
  set-current-plot "Chosen Action"
  set-current-plot-pen "Chosen"
  ;; Decide the color based on the state
  ifelse chosen = nor [
    set-plot-pen-color blue  ; Normal
  ][
    ifelse chosen = acc [
      set-plot-pen-color green  ; Accelerating
    ][
      set-plot-pen-color red  ; Braking
    ]
  ]

  ;; Plot the point
  plot chosen
end
@#$#@#$#@
GRAPHICS-WINDOW
592
10
1229
648
-1
-1
19.061
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
71
335
563
382
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
71
126
560
159
number-of-cars
number-of-cars
1
4
1.0
1
1
NIL
HORIZONTAL

SLIDER
71
278
561
311
user-speed
user-speed
20
100
60.0
10
1
NIL
HORIZONTAL

SLIDER
72
226
563
259
user-input-id
user-input-id
1
4
2.0
1
1
NIL
HORIZONTAL

CHOOSER
72
170
561
215
driver-tag-input
driver-tag-input
"11" "12" "13" "21" "22" "23" "31" "32" "33" "41" "42" "43" "51" "52" "53" "61" "62" "63"
1

BUTTON
71
401
563
445
Simulate
simulate
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
72
466
563
513
Simulate Once
simulate-once
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
72
528
563
579
Stop
stop-simulation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1241
466
1641
511
Vehicles Detected
no_of_veh_det
17
1
11

PLOT
1240
224
1641
374
GPS Speed vs Time
Time
Gps Speed
0.0
800.0
0.0
50.0
true
false
"" ""
PENS
"GPS Speed" 1.0 2 -14070903 true "" "plot gps_speed"

MONITOR
1240
525
1643
570
Gps Speed
gps_speed
2
1
11

MONITOR
1241
403
1639
448
Speed Exceeded?
overspeeding
17
1
11

TEXTBOX
150
25
467
75
Human Driving Behavior Simulator
20
0.0
1

PLOT
1241
61
1641
211
Chosen Action
Time
at_estimates_chosen
0.0
800.0
0.0
1.0
true
true
"" ""
PENS
"Chosen" 1.0 2 -7171555 true "" ""

TEXTBOX
82
70
568
104
Understanding and Simulating Decision-Making on the Road
18
0.0
1

TEXTBOX
1243
20
1669
52
Blue - Normal, Green - Accelerating, Red - Braking 
18
0.0
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car side
false
0
Polygon -7500403 true true 19 147 11 125 16 105 63 105 99 79 155 79 180 105 243 111 266 129 253 149
Circle -16777216 true false 43 123 42
Circle -16777216 true false 194 124 42
Polygon -16777216 true false 101 87 73 108 171 108 151 87
Line -8630108 false 121 82 120 108
Polygon -1 true false 242 121 248 128 266 129 247 115
Rectangle -16777216 true false 12 131 28 143

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cloud
false
0
Circle -7500403 true true 13 118 94
Circle -7500403 true true 86 101 127
Circle -7500403 true true 51 51 108
Circle -7500403 true true 118 43 95
Circle -7500403 true true 158 68 134

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
