;;Created by Deryc T. Painter

;; This model is based off a lecture by Mirta Galesic.
;; The lecture is part of an Applied Complexity Short Course
;; offered from the Santa Fe Institute.
;; You can find the lecture on YouTube at
;; https://www.youtube.com/watch?time_continue=8&v=rj0wIoO9nOw

globals[mainlist]

breed [people person]
people-own [target speed grp2 solve small safe local slow connected ]

breed [solutions solution]
solutions-own [simple progress grp]

to setup
  clear-all
  set mainlist []
  set-default-shape solutions "star"
  set-default-shape people "person"

  ;; CREATE-ORDERED-<BREEDS> distributes the solutions evenly
  create-ordered-solutions number-of-solutions[
    fd max-pxcor
    set simple one-of [true false]
  ]

  create-people number-of-people [
    setxy random-xcor random-ycor
    set target one-of solutions
    face target
    set small one-of [true false]
    set safe one-of [true false]
    set local one-of [true false]
    set slow one-of [true false]
    set connected one-of [true false]
    set speed 0
    set grp2 0
  ]

  ask solutions
  [ifelse simple
    [set color green]
    [set color red]
  ]

  compare

  reset-ticks
end

to pair

end

;; The integer value for each possibility was determined with the follow rules
;; simple problems +1
;; small networks  +1
;; fast decision making with sparse network structure +1
;; well connected network structure with slow decision making +1
;; complex problems with slow decision making +1
;; complex problems with small group size +1
;; simple problems with fast decision making +1
;; simple problems with large group size +1
;; if the people used local wisdom to inform their decisions +1
;; if the people felt safe +1



to compare
 ask people
  [set speed 0
    ifelse small
    [ifelse connected
      [ifelse slow
        [ask target
          [ifelse simple
            [set progress progress + 3
            set grp 1] ;small, well-connected, slow decision rules, simple problems
            [set progress progress + 4
            set grp 2] ;small, well-connected, slow decision rules, complex problems
          ]
        ]
        [ask target
          [ifelse simple
            [set progress progress + 3
            set grp 3] ;small, well-connected, fast decision rules, simple problems
            [set progress progress + 3
            set grp 4] ;small, well-connected, fast decision rules, complex problems
          ]
        ]
      ]
      [ifelse slow
        [ask target
          [ifelse simple
            [set progress progress + 2
            set grp 5] ;small group, sparse network structure, slow decision rules, simple problems
            [set progress progress + 3
            set grp 6] ;small group, sparse network structure, slow decision rules, complex problems
          ]
        ]
        [ask target
          [ifelse simple
            [set progress progress + 4
            set grp 7] ;small group, sparse network structure, fast decision rules, simple problems
            [set progress progress + 3
            set grp 8] ;small group, sparse network structure, fast decision rules, complex problems
          ]
        ]
      ]
    ]
    [ifelse connected
      [ifelse slow
        [ask target
          [ifelse simple
            [set progress progress + 3
            set grp 9] ;large group, well-connected network structure, slow decision rules, simple problems
            [set progress progress + 2
            set grp 10] ;large group, well-connected network structure, slow decision rules, complex problems
          ]
        ]
        [ask target
          [ifelse simple
            [set progress progress + 3
            set grp 11] ;large group, well-connected network structure, fast decision rules, simple problems
            [set progress progress + 0
            set grp 12] ;large group, well-connected network structure, fast decision rules, complex problems
          ]
        ]
      ]
      [ifelse slow
        [ask target
          [ifelse simple
            [set progress progress + 2
            set grp 13] ;large group, sparse network structure, slow decision rules, simple problems
            [set progress progress + 1
            set grp 14] ;large group, sparse network structure, slow decision rules, complex problems
          ]
        ]
        [ask target
          [ifelse simple
            [set progress progress + 4
            set grp 15] ;large group, sparse network structure, fast decision rules, simple problems
            [set progress progress + 1
            set grp 16] ;large group, sparse network structure, fast decision rules, complex problems
          ]
        ]
      ]
    ]
    ifelse safe
      [set speed speed + 1] ;the group feels safe
      [set speed speed + 0] ;the group feels threatened
    ifelse local
      [set speed speed + 1] ;the group uses local wisdom
      [set speed speed + 0] ;the group uses global wisdom
  ]
  ask people
  [ set speed sqrt speed + sqrt [progress] of target
    set grp2 [grp] of target] ;set the progress of the people
end





to go
  ask people [
    face target
    ;; if at target, choose a new random target
    if distance target = 0
      [set mainlist lput (list grp2 safe local) mainlist
        set target one-of solutions
       compare
        ;stop
      ]
    ;; move towards target.  once the distance is less than 1,
    ;; use move-to to land exactly on the target.
    ifelse distance target < 1
      [ move-to target ]
      [ fd speed ]
  ]
  tick

end


@#$#@#$#@
GRAPHICS-WINDOW
736
10
1323
598
-1
-1
17.55
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
650
77
735
110
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
650
110
735
143
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

SLIDER
338
10
735
43
number-of-people
number-of-people
1
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
338
43
735
76
number-of-solutions
number-of-solutions
3
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
651
143
735
180
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
1

@#$#@#$#@
## WHAT IS IT?

This program takes the abstract concept of a group of people searching for answers,
and models the groups moving though a test space looking for the solution.

## HOW IT WORKS

The `people` breed has a variable called `target`, which holds the `solution` the person is moving towards.

The `people` have 6 other attributes which are randomly assigned as boolean variables.
`Small`, `safe`, `local`, `slow`, and `connected` are meant to describe group dynamics and information strategies. `Speed` represent how fast the group is moving through the diversity landscape.

The `face` command points the person towards the target.  

`fd` moves the person.  

`distance` measures the distance to the target.



When a person reaches their target, they pick a random new target.

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
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Test Run" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>csv:to-file "Users/Deryc/Desktop/SFI_Application/Short_Article/Diversity_Model/Model_Runs/Test_Run/" + behaviorspace-experiment-name + "_Run" + behaviorspace-run-number + ".csv" mainlist</final>
    <timeLimit steps="1000"/>
    <steppedValueSet variable="number-of-solutions" first="1" step="1" last="100"/>
    <steppedValueSet variable="number-of-people" first="1" step="1" last="100"/>
  </experiment>
</experiments>
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
