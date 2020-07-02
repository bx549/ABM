; a model for contagion in 1 or 2 dimensions
; this model corresponds to the following article:
; Stephen Morris, Contagion, Review of Economic Studies, Vol 67, 2000

breed [nodes node]

nodes-own [
  action        ; action (either 0 or 1)
  orig-action   ; each person's initially assigned action
  action-1-sum  ; number of neigbors that will take action 1 (or based on beliefs)
]

to setup
  clear-all
  set-default-shape nodes "circle"
  ask patches [ set pcolor gray ]
  ifelse dimension = 1 [
    make-nodes-1
  ] [
    make-nodes-2
  ]
  distribute-actions
  create-network
  reset-ticks
  ;action-dbg
end


to make-nodes-1 ; create the nodes for a 1-dimensional lattice
  foreach (range -40 41 5) [ i ->
    create-nodes 1 [
      set xcor i
      set ycor 0
      set size 2
      set action 0
      set color black
    ]
  ]
end

to make-nodes-2 ; create the nodes for a 2-dimensional lattice
  foreach (range -40 41 5) [ i ->
    foreach (range -40 41 5) [ j ->
      create-nodes 1 [
        set xcor i
        set ycor j
        set size 2
        set action 0
        set color black
      ]
    ]
  ]
end

to distribute-actions ; initialize nodes to start with action 0
  ask nodes [
    set action 0
    set orig-action action
    update-color
  ]
end

to create-network ; create links to neighbors
  ask turtles [
    let nbrs other turtles in-radius 5
    ; other omits the turtle itself
    create-links-with nbrs [ set color white ]
    ; only one undirected link between any two turtles is created
  ]
end

to update-color
  ; nodes that take action 0 are black, action 1 are white
  set color ifelse-value action = 0 [black] [white]
end

to go
  ; in the ask commands below the order of node exection is random, hence the separate steps
  ask nodes [ check-neighbors ] ; first all nodes note the actions of their neighbors (or form beliefs)
  ask nodes [ take-action ]     ; then all nodes take the action with the highest expected payoff
  ask nodes [ update-color ]
  tick
  ;action-dbg
end

to check-neighbors
  set action-1-sum sum [action] of link-neighbors
end

to take-action
  ; an agent will take the action that maxmizes the sum of her payoffs
  ; from the interactions with each of her neighbors.
  ; action 1 is a best response to the actions of her neighbors if
  ; at least proportion q of her neighbors choose action 1.
  let num-neighbors count link-neighbors
  set action ifelse-value (action-1-sum / num-neighbors >= q) [1] [0]
end

to action-dbg  ; debugging, show actions of all nodes
  foreach sort-by[ [a b] -> [xcor] of a < [xcor] of b ] nodes [ i ->
    ask i [
      let num-neighbors count link-neighbors
      show (action-1-sum / num-neighbors)
    ]
  ]
end

to select-nodes ; use the mouse to select which nodes take action 1
  if mouse-down? [
    ask turtles with [distancexy mouse-xcor mouse-ycor < 2] [
      set action 1
      update-color
      display ; update the display
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
375
10
747
383
-1
-1
4.0
1
10
1
1
1
0
0
0
1
-45
45
-45
45
1
1
1
ticks
30.0

PLOT
5
255
365
375
Mean action value in the network
time
action
0.0
100.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [action] of nodes"

BUTTON
215
15
310
48
setup
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
215
55
355
89
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
215
95
355
129
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
10
10
182
43
q
q
0
1
0.5
0.1
1
NIL
HORIZONTAL

BUTTON
10
105
142
138
select nodes
select-nodes
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
10
50
148
95
dimension
dimension
1 2
1

@#$#@#$#@
## WHAT IS IT?

This model is an implementation of best-response decision-making when players are arranged on either a line or a grid. Each agent can choose one of two possible actions:
action 0 or action 1. Each agent will attempt to maximize her own payoff by to coordinating her action with that of her neighbors. The purpose of the model is to understand the conditions under which all agents end up taking action 1 (contagion).

## HOW IT WORKS

Agents play a coordination game with their neighbors. When two neighbors each take action 0, the payoff to each is q. When two neighbors take action 1, the payoff to each is 1-q. The payoff for miscoordination is zero. Before taking an action, agents check to see how many of neighbors are taking action 1. Each agent then chooses the action (either 0 or 1) that will maximize her own total payoff. Initially all agents are set to take action 0. The user can select which agents will (at least initially) take action 1. 

Contagion (when all agents end up taking action 1) only occurs under certain conditions. For example, for agents arranged along a line (1-dimension), contagion can only occur when q <= 1/2. In 1-dimension the threshold of 1/2 is called the contagion threshold, the largest value of q for which contagion is possible. Contagion is also possible only when certain agent sets are intitially taking action 1. In 1 dimension, contagion will occur when two neighboring agents initially take action 1 (and q <= 1/2).

The color of an agent indicates which action is currently beging taken. Black indicates action 0 and white indicates action 1.

## HOW TO USE IT

The q slider sets the payoff when agents coordinate on action 0. The DIMENSION chooser set the grid to be either 1 or 2 dimensions. 

The SELECT NODES button allows the user to select agents with the mouse. The selected agents will take action 1 (at least initially).

SETUP resets all agents to take action 0.

When GO ONCE is pressed, agents play the coordination game one time. Pressing GO causes the agents to play the game repeatedly (at each tick).

## THINGS TO NOTICE


## THINGS TO TRY



## EXTENDING THE MODEL


## NETLOGO FEATURES

Networks are represented using turtles (nodes) and links. The user is able to use the mouse to select the agents that initially take action 1.

## RELATED MODELS

Language Change

## CREDITS AND REFERENCES

This model is an implemetation of the example described in Morris (2000), "Contagion", Review of Economic Studies: Vol 67, pp 57-78.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* England, D. and Page, A. (2020).  NetLogo Contagion in 1 Dimension.
https://github.com/bx549/ABM

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2020 Darin England

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
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

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
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
1
@#$#@#$#@
