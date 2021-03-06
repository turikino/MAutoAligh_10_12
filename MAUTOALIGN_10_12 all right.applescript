global osxVertion, ptVertion, gAtc, gBtc, xClick, yClick, zClick, xStartMAutoInsert, yStartMAutoInsert, xStartMAutoSuite, yStartMAutoSuite, EditWindowSize, MAutoInsertSize, MAutoSuiteSize, regionRenderName, regionNam, someNewInt

tell application "Finder"
	tell application "System Events"
		set osxVertion to system version of (system info)
		
		set PT to the first application process whose creator type is "PTul"
		tell PT
			activate
			delay 0.3
			set EditWindowSize to size of window 1
			
			set frontmost to true
			click menu item 1 of menu 1 of menu bar item 2 of menu bar 1
			set ptVertion to title of static text 1 of window 1
			
			tell window 1
				set {xPosition, yPosition} to position
				set {xSize, ySize} to size
			end tell
			-- modify offsets if hot spot is not centered:
			set xClick to (xPosition + (xSize div 2))
			set yClick to (yPosition + (ySize div 2))
			my clickMouse()
			delay 0.3
			
			if size of window 1 is not equal to EditWindowSize then
				delay 1
				repeat until (size of window 1 is equal to EditWindowSize)
					my clickMouse()
				end repeat
			end if
			
			
			if ptVertion = "Version: 10.3.10" then
				my MAutoAlignPT10()
			else
				my MAutoAlignPT12()
			end if
			
		end tell
	end tell
end tell


