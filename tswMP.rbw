#!/usr/bin/env ruby
# encoding: ASCII-8Bit

require 'win32/api'
include Win32
GetMessage = API.new('GetMessage', 'PLLL', 'I', 'user32')
PostMessage = API.new('PostMessage','LLLP', 'I', 'user32')
SendMessage = API.new('SendMessageA', 'LLLP', 'L', 'user32') # ansi
SendMessageW = API.new('SendMessageW', 'LLLP', 'L', 'user32') # unicode
GetClientRect = API.new('GetClientRect', 'LP', 'L', 'user32')
FillRect = API.new('FillRect', 'LSL', 'L', 'user32')
OpenProcess = API.new('OpenProcess', 'LLL', 'L', 'kernel32')
ReadProcessMemory = API.new('ReadProcessMemory', 'LLPLL', 'L', 'kernel32')
WriteProcessMemory = API.new('WriteProcessMemory', 'LLPLL', 'L', 'kernel32')
CloseHandle = API.new('CloseHandle', 'L', 'L', 'kernel32')
GetCurrentThreadId = API.new('GetCurrentThreadId', 'V', 'L', 'kernel32')
GetWindowThreadProcessId = API.new('GetWindowThreadProcessId', 'LP', 'L', 'user32')
AttachThreadInput = API.new('AttachThreadInput', 'III', 'I', 'user32')
MessageBox = API.new('MessageBoxA', 'LSSI', 'L', 'user32')
MessageBoxW = API.new('MessageBoxW', 'LSSI', 'L', 'user32')
IsWindow = API.new('IsWindow', 'L', 'L', 'user32')
FindWindow = API.new('FindWindow', 'SL', 'L', 'user32')
GetLastActivePopup = API.new('GetLastActivePopup', 'L', 'L', 'user32')
ShowWindow = API.new('ShowWindow', 'LI', 'L', 'user32')
EnableWindow = API.new('EnableWindow', 'LI', 'L', 'user32')
UpdateWindow = API.new('UpdateWindow', 'L', 'L', 'user32')
DrawText = API.new('DrawTextA', 'LSIPL', 'L', 'user32')
DrawTextW = API.new('DrawTextW', 'LSIPL', 'L', 'user32')
TextOut = API.new('TextOutA', 'LLLSL', 'L', 'gdi32')
TextOutW = API.new('TextOutW', 'LLLSL', 'L', 'gdi32')
Polyline = API.new('Polyline', 'LSI', 'L', 'gdi32')
PatBlt = API.new('PatBlt', 'LLLLLL', 'L', 'gdi32')
BitBlt = API.new('BitBlt', 'LLLLLLLLL', 'L', 'gdi32')
InvalidateRect = API.new('InvalidateRect', 'LPL', 'L', 'user32')
GetFocus = API.new('GetFocus', 'V', 'L', 'user32')
GetForegroundWindow = API.new('GetForegroundWindow', 'V', 'L', 'user32')
SetForegroundWindow = API.new('SetForegroundWindow', 'L', 'L', 'user32')
GetCursorPos = API.new('GetCursorPos', 'P', 'L', 'user32')
ScreenToClient = API.new('ScreenToClient', 'LP', 'L', 'user32')
CreateCompatibleBitmap = API.new('CreateCompatibleBitmap', 'LII', 'L', 'gdi32')
CreateCompatibleDC = API.new('CreateCompatibleDC', 'L', 'L', 'gdi32')
DeleteDC = API.new('DeleteDC', 'L', 'L', 'gdi32')
GetDC = API.new('GetDC', 'L', 'L', 'user32')
ReleaseDC = API.new('ReleaseDC', 'LL', 'L', 'user32')
CreatePen = API.new('CreatePen', 'IIL', 'L', 'gdi32')
GetStockObject = API.new('GetStockObject', 'I', 'L', 'gdi32')
DeleteObject = API.new('DeleteObject', 'L', 'L', 'gdi32')
SelectObject = API.new('SelectObject', 'LL', 'L', 'gdi32')
SetDCBrushColor = API.new('SetDCBrushColor', 'LL', 'L', 'gdi32')
SetTextColor = API.new('SetTextColor', 'LL', 'L', 'gdi32')
SetBkColor = API.new('SetBkColor', 'LL', 'L', 'gdi32')
SetBkMode = API.new('SetBkMode', 'LI', 'L', 'gdi32')
SetROP2 = API.new('SetROP2', 'LI', 'L', 'gdi32')
CreateFontIndirect = API.new('CreateFontIndirect', 'S', 'L','gdi32')
RegisterHotKey = API.new('RegisterHotKey', 'LILL', 'L', 'user32')
UnregisterHotKey = API.new('UnregisterHotKey', 'LI', 'L', 'user32')

SW_SHOW = 4 # SHOWNOACTIVATE
WM_SETTEXT = 0xC
WM_GETTEXT = 0xD
WM_GETTEXTLENGTH = 0xE
WM_COMMAND = 0x111
WM_HOTKEY = 0x312
WM_APP = 0x8000
VK_LWIN = 0x5B
VK_RWIN = 0x5C
VK_TAB = 9
VK_ESCAPE = 0x1B
VK_LEFT = 0x25
VK_UP = 0x26
VK_RIGHT = 0x27
VK_DOWN = 0x28
DC_BRUSH = 18
DT_CENTER = 1
DT_VCENTER = 4
DT_SINGLELINE = 0x20
DT_CENTERBOTH = DT_CENTER | DT_VCENTER | DT_SINGLELINE
NONANTIALIASED_QUALITY = 3
SYSTEM_FONT = 13
PROCESS_VM_WRITE = 0x20
PROCESS_VM_READ = 0x10
PROCESS_VM_OPERATION = 0x8
MB_ICONERROR = 0x10
MB_ICONEXCLAMATION = 0x30
MB_ICONASTERISK = 0x40
MB_SETFOREGROUND = 0x10000
R2_XORPEN = 7
R2_COPYPEN = 13
R2_WHITE = 16
# Ternary Raster Operations
RASTER_S = 0xCC0020
RASTER_DPo = 0xFA0089
RASTER_DPx = 0x5A0049
HIGHLIGHT_COLOR = [0x22AA22, 0x60A0C0, 0x2222FF, 0xC07F40, 0x889988, 0x666666, 0xFFFFFF] # OK, suspicious, no-go, item, polyline, background, foreground text (note: not RGB, but rather BGR)
case [''].pack('p').size
when 4 # 32-bit ruby
  MSG_INFO_STRUCT = 'L7'
