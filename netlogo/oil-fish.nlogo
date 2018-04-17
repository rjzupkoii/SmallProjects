to setup
  clear-all
  create-patches
  create-agents
  reset-ticks
end

to create-agents
  set-default-shape turtles"boat"
  create-turtles 3 [ setxy random-xcor random-ycor ]
end

to create-patches
  ; Create the ocean
  resize-world 0 33 0 33
  ask patches [ set pcolor blue ]

  ; Create the oil rig
  let ndx 5
  let ndy world-height - 5
  ask patch ndx ndy [ set pcolor black ]

  ; Create the beach
  set ndx world-width - 2
  while [ndx < world-width ] [
    set ndy 0
    while [ ndy <= world-height ] [
      ask patch ndx ndy [ set pcolor yellow ]
      set ndy ndy + 1
    ]
    set ndx ndx + 1
  ]
end

to go
  if ticks >= 100 [ stop ]
  move-turtles
  tick
end

to move-turtles
  ask turtles [
    right random 360
    forward 1
    if pcolor != blue [
      back 1
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
660
461
-1
-1
13.0
1
10
1
1
1
0
1
1
1
0
33
0
33
0
0
1
ticks
30.0

BUTTON
12
12
76
45
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

BUTTON
13
59
76
92
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

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

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45
@#$#@#$#@
NetLogo 6.0.1
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