(*on MAutoAlignPT10()
	tell application "Finder"
		tell application "System Events"
			set PT to the first application process whose creator type is "PTul"
			
			tell PT
				activate
				delay 0.3
				
				set frontmost to true
				
				(*key code 13 using {shift down, option down, command down} -- shift+alt+cmd+W
			delay 0.3*)
				(*-- Hide all floating windows
			click menu item 3 of menu 1 of menu bar item 12 of menu bar 1*)
				
				--select number of tracks
				set temp to display dialog "Enter number of tracks and click OK" default answer ""
				set number_of_tracks to the text returned of temp
				repeat until (size of window 1 is equal to EditWindowSize)
				end repeat
				
				delay 0.3
				-- switch Main Counter to Samples
				try
					click menu item 5 of menu 1 of menu item 16 of menu 1 of menu bar item "View" of menu bar 1
				on error errTxt number errNum
					delay 1
					repeat until (size of window 1 is equal to EditWindowSize)
						my clickMouse()
					end repeat
					click menu item 5 of menu 1 of menu item 16 of menu 1 of menu bar item "View" of menu bar 1
				end try
				
				
				
				-- copy start TC of selection
				set gAtc to value of button 3 of toolbar 4 of window 1
				-- copy end TC of selection
				set gBtc to value of button 4 of toolbar 4 of window 1
				
				set frontmost to true
				
				--set SLIP mode
				click button 3 of toolbar 1 of window 1
				
				-- delete fades of regions
				click menu item "Delete" of menu 1 of menu item "Fades" of menu 1 of menu bar item "Edit" of menu bar 1
				
				delay 0.3
				
				-- check Tab to Transients
				if value of button 9 of toolbar 3 of window 1 = "Selected" then
					click button 9 of toolbar 3 of window 1
				end if
				
				-- check Insertion Follows Playback
				if value of button 13 of toolbar 3 of window 1 = "Selected" then
					click button 13 of toolbar 3 of window 1
				end if
				--check Video online
				if value of attribute "AXMenuItemMarkChar" of menu item 6 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 38 using {shift down, command down} -- shift,cmd+J
				end if
				
				
				--check pre-roll
				if value of attribute "AXMenuItemMarkChar" of menu item 8 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 40 using {command down} -- shift,cmd+J
				end if
				
				-- check Play Loop
				if value of button 7 of toolbar 1 of toolbar 6 of window 1 = "" then
					key code 37 using {shift down, command down} -- shift,cmd+L
				end if
				
				--check Solo
				click button 1 of toolbar "MAutoAlign_LAV auxiliary track" of window 1
				delay 0.3
				if value of button 1 of toolbar "MAutoAlign_LAV auxiliary track" of window 1 = "on" then
					click button 1 of toolbar "MAutoAlign_LAV auxiliary track" of window 1
				end if
				
				set frontmost to true
				
				delay 0.3
				
				-- select start of the first region
				key code 125 -- Arrow Down 
				key code 35 -- P
				key code 41 -- ; semicolon
				
				-- check of empty start
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.3
				key code 3 --  F
				delay 0.3
				key code 39 -- ' quote
				delay 0.3
				
				if value of button 3 of toolbar 4 of window 1 as number is equal to (gAtc + 1920) then
					key code 37 using {shift down} -- L
					delay 0.3
					key code 51 -- delete
				end if
				
				delay 0.3
				
				-- cycle of denoise
				repeat number_of_tracks times
					-- compare TC of cursor with end TC of selection
					set tc to value of button 1 of toolbar 4 of window 1
					
					delay 0.3
					repeat while tc < gBtc
						if tc < gBtc then
							my MAutoAlign10()
							set tc to value of button 1 of toolbar 4 of window 1
						end if
					end repeat
					
					-- shift cursor down
					repeat while value of button 1 of toolbar 4 of window 1 > gAtc
						if value of button 1 of toolbar 4 of window 1 > gAtc then
							key code 37 -- L
						end if
					end repeat
					
					key code 41 -- ; semicolon
					
					repeat while value of button 1 of toolbar 4 of window 1 < gAtc
						if value of button 1 of toolbar 4 of window 1 < gAtc then
							key code 39 -- ' quote
						end if
					end repeat
				end repeat
				
				-- switch Main Counter to TimeCode
				click menu item 3 of menu 1 of menu item 16 of menu 1 of menu bar item "View" of menu bar 1
				delay 0.3
				
				display dialog "MAutoAlign done!"
			end tell
		end tell
	end tell
end MAutoAlignPT10

on MAutoAlign10()
	tell application "Finder"
		tell application "System Events"
			set PT to the first application process whose creator type is "PTul"
			
			tell PT
				activate
				set frontmost to true
				
				if value of button 1 of toolbar 4 of window 1 < gAtc then
					key code 39 -- ' quote
				end if
				
				--solo activate
				key code 1 using {shift down} -- shift+s
				
				delay 0.3
				
				-- check of empty start
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.3
				key code 3 --  F
				delay 0.3
				key code 39 -- ' quote
				delay 0.3
				if value of button 3 of toolbar 4 of window 1 as number is equal to (gAtc + 1920) then
					key code 37 using {shift down} -- L
					delay 0.3
					key code 51 -- delete
				end if
				
				-- select region for MAutoPhase
				key code 39 using {shift down} -- ' quote
				
				(*--click Rename
				click menu item 17 of menu 1 of menu bar item 7 of menu bar 1
				try
					set regionName to value of text field 1 of window 1
				on error
					click menu item 17 of menu 1 of menu bar item 7 of menu bar 1
					set regionName to value of text field 1 of window 1
				end try
				click button 1 of window 1*)
				
				-- launch Plug-in: MAutoAlign
				click button 8 of toolbar "Inserts" of toolbar "MAutoAlign_LAV auxiliary track" of window 1
				
				tell button 1 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xStartMAutoInsert to (xPosition + (xSize div 2))
				set yStartMAutoInsert to (yPosition + (ySize div 2))
				
				delay 0.3
				
				--select factory default 
				set xClick to xStartMAutoInsert + 188
				set yClick to yStartMAutoInsert + 35
				set zClick to 1
				my clickMouseDropMenu()
				delay 0.3
				
				delay 0.3
				set xClick to xStartMAutoInsert + 188
				set yClick to yStartMAutoInsert + 35
				set zClick to 1
				my clickMouseDropMenu()
				(*set xClick to xStartMAutoInsert + 188
				set yClick to yStartMAutoInsert + 35
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoInsert + 193
				set yClick to yStartMAutoInsert + 35
				my clickMouse()*)
				
				
				(*key code 79 -- enter 
				*)
				
				delay 0.3
				set MAutoInsertSize to size of window 1
				delay 0.3
				--check pre-roll
				if value of attribute "AXMenuItemMarkChar" of menu item 8 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 40 using {command down} -- shift,cmd+J
				end if
				
				-- launch play loop
				(*key code 49*)
				click button 7 of toolbar 1 of toolbar 6 of window 2
				
				if size of window 1 is not equal to MAutoInsertSize then
					click button "OK" of window 1
					delay 1
					click button 7 of toolbar 1 of toolbar 6 of window 2
					delay 1
				end if
				
				delay 1
				
				-- click ANALYZE
				set xClick to xStartMAutoInsert + 80
				set yClick to yStartMAutoInsert + 228
				my clickMouse()
				
				delay 0.3
				
				if size of window 1 is not equal to MAutoInsertSize then
					repeat until (size of window 1 is equal to MAutoInsertSize)
					end repeat
				else
					set xClick to xStartMAutoInsert + 101
					set yClick to yStartMAutoInsert + 328
					my clickMouse()
					repeat until (size of window 1 is equal to MAutoInsertSize)
					end repeat
				end if
				
				delay 0.3
				
				-- stop play PT
				(*key code 49*)
				click button 6 of toolbar 1 of toolbar 6 of window 2
				delay 0.3
				
				-- copy plug-in settings (shift+cmd+C)
				(*key code 8 using {shift down, command down}*)
				
				(*set xClick to xStartMAutoInsert + 236
				set yClick to yStartMAutoInsert + 18
				set zClick to 36
				my clickMouseDropMenu()*)
				delay 3
				
				-- click copy button in MAutoAlign
				set xClick to xStartMAutoInsert + 624
				set yClick to yStartMAutoInsert + 535
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoInsert + 622
				set yClick to yStartMAutoInsert + 535
				my clickMouse()
				
				delay 0.3
				-- close Insert MAutoAlign
				(*click button 8 of toolbar "Inserts" of toolbar "MAutoAlign_LAV auxiliary track" of window 2*)
				
				set xClick to xStartMAutoInsert
				set yClick to yStartMAutoInsert
				my clickMouse()
				(*-- copy start TC of selection
				set xtc to value of button 3 of toolbar 4 of window 1*)
				delay 0.8
				
				-- copy end TC of selection
				(*set ytc to value of button 4 of toolbar 4 of window 1*)
				try
					set ytc to value of button 4 of toolbar 4 of window 1
				on error
					try
						repeat until (size of window 1 is equal to EditWindowSize)
							set xClick to xStartMAutoInsert
							set yClick to yStartMAutoInsert
							my clickMouse()
						end repeat
						set ytc to value of button 4 of toolbar 4 of window 1
					on error errTxt number errNum
						display dialog errTxt & return & errNum
					end try
				end try
				
				delay 0.8
				
				-- launch AudioSuite: MAutoAlign
				click menu item "MAutoAlign" of menu 1 of menu item "Other" of menu 1 of menu bar item "AudioSuite" of menu bar 1
				
				tell button 1 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xStartMAutoSuite to (xPosition + (xSize div 2))
				set yStartMAutoSuite to (yPosition + (ySize div 2))
				
				delay 0.8
				
				-- paste plug-in settings (shift+cmd+V)
				set xClick to xStartMAutoSuite + 648
				set yClick to yStartMAutoSuite + 535
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoSuite + 650
				set yClick to yStartMAutoSuite + 535
				my clickMouse()
				
				(*key code 9 using {shift down, command down}*)
				(*set xClick to xStartMAutoSuite + 405
				set yClick to yStartMAutoSuite + 18
				set zClick to 51
				my clickMouseDropMenu()*)
				(*set xClick to xStartMAutoSuite + 405
				set yClick to yStartMAutoSuite + 18
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoSuite + 408
				set yClick to yStartMAutoSuite + 69
				my clickMouse()*)
				
				delay 0.8
				
				if value of button 7 of window 1 = "create continuous file" then
					set xClick to xStartMAutoSuite + 113
					set yClick to yStartMAutoSuite + 53
					set zClick to -12
					my clickMouseDropMenu()
				end if
				
				-- change entire selection to clip-by-clip
				set xClick to xStartMAutoSuite + 284
				set yClick to yStartMAutoSuite + 53
				set zClick to -12
				my clickMouseDropMenu()
				
				-- check clip by clip
				if title of button 9 of window 1 is not equal to "whole file" then
					repeat until (title of button 9 of window 1 = "whole file")
						delay 1
						set xClick to xStartMAutoSuite + 265
						set yClick to yStartMAutoSuite + 56
						set zClick to -12
						my clickMouseDropMenu()
					end repeat
				end if
				
				(*set xClick to xStartMAutoSuite + 188
				set yClick to yStartMAutoSuite + 53
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoSuite + 190
				set yClick to yStartMAutoSuite + 41
				my clickMouse()*)
				
				delay 0.3
				set MAutoSuiteSize to size of window 1
				delay 0.3
				
				-- launch RENDER
				set xClick to xStartMAutoSuite + 400
				set yClick to yStartMAutoSuite + 700
				my clickMouse()
				
				--check of RENDER
				
				(*click menu item 17 of menu 1 of menu bar item 7 of menu bar 1
				set renderRegionName to value of text field 1 of window 1
				click button 1 of window 1*)
				
				(*if regionName is equal to renderRegionName then
					set xClick to xStartMAutoSuite + 630
					set yClick to yStartMAutoSuite + 700
					my clickMouse()
				end if*)
				
				if size of window 1 is not equal to MAutoSuiteSize then
					repeat until (size of window 1 is equal to MAutoSuiteSize)
					end repeat
				else
					set xClick to xStartMAutoSuite + 630
					set yClick to yStartMAutoSuite + 700
					my clickMouse()
					repeat until (size of window 1 is equal to MAutoSuiteSize)
					end repeat
				end if
				
				delay 0.3
				
				(*-- Hide all floating windows
				click menu item 3 of menu 1 of menu bar item 12 of menu bar 1*)
				
				--close MAutoSuite
				set xClick to xStartMAutoSuite
				set yClick to yStartMAutoSuite
				my clickMouse()
				
				if size of window 1 is not equal to EditWindowSize then
					repeat until (size of window 1 is equal to EditWindowSize)
						set xClick to xStartMAutoSuite
						set yClick to yStartMAutoSuite
						my clickMouse()
					end repeat
				end if
				delay 1
				
				--solo deactivate
				key code 1 using {shift down} -- shift+s
				
				delay 0.8
				
				-- select end of the region
				key code 126 -- Arrow Up
				delay 0.8
				-- check of the next region
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.1
				key code 3 --  F
				delay 0.8
				key code 39 -- ' quote
				delay 0.8
				if value of button 3 of toolbar 4 of window 1 as number is equal to (ytc + 1920) then
					key code 37 using {shift down} -- L
					key code 51 -- delete
				end if
				
				(*key code 37 using {shift down} -- L
				delay 0.8
				if value of button 4 of toolbar 4 of window 1 as number > gBtc then
					-- select end of the region
					key code 126 -- Arrow Up
				end if*)
				
				delay 0.8
			end tell
		end tell
	end tell
end MAutoAlign10*)