when 8 # 64-bit
  MSG_INFO_STRUCT = 'Q4L3'
else
  raise 'Unsupported system or ruby version (neither 32-bit or 64-bit).'
end

TSW_CLS_NAME = 'TTSW10'
BASE_ADDRESS = 0x400000
OFFSET_EDIT8 = 0x1c8 # status bar textbox at bottom
OFFSET_IMAGE6 = 0x254 # orb of hero
OFFSET_MEMO123 = [0x3c8, 0x3cc, 0x3d0] # HP/ATK/DEF
OFFSET_HWND = 0xc0
OFFSET_OWNER_HWND = 0x20
# OFFSET_TIMER_ENABLED = 0x20
OFFSET_CTL_LEFT = 0x24
OFFSET_CTL_TOP = 0x28
OFFSET_CTL_WIDTH = 0x2c
# OFFSET_CTL_HEIGHT = 0x30
# OFFSET_CTL_VISIBLE = 0x37 # byte
# OFFSET_CTL_ENABLED = 0x38 # byte
MIDSPEED_MENUID = 33 # The idea is to hijack the midspeed menu
MIDSPEED_ADDR = 0x7f46d + BASE_ADDRESS # so once click event of that menu item is triggered, arbitrary code can be executed
MIDSPEED_ORIG = 0x6F # original bytecode (call TTSW10.speedmiddle@0x47f4e0)
REFRESH_XYPOS_ADDR = 0x42c38 + BASE_ADDRESS # TTSW10.mhyouji
TIMER1_ADDR = 0x43120 + BASE_ADDRESS
TIMER2_ADDR = 0x5265c + BASE_ADDRESS
TTSW_ADDR = 0x8c510 + BASE_ADDRESS
TAPPLICATION_ADDR = 0x8a6f8 + BASE_ADDRESS
MAP_LEFT_ADDR = 0x8c578 + BASE_ADDRESS
MAP_TOP_ADDR = 0x8c57c + BASE_ADDRESS
MOVE_ADDR = [0x84c58+BASE_ADDRESS, 0x84c04+BASE_ADDRESS, 0x84bb0+BASE_ADDRESS, 0x84b5c+BASE_ADDRESS] # down/right/left/up
TEDIT8_MSGID_ADDR = 0x8c58c + BASE_ADDRESS
EVENTFLAG_ADDR = 0x8c5ac + BASE_ADDRESS
POINTER_ANSI_STR_ADDR = 0x8c5d4 + BASE_ADDRESS
ORB_FLIGHT_RULE_MSG_ID = 0x14 # you must be near the stairs to fly
ORB_FLIGHT_RULE_BYTES = ["\x0F\x85\xA2\0\0\0", "\x90"*6] # 0: original bytes (JNZ); 1: bypass OrbOfFly restriction (NOP)
SACREDSHIELD_ADDR = 0xb872c + BASE_ADDRESS
STATUS_ADDR = 0xb8688 + BASE_ADDRESS
STATUS_INDEX = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 9] # HP; ATK; ... Sword and shield are in item list
STATUS_LEN = 11
STATUS_TYPE = 'l11'
ITEM_ADDR = 0xb86c4 + BASE_ADDRESS
ITEM_INDEX = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] # The first 2 are sword and shield respectively; OrbOfHero; OrbOfWis; ...
ITEM_LEN = 17
ITEM_TYPE = 'l17'
MAP_ADDR = 0xb8934 + BASE_ADDRESS
MAP_TYPE = 'C121'
CONSUMABLES = {'position' => [0, 1, 2, 4, 5, 6, 7, 8, 9, 11, 12, 13],
  'key' => [72, 78, [VK_LEFT,VK_DOWN, VK_RIGHT,VK_UP], 87, 80, 66, 74, 85, 68, 73, 75, 81], # H N [wasd] W P B J U D I K Q
  'event_addr' => [0x80f60+BASE_ADDRESS, 0x8198c+BASE_ADDRESS, [0x81e80+BASE_ADDRESS, 0x81f59+BASE_ADDRESS, 0x4ed1c+BASE_ADDRESS, 0x4ed94+BASE_ADDRESS, 0x4eaf4+BASE_ADDRESS], 0x8201c+BASE_ADDRESS, 0x82128+BASE_ADDRESS, 0x82234+BASE_ADDRESS, 0x82340+BASE_ADDRESS, 0x8244c+BASE_ADDRESS, 0x82558+BASE_ADDRESS, 0x82664+BASE_ADDRESS, 0x82770+BASE_ADDRESS, 0x8287c+BASE_ADDRESS, 0x50ba0+BASE_ADDRESS]} # imgXXwork; the last is Button38Click (Button_Use)

MP_MODIFIER = 0
MP_HOTKEY = 118 # hotkey and modifier for quit and keyboard re-hook
MP_KEY1 = VK_LWIN
MP_KEY2 = VK_TAB # hotkeys for teleportation and using items
INTERVAL_REHOOK = 450 # the interval for rehook (in msec)
INTERVAL_QUIT = 50 # for quit (in msec)

$MPshowMapDmg = true # whether to enable enhanced damage display
$buf = "\0" * 640

require './connectivity'
require './monsters'
require './strings'

module Win32
  class API
    def self.focusTSW()
      hWnd = GetLastActivePopup.call($hWndTApp) # there is a popup child
      ShowWindow.call($hWndTApp, SW_SHOW) # this will restore the window if it was minimized
      hWnd = $hWnd if hWnd == $hWndTApp
      SetForegroundWindow.call(hWnd) # SetForegroundWindow for $hWndTApp can also achieve similar effect, but can sometimes complicate the situation, e.g., LastActivePopup will be $hWndTApp if no mouse/keyboard input afterwards
