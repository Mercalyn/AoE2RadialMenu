SetBatchLines, -1 ; Waiting-time script does not need to run super fast
; this script is mainly for the invisible radial menu for economic and military buildings, it considers that q is eco, and e is military

; isEconomic true means that the button pressed and released was economic radial button, false means it was military radial button
isEconomic := true

; amount to sleep between each key press in ms
sleepAmount := 40

originMouseX := 0
originMouseY := 0
destMouseX := 0
destMouseY := 0
newMouseX := 0
newMouseY := 0
angleMouse := 0

; choiceNumber has 8 sections, on the wheel 1 starts to the right, and it goes counterclockwise so that 3 is up, 5 is left, 7 is down, ending at 8 which is down right.
choiceNumber := 1

; choiceString is a one letter char string of what letter to press after the first, e.g. q-e will make a farm, and choiceString here will be "e"
choiceString := q


; loop encompasses all except for exit
loop {
	; this one is getkeystate because that detects keydown while the :: detects only keyup
	; this section hooks Q and E only on keydown
	if(GetKeyState("q", "P") || GetKeyState("e", "P")){
		
		
		; grabs mouse coords only if origins are at 0, because that means they won't continually overwrite themselves
		if(originMouseX == 0){
			MouseGetPos, originMouseX, originMouseY
			
			;setting isEconomic to true by default, then overwriting to false if key happens to have been an e
			isEconomic := true
			if(GetKeyState("e", "P")){
				isEconomic := false
			}
		}
	}
	continue
	
	; wait for key release
	q up::
	e up::
		; get new values then calc difference
		MouseGetPos, destMouseX, destMouseY
		newMouseX := destMouseX - originMouseX
		; y axis is inverted from a traditional math grid, and i worked out the math using normal math so it is inverted so that positive y is up
		newMouseY := originMouseY - destMouseY
		
		;fail check because you can't divide by 0, if 0, change to 1(1 pixel would be imperceptible)
		if(newMouseX == 0){
			newMouseX := 1
		}
		if(newMouseY == 0){
			newMouseY := 1
		}
		
		;time to get the arctangent based on x and y offset values (newMouseX newMouseY)
		angleMouse := ATan(newMouseY / newMouseX)
		
		; atan returns radians, multiply by 57.3 to get degrees
		angleMouse := angleMouse * 57.3
		
		; if newMouseX is less than 0 than the result must go through additional processing to get its "true" angle from 0 deg, this is because arctangent can only calc a slightly <180 deg arc
		if(newMouseX < 0){
			; this basically just rotates the left hemicircle to match the one on the right
			angleMouse := angleMouse + 180
		}
		
		; now we need to figure out which angle min/max values correspond to what choice number, starting at the demarcation line which is down
		; demarc line at bottom to right ends at -90, 0 deg is to the right, 90 deg is up, 180 deg is left, ending at the bottom, or, left of demarcation line which is 270 deg.
		; ----
		; 7 to right
		if((-90 < angleMouse) && (angleMouse < -67.5)){
			choiceNumber := 7
		} 
		; 7 to left
		if((247.5 < angleMouse) && (angleMouse < 270)){
			choiceNumber := 7
		}
		; 6
		if((202.5 < angleMouse) && (angleMouse < 247.5)){
			choiceNumber := 6
		}
		; 5
		if((157.5 < angleMouse) && (angleMouse < 202.5)){
			choiceNumber := 5
		}
		; 4
		if((112.5 < angleMouse) && (angleMouse < 157.5)){
			choiceNumber := 4
		}
		; 3
		if((67.5 < angleMouse) && (angleMouse < 112.5)){
			choiceNumber := 3
		}
		; 2
		if((22.5 < angleMouse) && (angleMouse < 67.5)){
			choiceNumber := 2
		}
		; 1
		if((-22.5 < angleMouse) && (angleMouse < 22.5)){
			choiceNumber := 1
		}
		; 8
		if((-67.5 < angleMouse) && (angleMouse < -22.5)){
			choiceNumber := 8
		}
		
		
		; now based on either eco or military we can actually build using the legend located at the bottom
		if(isEconomic){
			; q economic section
			; 1 - h
			if(choiceNumber == 1){
				choiceString := "h"
			}
			; 2 - z
			if(choiceNumber == 2){
				choiceString := "z"
			}
			; 3 - q
			if(choiceNumber == 3){
				choiceString := "q"
			}
			; 4 - k
			if(choiceNumber == 4){
				choiceString := "k"
			}
			; 5 - l
			if(choiceNumber == 5){
				choiceString := "l"
			}
			; 6 - j
			if(choiceNumber == 6){
				choiceString := "j"
			}
			; 7 - e
			if(choiceNumber == 7){
				choiceString := "e"
			}
			; 8 - i
			if(choiceNumber == 8){
				choiceString := "i"
			}
			
			; actually send eco information
			send, q
			sleep, %sleepAmount%
			send, %choiceString%
		}
		else{
			; e military section
			; 1 - o
			if(choiceNumber == 1){
				choiceString := "o"
			}
			; 2 - b
			if(choiceNumber == 2){
				choiceString := "b"
			}
			; 3 - u
			if(choiceNumber == 3){
				choiceString := "u"
			}
			; 4 - y
			if(choiceNumber == 4){
				choiceString := "y"
			}
			; 5 - z
			if(choiceNumber == 5){
				choiceString := "z"
			}
			; 6 - n
			if(choiceNumber == 6){
				choiceString := "n"
			}
			; 7 - p
			if(choiceNumber == 7){
				choiceString := "p"
			}
			; 8 - t
			if(choiceNumber == 8){
				choiceString := "t"
			}
			
			; actually send military information
			send, e
			sleep, %sleepAmount%
			send, %choiceString%
		}
		
		; only need to reset the origin x since its the only checked value, resetting for another key down press of either q or e
		originMouseX := 0
		
	; just so it doesn't burn itself to death by running super sayan
	sleep, %sleepAmount%
	return
}

NumpadMult::exitapp

; legend

; ECO "Q"
; 1 - H - Lumber camp
; 2 - Z - Town Center
; 3 - Q - House
; 4 - K - Mill
; 5 - L - Mining camp
; 6 - J - Market
; 7 - E - Farm
; 8 - I - Blacksmith

; MILITARY "E"
; 1 - O - Castle
; 2 - B - Stable
; 3 - U - Barracks
; 4 - Y - Archery
; 5 - Z - Gate, stone
; 6 - N - Wall, stone
; 7 - P - Dock
; 8 - T - Palisade