on MAutoAlignPT12()
	tell application "Finder"
		tell application "System Events"
			set PT to the first application process whose creator type is "PTul"
			tell PT
				activate
				delay 0.3
				
				set frontmost to true
				
				set MainWindowSize to size of window 1
				
				--select number of tracks
				set temp to display dialog "Enter number of tracks and click OK" default answer ""
				set number_of_tracks to the text returned of temp
				repeat until (size of window 1 is equal to EditWindowSize)
				end repeat
				
				delay 0.3
				
				set frontmost to true
				
				-- sub counter
				repeat until (title of text field 2 of group 4 of window 1 = "Sub Counter")
					set xClick to 678
					set yClick to 80
					set zClick to 28
					my clickMouseDropMenu()
				end repeat
				
				-- switch Main Counter to Samples
				click menu item 5 of menu 1 of menu item 14 of menu 1 of menu bar item 5 of menu bar 1
				
				delay 0.3
				
				-- copy start TC of selection
				set gAtc to value of text field 3 of group 4 of window 1
				-- copy end TC of selection
				set gBtc to value of text field 4 of group 4 of window 1
				
				set frontmost to true
				
				--set SLIP mode
				click button 3 of group 1 of window 1
				
				-- delete fades of regions
				click menu item 2 of menu 1 of menu item 37 of menu 1 of menu bar item 4 of menu bar 1
				
				delay 0.3
				
				-- uncheck Tab to Transients
				if value of button 9 of group 3 of window 1 = "Selected" then
					click button 9 of group 3 of window 1
				end if
				
				delay 0.3
				
				-- check Insertion Follows Playback
				repeat until (value of button 13 of group 3 of window 1 = "")
					click button 13 of group 3 of window 1
				end repeat
				
				
				
				(*
--check Video online
				if value of attribute "AXMenuItemMarkChar" of menu item 6 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 38 using {shift down, command down} -- shift,cmd+J
				end if
*)
				
				delay 0.3
				
				--check Play Loop
				repeat until (value of button 7 of group 1 of group 6 of window 1 = "loop")
					key code 37 using {shift down, command down} -- shift,cmd+L
				end repeat
				(*-- check Play Loop
				if value of button 7 of group 1 of group 6 of window 1 = "" then
					key code 37 using {shift down, command down} -- shift,cmd+L
				end if*)
				
				
				(*
--check pre-roll
				if value of attribute "AXMenuItemMarkChar" of menu item 8 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 40 using {command down} -- shift,cmd+K
				end if
*)
				
				
				--check Solo
				click button 4 of group "MAutoAlign_LAV - Auxiliary Track" of window 1
				delay 0.3
				if value of button 4 of group "MAutoAlign_LAV - Auxiliary Track" of window 1 = "on" then
					button 4 of group "MAutoAlign_LAV - Auxiliary Track" of window 1
				end if
				
				delay 2
				
				set frontmost to true
				
				-- select start of the first region
				key code 125 -- Arrow Down 
				key code 35 -- P
				key code 41 -- ; semicolon
				
				delay 0.3
				-- check of empty start
				set n to value of text field 1 of group 4 of window 1
				delay 0.3
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.3
				key code 3 --  F
				delay 0.8
				key code 39 -- ' quote
				delay 0.8
				if value of text field 1 of group 4 of window 1 as number = (n + 1920) then
					delay 0.8
					key code 37 using {shift down} -- L
					delay 0.8
					key code 51 -- delete
				end if
				-- cycle of denoise
				repeat number_of_tracks times
					-- compare TC of cursor with end TC of selection
					set tc to value of text field 1 of group 4 of window 1
					delay 0.3
					repeat while tc < gBtc
						if tc < gBtc then
							my MAutoAlign12()
							set tc to value of text field 1 of group 4 of window 1
						end if
					end repeat
					
					-- shift cursor down
					repeat while value of text field 1 of group 4 of window 1 > gAtc
						if value of text field 1 of group 4 of window 1 > gAtc then
							key code 37 -- L
						end if
					end repeat
					
					key code 41 -- ; semicolon
					
					repeat while value of text field 1 of group 4 of window 1 < gAtc
						if value of text field 1 of group 4 of window 1 < gAtc then
							key code 39 -- ' quote
						end if
					end repeat
				end repeat
				
				
				-- switch Main Counter to TimeCode
				click menu item 3 of menu 1 of menu item 14 of menu 1 of menu bar item 5 of menu bar 1
				
				-- uncheck Play Loop
				if value of button 7 of group 1 of group 6 of window 1 = "loop" then
					key code 37 using {shift down, command down} -- shift,cmd+L
				end if
				
				-- hide sub counter
				repeat until (title of text field 3 of group 4 of window 1 = "Edit Selection Start")
					set xClick to 678
					set yClick to 72
					set zClick to 28
					my clickMouseDropMenu()
				end repeat
				
				(*
--check Video online
				if value of attribute "AXMenuItemMarkChar" of menu item 6 of menu 1 of menu bar item 10 of menu bar 1 is not equal to "✓" then
					key code 38 using {shift down, command down} -- shift,cmd+J
				end if
*)
				
				delay 0.3
				
				display dialog "MAutoAlign done!"
				
			end tell
		end tell
	end tell