# by the way, SetForegroundWindow for $hWnd can cause some very serious side effect:
# it will trigger TTSW10.OnActivate=TTSW10.formactivate subroutine
# which will show prolog animation and restart the game! (can change the first opcode `push ebp` to `ret` to avoid)
      return hWnd
    end
    def self.msgbox(text, flag=MB_ICONASTERISK, api=(ansi=true; MessageBox), title=$appTitle)
      if IsWindow.call($hWnd || 0).zero?
        hWnd = $hWnd = 0 # if the window has gone, create a system level msgbox
      else
        hWnd = focusTSW() # if there is a popup child, use that as parent window
# because if use $hWnd as parent in such cases, the main window will be activated,
# causing a) the popup window losing focus and b) the adverse effect discussed earlier
      end
      title = (ansi ? 'tswMP' : "t\0s\0w\0M\0P\0\0") unless $appTitle
      return api.call(hWnd, text, title, flag | MB_SETFOREGROUND)
    end
    def call_r(*argv) # provide more info if a win32api returns null
      r = call(*argv)
      return r unless r.zero?
      err = '0x%04X' % API.last_error
      case function_name
      when 'OpenProcess', 'WriteProcessMemory', 'ReadProcessMemory', 'VirtualAllocEx'
        reason = "Cannot open / read from / write to / alloc memory for the TSW process. Please check if TSW V1.2 is running with pID=#{$pID} and if you have proper permissions."
      when 'RegisterHotKey'
        reason = "Cannot register hotkey. It might be currently occupied by other processes or another instance of tswMP. Please close them to avoid confliction. Default: F7 (0+ 118); current: (#{MP_MODIFIER}+ #{MP_HOTKEY}). As an advanced option, you can manually assign `MP_MODIFIER` and `MP_HOTKEY` in `tswMPdebug.txt'."
      else
        reason = "This is a fatal error. That is all we know."
      end
      raise_r("Err #{err} when calling `#{effective_function_name}'@#{dll_name}.\n#{reason} tswMP has stopped. Details are as follows:\n\nPrototype='#{prototype.join('')}', ReturnType='#{return_type}', ARGV=#{argv.inspect}")
    end
  end
end
unless $Exerb # EXERB GUI has its own error handler window
  alias :_raise :raise
  def raise(*argv)
    _raise(*argv)
  rescue Exception
    API.msgbox("#{$!.inspect}\n\n#{$@.join "\n"}"[0, 1023], MB_ICONERROR) # can't show too long message
  ensure
    exit
  end
end

