# encoding: UTF-8

STRINGS = [
'tswMP: Please wait for game event to complete...', # 0
'tswMP: Click the mouse to teleport to (%X,%X)%s',
'tswMP: Move the mouse to choose a destination to teleport.',
'tswMP: (%X,%X) is inaccessible. Move the mouse to choose a different destination.',
'tswMP: Press an alphabet/arrow key to use the corresponding item.',
'tswMP: Teleported to (%X,%X). Move the mouse to continue teleporting%s', # 5
', or press a key to use an item.',
'tswMP: Use arrow keys to fly up/down; release the [WIN] or [TAB] key to confirm.',
'tswMP: YOU HAVE CHEATED AT THE GAME!',
'tswMP: Started. Found TSW running - pID=%d; hWnd=0x%08X',
'tswMP: Could not use %s!', # 10
'''tswMovePoint is running. Press the [WIN]/[TAB] key to use!

When the [WIN] or [TAB] hotkey is down:
1) Move the mouse and then click to teleport in the map;
2) Press a specified alphabet key to use an item or any
   arrow keys to use Orb of Flight.

When holding the hotkey, you can also see:
* the damage and next critical value of each monster and
* other useful data (if you hover the mouse on a monster)
on the map and in the status bar if you have Orb of Hero.

In addition, you can:
Double press F7 = Re-register hotkeys if they stop working;
Hold F7 = Quit tswMovePoint.''',
'Re-registered [WIN] and [TAB] hotkeys.',
'tswMovePoint has stopped.',
'DMG:%s = %s * %sRND | %dG%s',
' | PrevCRI:%s', # 15
' | NextCRI:%s',

'Inf', # -2
'.' # -1
]

# for utf-8 encoding: needs W-type API prototypes, and the strings should be processed by `.unpack('U*').pack('S*')`