end MAutoAlignPT12

on MAutoAlign12()
	tell application "Finder"
		tell application "System Events"
			set PT to the first application process whose creator type is "PTul"
			
			tell PT
				activate
				set frontmost to true
				
				if value of text field 1 of group 4 of window 1 < gAtc then
					key code 39 -- ' quote
				end if
				
				--solo activate
				key code 1 using {shift down} -- shift+s
				
				delay 0.3
				
				
				(*
-- check of empty start
				set n to value of text field 1 of group 4 of window 1
				delay 0.3
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.3
				key code 3 --  F
				delay 0.8
				key code 39 -- ' quote
				delay 0.8
				if value of text field 1 of group 4 of window 1 as number = (n + 1920) then
					delay 0.8
					key code 37 using {shift down} -- L
					delay 0.8
					key code 51 -- delete
				end if
*)
				
				
				-- select region for MAutoPhase
				key code 39 using {shift down} -- ' quote
				
				delay 0.3
				-- copy start TC of selection
				set xtc to value of text field 3 of group 4 of window 1
				-- copy start TC of selection
				set ytc to value of text field 4 of group 4 of window 1
				delay 0.3
				
				
				(*
if (ytc = 4.147198989E+9) then
					--solo deactivate
					key code 1 using {shift down} -- shift+s
					
					delay 0.3
					
					-- select end of the region
					key code 126 -- Arrow Up
					delay 0.3
					
				else
*)
				
				repeat until (ytc - xtc > 24000)
					key code 78 using {option down} -- alt+"-"
					-- copy start TC of selection
					set xtc to value of text field 3 of group 4 of window 1
					if (ytc - xtc < 24000) then
						key code 69 using {command down} -- cmd+"+"
						-- copy start TC of selection
						set ytc to value of text field 4 of group 4 of window 1
					end if
				end repeat
				
				--click Rename
				click menu item 17 of menu 1 of menu bar item 7 of menu bar 1
				delay 0.3
				set regionName to title of text field 1 of group 1 of window 1
				delay 0.3
				repeat while (exists window "Name")
					click button "OK" of window 1
					delay 1
					if window "Name" exists then
						tell window 1
							set {xPosition, yPosition} to position
							set {xSize, ySize} to size
						end tell
						-- modify offsets if hot spot is not centered:
						set xClick to (xPosition + 261)
						set yClick to (yPosition + 131)
						my clickMouse()
					end if
				end repeat
				delay 0.3
				-- launch Plug-in: MAutoAlign
				click button 8 of group "Inserts A-E" of group "MAutoAlign_LAV - Auxiliary Track" of window 1
				tell button 1 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xStartMAutoInsert to (xPosition + (xSize div 2))
				set yStartMAutoInsert to (yPosition + (ySize div 2))
				
				delay 0.3
				
				--select factory default 
				set xClick to xStartMAutoInsert + 218
				set yClick to yStartMAutoInsert + 35
				set zClick to 1
				my clickMouseDropMenu()
				delay 0.3
				set xClick to xStartMAutoInsert + 248
				set yClick to yStartMAutoInsert + 55
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoInsert + 218
				set yClick to yStartMAutoInsert + 35
				set zClick to 1
				my clickMouseDropMenu()
				
				delay 0.3
				set MAutoInsertSize to size of window 1
				delay 0.3
				
				-- launch play loop
				click button 7 of group 1 of group 6 of window 2
				
				
				(*
--check pre-roll
				if value of attribute "AXMenuItemMarkChar" of menu item 8 of menu 1 of menu bar item 10 of menu bar 1 = "✓" then
					key code 40 using {command down} -- shift,cmd+K
				end if
*)
				
				
				delay 0.3
				
				if size of window 1 is not equal to MAutoInsertSize then
					repeat until value of button 7 of group 1 of group 6 of window 2 = "loop selected"
						click button "OK" of window 1
						delay 0.3
						set frontmost to true
						delay 1
						click button 7 of group 1 of group 6 of window 2
						delay 1
					end repeat
				end if
				
				delay 1
				
				-- click ANALYZE
				
				
				(*
set xClick to xStartMAutoInsert + 101
				set yClick to yStartMAutoInsert + 328
*)
				set xClick to xStartMAutoInsert + 77
				set yClick to yStartMAutoInsert + 318
				my clickMouse()
				repeat until (size of window 1 is equal to MAutoInsertSize)
					try
						if title of window 1 = "Information" then
							tell window 1
								set {xPosition, yPosition} to position
								set {xSize, ySize} to size
							end tell
							-- modify offsets if hot spot is not centered:
							set xClick to (xPosition + (xSize div 2))
							set yClick to (yPosition + (ySize - ySize div 5))
							my clickMouse()
						end if
					end try
				end repeat
				
				delay 3
				
				(*
try
					if title of window 1 = "Information" then
						tell window 1
							set {xPosition, yPosition} to position
							set {xSize, ySize} to size
						end tell
						-- modify offsets if hot spot is not centered:
						set xClick to (xPosition + (xSize div 2))
						set yClick to (yPosition + (ySize - ySize div 5))
						my clickMouse()
					end if
				end try
*)
				
				
				if size of window 1 is not equal to MAutoInsertSize then
					repeat until (size of window 1 is equal to MAutoInsertSize)
					end repeat
				else
					set xClick to xStartMAutoInsert + 77
					set yClick to yStartMAutoInsert + 318
					my clickMouse()
					repeat until (size of window 1 is equal to MAutoInsertSize)
					end repeat
				end if
				
				delay 3
				
				-- stop play PT
				click button 6 of group 1 of group 6 of window 2
				
				delay 0.3
				
				-- copy plug-in settings (shift+cmd+C)
				key code 8 using {shift down, command down}
				
				-- click copy button in MAutoAlign
				tell button 4 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xClick to (xPosition - 22)
				set yClick to (yPosition + 495)
				my clickMouse()
				delay 0.3
				set xClick to (xPosition - 20)
				set yClick to (yPosition + 495)
				my clickMouse()
				
				(*
set xClick to xStartMAutoInsert + 624
				set yClick to yStartMAutoInsert + 535
				
				
				
				set xClick to xStartMAutoInsert + 524
				set yClick to yStartMAutoInsert + 505
				my clickMouse()
				delay 0.3
				set xClick to xStartMAutoInsert + 522
				set yClick to yStartMAutoInsert + 505
				
				
				set xClick to xStartMAutoInsert + 622
				set yClick to yStartMAutoInsert + 535
				my clickMouse()
*)
				
				
				delay 0.3
				
				-- close Plug-in: MAutoAlign
				repeat until (size of window 1 is equal to EditWindowSize)
					set xClick to xStartMAutoInsert
					set yClick to yStartMAutoInsert
					my clickMouse()
				end repeat
				
				
				delay 0.3
				
				-- launch AudioSuite: MAutoAlign
				click menu item "MAutoAlign" of menu 1 of menu item "Other" of menu 1 of menu bar item "AudioSuite" of menu bar 1
				
				tell button 1 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xStartMAutoSuite to (xPosition + (xSize div 2))
				set yStartMAutoSuite to (yPosition + (ySize div 2))
				
				delay 0.3
				
				-- paste plug-in settings (shift+cmd+V)
				key code 9 using {shift down, command down}
				delay 0.3
				
				tell button 4 of window 1
					set {xPosition, yPosition} to position
					set {xSize, ySize} to size
				end tell
				-- modify offsets if hot spot is not centered:
				set xClick to (xPosition + (xSize div 2))
				set yClick to (yPosition + 495)
				my clickMouse()
				delay 0.3
				set xClick to (xPosition + (xSize div 2) - 2)
				set yClick to (yPosition + 495)
				my clickMouse()
				
				(*
set xClick to xStartMAutoSuite + 648
				set yClick to yStartMAutoSuite + 535
				
				set xClick to xStartMAutoSuite + 542
				set yClick to yStartMAutoSuite + 505
				my clickMouse()
				delay 0.3
				
				
				set xClick to xStartMAutoSuite + 640
				set yClick to yStartMAutoSuite + 505
				
				set xClick to xStartMAutoSuite + 540
				set yClick to yStartMAutoSuite + 505
				my clickMouse()
*)
				
				
				
				-- change entire selection to clip-by-clip
				set xClick to xStartMAutoSuite + 266
				set yClick to yStartMAutoSuite + 53
				set zClick to -12
				my clickMouseDropMenu()
				
				-- check clip by clip
				if title of button 9 of window 1 is not equal to "whole file" then
					repeat until (title of button 9 of window 1 = "whole file")
						delay 1
						set xClick to xStartMAutoSuite + 265
						set yClick to yStartMAutoSuite + 56
						set zClick to -12
						my clickMouseDropMenu()
					end repeat
				end if
				
				delay 0.3
				set MAutoSuiteSize to size of window 1
				delay 0.3
				set regionRenderName to regionName
				
				repeat until (regionRenderName is not equal to regionName)
					-- launch RENDER
					tell button 10 of window 1
						set {xPosition, yPosition} to position
						set {xSize, ySize} to size
					end tell
					-- modify offsets if hot spot is not centered:
					set xClick to (xPosition + (xSize div 2))
					set yClick to (yPosition + (ySize div 2))
					my clickMouse()
					
					repeat until (size of window 1 is equal to MAutoSuiteSize)
					end repeat
					
					--click Rename
					click menu item 17 of menu 1 of menu bar item 7 of menu bar 1
					delay 0.3
					set regionRenderName to title of text field 1 of group 1 of window 1
					delay 0.3
					repeat while (exists window "Name")
						click button "OK" of window 1
						delay 1
						if window "Name" exists then
							tell window 1
								set {xPosition, yPosition} to position
								set {xSize, ySize} to size
							end tell
							-- modify offsets if hot spot is not centered:
							set xClick to (xPosition + 261)
							set yClick to (yPosition + 131)
							my clickMouse()
						end if
					end repeat
					
				end repeat
				
				delay 0.3
				
				--close MAutoSuite
				
				repeat until (size of window 1 is equal to EditWindowSize)
					set xClick to xStartMAutoSuite
					set yClick to yStartMAutoSuite
					my clickMouse()
					delay 1
				end repeat
				
				delay 0.3
				
				--solo deactivate
				key code 1 using {shift down} -- shift+s
				
				delay 0.3
				
				-- select end of the region
				key code 126 -- Arrow Up
				delay 0.3
				-- check of empty start
				set n to value of text field 1 of group 4 of window 1
				delay 0.3
				key code 47 -- . Period
				key code 37 using {shift down} -- L
				delay 0.3
				key code 3 --  F
				delay 0.8
				key code 39 -- ' quote
				delay 0.8
				if value of text field 1 of group 4 of window 1 as number = (n + 1920) then
					delay 0.8
					key code 37 using {shift down} -- L
					delay 0.8
					key code 51 -- delete
				end if
				
			end tell
		end tell
	end tell