# https://github.com/ffi/ffi/issues/283#issuecomment-24902987
# https://github.com/undees/yesbut/blob/master/2008-11-13/hook.rb
module HookProcAPI
  SetWindowsHookEx = API.new('SetWindowsHookEx', 'IKII', 'I', 'user32')
  UnhookWindowsHookEx = API.new('UnhookWindowsHookEx', 'I', 'I', 'user32')
  CallNextHookEx = API.new('CallNextHookEx', 'ILLL', 'I', 'user32')
  GetClassName = API.new('GetClassName', 'LPL', 'I', 'user32')
  ClipCursor = API.new('ClipCursor', 'S', 'I', 'user32')
  GetModuleHandle = API.new('GetModuleHandle', 'I', 'I', 'kernel32')
  RtlMoveMemory = API.new('RtlMoveMemory', 'PLI', 'V', 'kernel32')
  BeginPath = API.new('BeginPath', 'L', 'L', 'gdi32')
  EndPath = API.new('EndPath', 'L', 'L', 'gdi32')
  StrokePath = API.new('StrokePath', 'L', 'L', 'gdi32')

  WH_KEYBOARD_LL = 13
  WH_MOUSE_LL = 14
  WM_KEYDOWN = 0x100
  WM_KEYUP = 0x101
  WM_MOUSEMOVE = 0x200
  WM_LBUTTONDOWN = 0x201
  WM_RBUTTONDOWN = 0x204
  @hMod = GetModuleHandle.call_r(0)
  @hkhook = nil
  @hmhook = nil
  @itemAvail = [] # the items you have
  @winDown = false # [WIN] pressed; active
  @lastIsInEvent = false
  @access = nil # the destination is accessible?
  @flying = nil # currently using OrbOfFly; active
  @error = nil # exception within hook callback function
  @lastArrow = 0 # which arrowkey pressed previously? -1: none; 0: left; 1: right
  @lastDraw = nil # highlight and connecting polyline drawn before

  module_function
  def handleHookExceptions() # exception should not be raised until callback returned
    return if @error.nil?
    raise_r @error
  end
  def finally # code block wrapper
    yield
  end
  def getClassName(hWnd)
    len = GetClassName.call(hWnd, $buf, 256)
    return $buf[0, len]
  end
  def getFocusClassName()
    return getClassName(GetFocus.call)
  end
  def isButtonFocused()
    return getFocusClassName == 'TButton'
  end
  def isSLActive() # this is to make compatible with tswSL (or else ESC won't function in tswSL)
    case getFocusClassName
    when 'ComboBox', 'ComboLBox', 'Edit'
      return true
    end
    return false
  end
  def isInEvent()
    result = (isButtonFocused and !@flying)
    unless result
      result = !(readMemoryDWORD(EVENTFLAG_ADDR).zero?)
    end

    if result
      return true if @lastIsInEvent
      @lastIsInEvent = true # if @lastIsInEvent is false
      $x_pos = $y_pos = -1 # reset pos
      showMsg(1, 0)
    elsif @lastIsInEvent # result is false and @lastIsInEvent is true
      if @hmhook # just waited an event over; redraw items bar and map damage
        callFunc(TIMER2_ADDR) # immediately call TIMER2TIMER. Normally, the timer2 will wait 300 msec, then run once (i.e. will disable itself after the first run), where it will call `TTSW10.itemlive (which ends the in-event status)`. This will enforce redrawing the window, which will mess up with our drawing. So we will call it by ourselves without the 300 ms delay; then begin drawing
        InvalidateRect.call($hWnd, $itemsRect, 0) # redraw item bar
        UpdateWindow.call($hWnd) # update immediately to clear the invalidated rect
        recalcStatus
        drawItemsBar # before this, UpdateWindow must be called; otherwise, the TSW's own redrawing process (caused by `itemlive`) may clear the drawing here
        @lastIsInEvent = false
        _msHook('init', WM_MOUSEMOVE, 0) # continue teleportation
      else
        @lastIsInEvent = false
        InvalidateRect.call($hWnd, $msgRect, 0) # clear message bar
      end
    end
    return result
  end
  def abandon(force=true)
    unhookM(force)
    @winDown = false
    @lastIsInEvent = false
    @flying = nil
  end
  def recalcStatus()
    ReadProcessMemory.call_r($hPrc, STATUS_ADDR, $buf, STATUS_LEN << 2, 0)
    $heroStatus = $buf.unpack(STATUS_TYPE)
    ReadProcessMemory.call_r($hPrc, ITEM_ADDR, $buf, ITEM_LEN << 2, 0)
    $heroItems = $buf.unpack(ITEM_TYPE)
    hero = [$heroStatus[STATUS_INDEX[0]], $heroStatus[STATUS_INDEX[1]], $heroStatus[STATUS_INDEX[2]]] # hp/atk/def
    floor = $heroStatus[STATUS_INDEX[4]]
    mFac = readMemoryDWORD(MONSTER_STATUS_FACTOR_ADDR) + 1
    if mFac != 1
      if $hWndMemo.empty? # $hWndMemo not yet defined
        OFFSET_MEMO123.each {|i| $hWndMemo.push(readMemoryDWORD(readMemoryDWORD($TTSW+i)+OFFSET_HWND))}
      end # these can't be immediately assigned upon TSW initialization; see `init`
      for i in 0..2
        SendMessage.call($hWndMemo[i], WM_SETTEXT, 0, '%d.%02d' % (hero[i]*100/mFac).divmod(100))
      end
    end
    Monsters.heroHP = hero[0]
    Monsters.heroATK = hero[1]
    Monsters.heroDEF = hero[2]
    Monsters.statusFactor = mFac
    Monsters.heroOrb = $MPshowMapDmg && ($heroItems[ITEM_INDEX[2]]==1)
    Monsters.cross = ($heroItems[ITEM_INDEX[5]]==1)
    Monsters.dragonSlayer = ($heroItems[ITEM_INDEX[12]]==1)
    Monsters.luckyGold = ($heroItems[ITEM_INDEX[16]]==1)

    if floor > 40
      Monsters.check_mag = readMemoryDWORD(SACREDSHIELD_ADDR).zero?
    else
      Monsters.check_mag = false
    end
    ReadProcessMemory.call_r($hPrc, MAP_ADDR+floor*123+2, $buf, 121, 0)
    $mapTiles = $buf.unpack(MAP_TYPE)
    ReadProcessMemory.call_r($hPrc, MONSTER_STATUS_ADDR, $buf, MONSTER_STATUS_LEN << 2, 0)
    $monStatus = $buf.unpack(MONSTER_STATUS_TYPE)
    drawMapDmg(true) # reinit after an event happens
    Connectivity.floodfill($heroStatus[STATUS_INDEX[6]], $heroStatus[STATUS_INDEX[7]]) # x, y
  end
  def drawMapDmg(init)
    callFunc(TIMER1_ADDR) # elicit TIMER1TIMER
    callFunc(TIMER1_ADDR) # twice is necessary for battle events
    callFunc(TIMER1_ADDR) # thrice is necessary for dialog events (removal of richedit control) and refreshing hero xp position (disappear; ??; reappear)
    WriteProcessMemory.call_r($hPrc, TIMER1_ADDR, "\xc3", 1, 0) # TIMER1TIMER ret (disable; freeze)
    SelectObject.call($hDC, $hGUIFont)
    SelectObject.call($hDC, $hPen2)
    SetROP2.call($hDC, R2_COPYPEN)
    Monsters.checkMap(init)
    SetROP2.call($hDC, R2_XORPEN)
    SelectObject.call($hDC, $hPen)
    SelectObject.call($hDC, $hSysFont)
  end
  def drawDmg(x, y, dmg, cri, danger)
    x = $MAP_LEFT+$TILE_SIZE*x + 1
    y = $MAP_TOP+$TILE_SIZE*(y+1) - 15
    dmg_u = Str.utf8toWChar(dmg)
    dmg_s = Str.strlen()
    if danger
      SetTextColor.call($hDC, HIGHLIGHT_COLOR[2])
      SetROP2.call($hDC, R2_WHITE)
    end
    BeginPath.call($hDC)
    TextOut.call($hDC, x, y-12, cri, cri.size) if cri
    TextOutW.call($hDC, x, y, dmg_u, dmg_s)
    EndPath.call($hDC)
    StrokePath.call($hDC)
# StrokeAndFillPath won't work well here because the inside of the path will also be framed (The pen will draw along the center of the frame. Why is there PS_INSIDEFRAME but no PS_OUTSIDE_FRAME? GDI+ can solve this very easily by pen.SetAlignment), making the texts difficult to read.
# So FillPath or another TextOut must be called afterwards to overlay on top of the inside stroke
# SaveDC and RestoreDC can be used to solve the issue that StrokePath or FillPath will discard the active path afterwards (not used here)
# refer to: https://github.com/tpn/windows-graphics-programming-src/blob/master/Chapt_15/Text/TextDemo.cpp#L1858
    TextOut.call($hDC, x, y-12, cri, cri.size) if cri
    TextOutW.call($hDC, x, y, dmg_u, dmg_s)
    if danger
      SetTextColor.call($hDC, HIGHLIGHT_COLOR.last)
      SetROP2.call($hDC, R2_COPYPEN)
    end
  end
  def drawItemsBar()
    @lastDraw = nil
    @itemAvail = []
    SetBkMode.call($hDC, 2) # opaque
    for i in 0..11 # check what items you have
      j = CONSUMABLES['position'][i]
      count = $heroItems[ITEM_INDEX[2+j]] # note the first 2 are sword and shield
      if i == 6 # space wing
        next if count < 1
      else # otherwise can't have more than 1
        next if count != 1
      end
      @itemAvail << i
      y, x = j.divmod(3)
      x = x * $TILE_SIZE + $ITEMSBAR_LEFT
      y = y * $TILE_SIZE + $ITEMSBAR_TOP
      if i == 2
        DrawTextW.call($hDC, "\xBC\x25\n\0\xB2\x25", 3, $OrbFlyRect.last, 0) # U+25BC/25B2 = down/up triangle
      else
        TextOut.call($hDC, x, y, CONSUMABLES['key'][i].chr, 1)
      end
      SetDCBrushColor.call($hDC, HIGHLIGHT_COLOR[3])
      PatBlt.call($hDC, x, y, $TILE_SIZE, $TILE_SIZE, RASTER_DPo)
    end
    SetBkMode.call($hDC, 1) # transparent
  end
  def _msHook(nCode, wParam, lParam)
    block = false # block input?
    finally do
      break if nCode.to_i < 0 # do not process
      break if @lastIsInEvent
      case wParam
      when WM_LBUTTONDOWN, WM_RBUTTONDOWN # mouse click; teleportation
        break if $x_pos < 0 or $y_pos < 0 or isInEvent
        block = true
        cheat = (wParam == WM_RBUTTONDOWN)
        x, y = $x_pos, $y_pos
        if cheat
          cheat = (@access != 0)
          showMsgTxtbox(cheat ? 8 : -1)
        else
          case @access
          when nil
            break
          when -11 # go down
            y -= 1; operation = MOVE_ADDR[0]
          when -1 # go right
            x -= 1; operation = MOVE_ADDR[1]
          when 1 # go left
            x += 1; operation = MOVE_ADDR[2]
          when 11 # go up
            y += 1; operation = MOVE_ADDR[3]
          when 0
          else # undefined (unlikely)
            break
          end
          showMsgTxtbox(-1)
        end
        EnableWindow.call($hWndText, 0)
        writeMemoryDWORD(STATUS_ADDR + (STATUS_INDEX[6] << 2), x)
        writeMemoryDWORD(STATUS_ADDR + (STATUS_INDEX[7] << 2), y)

        WriteProcessMemory.call_r($hPrc, TIMER1_ADDR, "\x53", 1, 0) # TIMER1TIMER push ebx (re-enable)
        callFunc(REFRESH_XYPOS_ADDR) # TTSW10.mhyouji (only refresh braveman position; do not refresh whole map)

        checkTSWsize()

        @lastDraw = nil
        unless cheat or @access.zero? # need to move 1 step
          callFunc(operation) # move to the destination and trigger the event
          break if isInEvent()
        end
        # directly teleport to destination or somehow no event is triggered (e.g. ATK too low)
        break unless @hmhook # stop drawing if WIN key is already released while this hooked function is still running
        drawMapDmg(false) # since the map has already refreshed, the damage values on the map should be redrawn
        showMsg(cheat ? 2 : 0, 5, x, y, @itemAvail.empty? ? $str::STRINGS[-1] : $str::STRINGS[6])
        $mapTiles.map! {|i| if i.zero? then 6 elsif i < 0 then -i else i end} # revert previous graph coloring
        Connectivity.floodfill(x, y) # if event is not triggered, then the current coordinate is (x, y) not ($x_pos, $y_pos)!
        break
      when WM_MOUSEMOVE
      else
        break
      end
#     buf = "\0"*24
#     RtlMoveMemory.call(buf, lParam, 24)
#     buf = buf.unpack('L*')
      # the point returned in lparam is DPI-aware, useless here
      # https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/ns-winuser-msllhookstruct#members
#     mouse move
      GetCursorPos.call_r($buf)
      sx, sy = $buf.unpack('ll')
      ScreenToClient.call_r($hWnd, $buf)
      x, y = $buf.unpack('ll')
      dx = sx - x; dy = sy - y
      checkTSWsize()
      left = $MAP_LEFT + dx; top = $MAP_TOP + dy; size = $TILE_SIZE * 11
      ClipCursor.call([left, top, left+size, top+size].pack('l4')) # confine cursor pos within map

      x_pos = ((x - $MAP_LEFT) / $TILE_SIZE).floor
      y_pos = ((y - $MAP_TOP) / $TILE_SIZE).floor

      break if x_pos == $x_pos and y_pos == $y_pos # same pos
      if nCode != 'init' then break if isInEvent end # don't check this on init

      if @lastDraw # undo the last drawing
        if (r = Connectivity.route) then Polyline.call($hDC, r.pack('l*'), r.size >> 1) end # the trick is to XOR twice to restore the previous pixels
        BitBlt.call($hDC, @lastDraw[0], @lastDraw[1], $TILE_SIZE, $TILE_SIZE, $hMemDC, 0, 0, RASTER_S) # read bitmap from memory DC
        @lastDraw = nil
      end

      if x_pos < 0 or x_pos > 10 or y_pos < 0 or y_pos > 10 # outside
        if @itemAvail.empty? then showMsg(1, 2) else showMsg(3, 4) end
        $x_pos = $y_pos = -1 # cancel preview
        @lastDraw = nil
        break
      end

      $x_pos = x_pos; $y_pos = y_pos
      x_left = $MAP_LEFT + $TILE_SIZE*x_pos
      y_top = $MAP_TOP + $TILE_SIZE*y_pos