end MAutoAlign12



on clickMouse()
	-- move the mouse to the x/y coordinates in 100 steps
	
	set mouseToolsPath to (path to home folder as text) & "UnixBins:MouseTools"
	
	set x to xClick
	
	set y to yClick
	
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -mouseSteps 200"
	delay 0.3
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -leftClickNoRelease"
	delay 0.3
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -releaseMouse"
	
end clickMouse

on clickMouseDouble()
	-- move the mouse to the x/y coordinates in 100 steps
	
	set mouseToolsPath to (path to home folder as text) & "UnixBins:MouseTools"
	
	set x to xClick
	
	set y to yClick
	
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -mouseSteps 200"
	delay 0.3
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -doubleLeftClick"
	delay 1
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -doubleLeftClick"
end clickMouseDouble

on clickMouseDropMenu()
	-- move the mouse to the x/y coordinates in 100 steps
	
	set mouseToolsPath to (path to home folder as text) & "UnixBins:MouseTools"
	
	set x to xClick
	
	set y to yClick
	
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -mouseSteps 200"
	delay 0.3
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -leftClickNoRelease"
	
	set x to xClick + 25
	
	set y to yClick + zClick
	
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -mouseSteps 200"
	delay 0.3
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -leftClickNoRelease"
	do shell script quoted form of POSIX path of mouseToolsPath & " -x " & (x as text) & " -y " & (y as text) & " -releaseMouse"
	
end clickMouseDropMenu