# it is possible that when [WIN] key is released (and thus `unhookM` is called), `_msHook` is still running; in this case, do not do the following things:
      @access = Connectivity.main(x_pos, y_pos)
      break unless @hmhook
      if @access
        color = HIGHLIGHT_COLOR[@access.zero? ? 0 : 1]
        showMsg(4, 1, x_pos, y_pos, @itemAvail.empty? ? $str::STRINGS[-1] : $str::STRINGS[6])
      else
        color = HIGHLIGHT_COLOR[2]
        if @itemAvail.empty?
          showMsg(1, 3, x_pos, y_pos)
        else
          showMsg(3, 4)
        end
      end

      break unless @hmhook
      BitBlt.call($hMemDC, 0, 0, $TILE_SIZE, $TILE_SIZE, $hDC, x_left, y_top, RASTER_S) # store the current bitmap for future redraw
      if (r = Connectivity.route) then Polyline.call($hDC, r.pack('l*'), r.size >> 1) end
      SetDCBrushColor.call($hDC, color)
      PatBlt.call($hDC, x_left, y_top, $TILE_SIZE, $TILE_SIZE, RASTER_DPo)
      @lastDraw = [x_left, y_top]

      id = Connectivity.destTile
      break unless @hmhook and Monsters.heroOrb and (m = Monsters.getMonsterID(id))
      writeMemoryDWORD(CUR_MONSTER_ID_ADDR, m)
      callFunc(SHOW_MONSTER_STATUS_ADDR)
      data = Monsters.monsters[m]
      if data.nil? # unlikely, but let's add this new item into database
        data = Monsters.getStatus(m)
        Monsters.monsters[m] = data
      end
      showMsgTxtbox(14, *Monsters.detail((m == 18 && id != 104), *data))
      EnableWindow.call($hWndText, 1) # now you can use mouse to select / scroll status bar textbox and view more info (I've made changes to the TSW.exe executable such that once the text changes, TEdit8 will be disabled again: TEdit8: OnChange = DisTEdit8 = mov eax, [eax+1c8]; call 413544)
    end
    return 1 if block or nCode == 'init' # upon pressing [WIN] without mouse move
    return CallNextHookEx.call(@hmhook, nCode, wParam, lParam)
  # no need to "rescue" here since the exceptions could be handled in _keyHook
  end
  def _keyHook(nCode, wParam, lParam)
    # 'LLL': If the prototype is set as 'LLP', the size of the pointer could not be correctly assigned
    # Therefore, the address of the pointer is retrieved instead, and RtlMoveMemory is used to get the pointer data
    RtlMoveMemory.call($buf, lParam, 20)
    key = $buf.unpack('L')[0]
    block = false # block input?
    finally do
      break if nCode < 0 # do not process
      if key == MP_KEY1 or key == MP_KEY2
        if key == VK_ESCAPE then break if isSLActive end
        alphabet = false # alphabet key pressed?
        arrow = false # arrow key pressed?
      else
        break unless @winDown and wParam == WM_KEYDOWN

        if (alphabet = CONSUMABLES['key'].index(key)) # which item chosen?
          break unless @itemAvail.include?(alphabet) # you must have that item
        elsif (arrow = CONSUMABLES['key'][2].index(key)) # up/downstairs?
          break unless @itemAvail.include?(2) # you must have orb of flight
        else break
        end
      end
      hWnd = GetForegroundWindow.call
      if hWnd != $hWnd # TSW is not active
        if getClassName(hWnd) != TSW_CLS_NAME
          abandon(false)
          break
        end
        init # if another TSW is active now
      end

      block = true
      if wParam == WM_KEYDOWN
        break if isInEvent # when holding [WIN] key, this (i.e. `isInEvent`) will automatically be called every ~50 msec (keyboard repeat delay)
        if alphabet and !@flying
          @winDown = false # de-active; restore
          unhookM

          callFunc(CONSUMABLES['event_addr'][alphabet]) # imgXXwork = click that item
          if isButtonFocused # can use item successfully (so the don't-use button is focused now)
            callFunc(CONSUMABLES['event_addr'][12]) if alphabet > 2 # buttonUseClick = click 'Use' (excluding OrbOfHero/Wisdom)
          else
            showMsgTxtbox(10, $str::LONGNAMES[14+alphabet].gsub(' ', ''))
          end

        elsif arrow
          if @flying # already flying: arrow keys=up/downstaris
            arrow >>= 1
            callFunc(CONSUMABLES['event_addr'][2][arrow+2]) # click Down/Up
            showMsgTxtbox(8) if @flying == 2
            if @lastArrow != arrow
              InvalidateRect.call($hWnd, $OrbFlyRect[@lastArrow], 0)
              UpdateWindow.call($hWnd) if @lastArrow < 0 # update immediately to clear the invalidated rect
              DrawTextW.call($hDC, ["\xBC\x25", "\xB2\x25"][arrow], 1, $OrbFlyRect[arrow], arrow << 1) # before this, UpdateWindow must be called; otherwise, the TSW's own redrawing process (caused by `InvalidateRect` above) may clear the drawing here
              PatBlt.call($hDC, (4+arrow)*$TILE_SIZE/2+$ITEMSBAR_LEFT, $ITEMSBAR_TOP, $TILE_SIZE/2, $TILE_SIZE, RASTER_DPo)
              @lastArrow = arrow
            end
          else
            unhookM
            WriteProcessMemory.call_r($hPrc, CONSUMABLES['event_addr'][2][1], ORB_FLIGHT_RULE_BYTES[1], 6, 0) if arrow == 3 # bypass OrbOfFlight restriction (JNZ->NOP)
            callFunc(CONSUMABLES['event_addr'][2][0]) # Image4Click (OrbOfFlight)
            WriteProcessMemory.call_r($hPrc, CONSUMABLES['event_addr'][2][1], ORB_FLIGHT_RULE_BYTES[0], 6, 0) if arrow == 3 # restore (JNZ)
            if arrow == 3 and $mapTiles # up arrow; bypass OrbOfFlight restriction
              arrow = 0 if $mapTiles.include?(-11) or $mapTiles.include?(-12) # you can access stairs, then it's not considered as cheating
            end
            if isButtonFocused # can use OrbOfFly successfully (so the up/down/ok button is focused now)
              @flying = (arrow == 3 ? 2 : 0) # cheat or not
              showMsgTxtbox(8) if @flying == 2
              @lastArrow = -1
              UpdateWindow.call($hWnd) # update immediately to clear the invalidated rect
              showMsg(@flying, 7)
              SetBkMode.call($hDC, 2) # opaque
              DrawTextW.call($hDC, "\xBC\x25\n\0\xB2\x25", 3, $OrbFlyRect.last, 0) # U+25BC/25B2 = down/up triangle
              PatBlt.call($hDC, 2*$TILE_SIZE+$ITEMSBAR_LEFT, $ITEMSBAR_TOP, $TILE_SIZE, $TILE_SIZE, RASTER_DPo) # before this, UpdateWindow must be called; otherwise, the TSW's own redrawing process (caused by `InvalidateRect` above) may clear the drawing here
            else
              @winDown = false
              showMsgTxtbox(10, $str::LONGNAMES[16].gsub(' ', '')) if readMemoryDWORD(TEDIT8_MSGID_ADDR) != ORB_FLIGHT_RULE_MSG_ID # otherwise, it's because "you must be near the stairs to fly!"
            end
          end
        elsif !@winDown # only trigger at the first time
          @winDown = true
          checkTSWsize
          recalcStatus
          drawItemsBar
          hookM
          _msHook('init', WM_MOUSEMOVE, 0) # do this subroutine once even without mouse move
        end
      elsif wParam == WM_KEYUP # (alphabet == false; arrow == false)
        block = false # if somehow [WIN] key down signal is not intercepted, then do not block (otherwise [WIN] key will always be down)
        if @flying
          SetBkMode.call($hDC, 1) # transparent
          callFunc(CONSUMABLES['event_addr'][2][4]) if @flying # click OK
        end
        abandon
      end
    end
    return 1 if block # block input
    return CallNextHookEx.call(@hkhook, nCode, wParam, lParam)
  rescue Exception => @error
    PostMessage.call(0, WM_APP, 0, 0)
    return CallNextHookEx.call(@hkhook, nCode, wParam, lParam)
  end
  MouseProc = API::Callback.new('LLL', 'L', &method(:_msHook))
  KeyboardProc = API::Callback.new('LLL', 'L', &method(:_keyHook))

  def hookK
    return false if @hkhook
    @hkhook = SetWindowsHookEx.call_r(WH_KEYBOARD_LL, KeyboardProc, @hMod, 0)
    return true
  end
  def unhookK
    return false unless @hkhook
    UnhookWindowsHookEx.call(@hkhook)
    @hkhook = nil
  end
  def rehookK
    unhookK
    abandon
    hookK
  end
  def hookM
    return false if @hmhook
    @hmhook = SetWindowsHookEx.call_r(WH_MOUSE_LL, MouseProc, @hMod, 0)
    return true
  end
  def unhookM(noCheck=false)
    return false unless @hmhook or noCheck
    UnhookWindowsHookEx.call(@hmhook || 0)
    @hmhook = nil

    WriteProcessMemory.call($hPrc || 0, TIMER1_ADDR, "\x53", 1, 0) # TIMER1TIMER push ebx (restore; re-enable)
    $x_pos = $y_pos = -1
    InvalidateRect.call($hWnd || 0, $itemsRect, 0) # redraw item bar
    InvalidateRect.call($hWnd || 0, $msgRect, 0) # clear message bar
    ClipCursor.call(nil) # do not confine cursor range
    mFac = Monsters.statusFactor
    return true if mFac == 1 or !$hWndMemo or $hWndMemo.empty?
    SendMessage.call($hWndMemo[0], WM_SETTEXT, 0, Monsters.heroHP.to_s)
    SendMessage.call($hWndMemo[1], WM_SETTEXT, 0, Monsters.heroATK.to_s)
    SendMessage.call($hWndMemo[2], WM_SETTEXT, 0, Monsters.heroDEF.to_s)
    return true
  end
  private :_msHook
  private :_keyHook
end

def showMsgA(colorIndex, textIndex, *argv)
  SetDCBrushColor.call($hDC, HIGHLIGHT_COLOR[colorIndex])
  FillRect.call($hDC, $msgRect, $hBr)
  DrawText.call($hDC, Str::StrEN::STRINGS[textIndex] % argv, -1, $msgRect, DT_CENTERBOTH)
end
def showMsgW(colorIndex, textIndex, *argv)
  SetDCBrushColor.call($hDC, HIGHLIGHT_COLOR[colorIndex])
  FillRect.call($hDC, $msgRect, $hBr)
  DrawTextW.call($hDC, Str.utf8toWChar(Str::StrCN::STRINGS[textIndex] % argv), -1, $msgRect, DT_CENTERBOTH)
end
def showMsgTxtboxA(textIndex, *argv)
  SendMessage.call($hWndText, WM_SETTEXT, 0, textIndex < 0 ? '' : Str::StrEN::STRINGS[textIndex] % argv)
end
def showMsgTxtboxW(textIndex, *argv)
  SendMessageW.call($hWndText, WM_SETTEXT, 0, textIndex < 0 ? '' : Str.utf8toWChar(Str::StrCN::STRINGS[textIndex] % argv))
end
def msgboxTxtA(textIndex, flag=MB_ICONASTERISK, *argv)
  API.msgbox(Str::StrEN::STRINGS[textIndex] % argv, flag)
end
def msgboxTxtW(textIndex, flag=MB_ICONASTERISK, *argv)
  API.msgbox(Str.utf8toWChar(Str::StrCN::STRINGS[textIndex] % argv), flag, MessageBoxW)
end
def readMemoryDWORD(address)
  ReadProcessMemory.call_r($hPrc, address, $buf, 4, 0)
  return $buf.unpack('l')[0]
end
def writeMemoryDWORD(address, dword)
  WriteProcessMemory.call_r($hPrc, address, [dword].pack('l'), 4, 0)
end
def callFunc(address) # execute the subroutine at the given address
  writeMemoryDWORD(MIDSPEED_ADDR, address-MIDSPEED_ADDR-4)
  SendMessage.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0)
  writeMemoryDWORD(MIDSPEED_ADDR, MIDSPEED_ORIG) # restore
end
def disposeRes() # when switching to a new TSW process, hDC and hPrc will be regenerated, and the old ones should be disposed of
  HookProcAPI.unhookK
  HookProcAPI.unhookM(true)
  DeleteObject.call($hBMP || 0)
  DeleteDC.call($hMemDC || 0)
  ReleaseDC.call($hWnd || 0, $hDC || 0)
  CloseHandle.call($hPrc || 0)
end
def preExit() # finalize
  DeleteObject.call($hPen || 0)
  DeleteObject.call($hPen2 || 0)
  DeleteObject.call($hGUIFont || 0)
  UnregisterHotKey.call(0, 0)
  disposeRes()
end
def raise_r(*argv)
  preExit() # ensure all resources disposed
  raise(*argv)
end
def checkTSWsize()
  GetClientRect.call_r($hWnd, $buf)
  w, h = $buf[8, 8].unpack('ll')
  return if w == $W and h == $H
  $W, $H = w, h

  $MAP_LEFT = readMemoryDWORD(MAP_LEFT_ADDR)
  $MAP_TOP = readMemoryDWORD(MAP_TOP_ADDR)
  $ITEMSBAR_LEFT = readMemoryDWORD($IMAGE6+OFFSET_CTL_LEFT)
  $ITEMSBAR_TOP = readMemoryDWORD($IMAGE6+OFFSET_CTL_TOP)
  $TILE_SIZE = readMemoryDWORD($IMAGE6+OFFSET_CTL_WIDTH)
# $MAP_LEFT, $MAP_TOP = ($W*0.225).round, ($H*0.057).round
# $ITEMSBAR_LEFT, $ITEMSBAR_TOP = ($W/44.5).round, ($H/2.21).round
# $TILE_SIZE = ($W*0.025 + $H*0.0375).round

  x1 = 2*$TILE_SIZE + $ITEMSBAR_LEFT
  x2 = x1 + $TILE_SIZE/2
  x3 = x1 + $TILE_SIZE
  y1 = $ITEMSBAR_TOP+$TILE_SIZE

  $itemsRect = [$ITEMSBAR_LEFT, $ITEMSBAR_TOP, x3, $ITEMSBAR_TOP+$TILE_SIZE*5].pack('l4')
  $OrbFlyRect = [[x1, $ITEMSBAR_TOP, x2, y1].pack('l4'), [x2, $ITEMSBAR_TOP, x3, y1].pack('l4'), [x1, $ITEMSBAR_TOP, x3, y1].pack('l4')] # left(0), right(1), none(-1)
  $msgRect = [0, $H-$MAP_TOP*2, $W-2, $H-$MAP_TOP].pack('l4')
end
def init()
  DeleteObject.call($hBMP || 0)
  DeleteDC.call($hMemDC || 0)
  ReleaseDC.call($hWnd || 0, $hDC || 0)
  CloseHandle.call($hPrc || 0)

  $hWnd = FindWindow.call(TSW_CLS_NAME, 0)
  $tID = GetWindowThreadProcessId.call($hWnd, $buf)
  $pID = $buf.unpack('L')[0]
  begin
    load('tswMPdebug.txt')
  rescue Exception
  end
  raise_r("Cannot find the TSW process and/or window. Please check if TSW V1.2 is currently running. tswMP has stopped.\n\nAs an advanced option, you can manually assign $pID, $tID and $hWnd in `tswMPdebug.txt'.") if $hWnd.zero? or $pID.zero? or $tID.zero?
  AttachThreadInput.call_r(GetCurrentThreadId.call_r, $tID, 1) # This is necessary for GetFocus to work: 
  #https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getfocus#remarks
  $hPrc = OpenProcess.call_r(PROCESS_VM_WRITE | PROCESS_VM_READ | PROCESS_VM_OPERATION, 0, $pID)
  tApp = readMemoryDWORD(TAPPLICATION_ADDR) # refer to `TApplication.RestoreTopMosts`
  $hWndTApp = readMemoryDWORD(tApp+OFFSET_OWNER_HWND) # it can also be achived by GetWindow($hWnd, GW_OWNER)
  $TTSW = readMemoryDWORD(TTSW_ADDR)
  edit8 = readMemoryDWORD($TTSW+OFFSET_EDIT8)
  $hWndText = readMemoryDWORD(edit8+OFFSET_HWND)
  $IMAGE6 = readMemoryDWORD($TTSW+OFFSET_IMAGE6)
  $hWndMemo = [] # reset as empty here and will be assigned later, because during prologue, these textboxes' hWnd are not assigned yet (a potential workaround is to `mov eax, TTSW10.TMemo1/2/3` and `call TWinControl.HandleNeeded`, but I'm lazy and it is really not worth the trouble)

  if Str.isCHN()
    alias :showMsg :showMsgW
    alias :showMsgTxtbox :showMsgTxtboxW
    alias :msgboxTxt :msgboxTxtW
  else
    alias :showMsg :showMsgA
    alias :showMsgTxtbox :showMsgTxtboxA
    alias :msgboxTxt :msgboxTxtA
  end

  showMsgTxtbox(9, $pID, $hWnd)

  checkTSWsize
  $hDC = GetDC.call_r($hWnd)
  $hMemDC = CreateCompatibleDC.call_r($hDC)
  $hBMP = CreateCompatibleBitmap.call_r($hDC, 40, 40)
  SelectObject.call_r($hDC, $hBr)
  SelectObject.call_r($hDC, $hPen)
  SelectObject.call_r($hMemDC, $hBMP)
  SetROP2.call_r($hDC, R2_XORPEN)
  SetBkColor.call($hDC, HIGHLIGHT_COLOR[-2])
  SetBkMode.call($hDC, 1) # transparent
  SetTextColor.call($hDC, HIGHLIGHT_COLOR.last)
end

$hGUIFont = CreateFontIndirect.call_r(DAMAGE_DISPLAY_FONT.pack('L5C8a32'))
$hSysFont = GetStockObject.call_r(SYSTEM_FONT)
$hBr = GetStockObject.call_r(DC_BRUSH)
$hPen = CreatePen.call_r(0, 3, HIGHLIGHT_COLOR[4])
$hPen2 = CreatePen.call_r(0, 3, HIGHLIGHT_COLOR[-2])

init
$time = 0
$x_pos = $y_pos = -1
RegisterHotKey.call_r(0, 0, MP_MODIFIER, MP_HOTKEY)

HookProcAPI.hookK
msgboxTxt(11)

while GetMessage.call($buf, 0, 0, 0) > 0
  # check if error to be processed within hook callback func
  HookProcAPI.handleHookExceptions

  msg = $buf.unpack(MSG_INFO_STRUCT)
  next if msg[1] != WM_HOTKEY

  init if IsWindow.call($hWnd).zero? # reinit if TSW has quitted
  time = msg[4]
  diff = time - $time
  $time = time

  if diff < INTERVAL_QUIT # hold
    showMsgTxtbox(-1)
    break
  elsif diff < INTERVAL_REHOOK # twice
    showMsgTxtbox(-1)
    HookProcAPI.rehookK
    msgboxTxt(12)
  end
end
preExit
msgboxTxt(13)
