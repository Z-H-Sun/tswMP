require './connectivity'
require 'win32/api'
include Win32
GET_MESSAGE = API.new('GetMessage','PLLL','L', 'user32')
SEND_MESSAGE = API.new('SendMessage', 'LLLP', 'L', 'user32')
GET_RECT = API.new('GetClientRect','LP','L', 'user32')
FILL_RECT = API.new('FillRect', 'LSL', 'L', 'user32')
OPEN_PROCESS = API.new('OpenProcess', 'LLL', 'L', 'kernel32')
READ_PROCESS = API.new('ReadProcessMemory', 'LLPLL', 'L', 'kernel32')
WRITE_PROCESS = API.new('WriteProcessMemory', 'LLPLL', 'L', 'kernel32')
GET_TID = API.new('GetCurrentThreadId', 'V', 'I', 'kernel32')
GET_PID = API.new('GetWindowThreadProcessId', 'LP', 'L', 'user32')
ATT_INPUT = API.new('AttachThreadInput', 'III', 'I', 'user32')
MESSAGE_BOX = API.new('MessageBox', 'LSSI', 'L', 'user32')
ISWINDOW = API.new('IsWindow', 'L', 'L', 'user32')
FIND_WIN = API.new('FindWindowEx', 'LLSL', 'L', 'user32')
DRAW_TEXT = API.new('DrawText', 'LSIPL', 'L', 'user32') # ansi
DRAW_TEXT_W = API.new('DrawTextW', 'LSIPL', 'L', 'user32') # unicode
POLY_LINE = API.new('Polyline', 'LSI', 'L', 'gdi32') # ansi
BIT_BLT = API.new('BitBlt', 'LLLLLLLLL', 'L', 'gdi32')
INVAL_RECT = API.new('InvalidateRect','LPL','L', 'user32')
GET_FOC = API.new('GetFocus','V','L', 'user32')
GET_FGWIN = API.new('GetForegroundWindow', 'V', 'L', 'user32')
SET_FGWIN = API.new('SetForegroundWindow', 'L', 'L', 'user32')
GET_POS = API.new('GetCursorPos','P','L', 'user32')
SRC_CLI = API.new('ScreenToClient','LP','L', 'user32')
GET_DC = API.new('GetDC', 'L', 'L', 'user32')
GET_OBJ = API.new('GetStockObject', 'L', 'L', 'gdi32')
SEL_OBJ = API.new('SelectObject', 'LL', 'L', 'gdi32')
SET_COLOR = API.new('SetDCBrushColor', 'LL', 'L', 'gdi32')

WM_SETTEXT = 0xC
WM_GETTEXT = 0xD
WM_COMMAND = 0x111
WM_HOTKEY = 0x312
VK_LWIN = 0x5B
VK_RWIN = 0x5C
VK_LEFT = 0x25
VK_UP = 0x26
VK_RIGHT = 0x27
VK_DOWN = 0x28
DC_BRUSH = 18
PROCESS_VM_WRITE = 0x20
PROCESS_VM_READ = 0x10
PROCESS_VM_OPERATION = 0x8
MB_ICONEXCLAMATION = 0x30
MB_ICONASTERISK = 0x40
MB_SETFOREGROUND = 0x10000
# Ternary Raster Operations
RASTER_DPO = 0xFA0089
HIGHLIGHT_COLOR = [0x22AA22, 0x22AAAA, 0x2222FF, 0xC07F40, 0x99CCAA] # OK, suspicious, no-go, item, polyline (note: not RGB, but rather BGR)
case [''].pack('p').size
when 4 # 32-bit ruby
  MSG_INFO_STRUCT = 'L7'
when 8 # 64-bit
  MSG_INFO_STRUCT = 'Q4L3'
else
  raise 'Unsupported system or ruby version (neither 32-bit or 64-bit).'
end

BASE_ADDRESS = 0x400000
OFFSET_XPOS = 0xb86a0
OFFSET_YPOS = 0xb86a4
OFFSET_FLOOR = 0xb8698
OFFSET_MAP = 0xb8934
OFFSET_EVENTFLAG = 0x8c5ac
OFFSET_SACREDSHIELD = 0xb872c
MIDSPEED_MENUID = 33 # The idea is to hijack the midspeed menu
MIDSPEED_ADDR = 0x7f46d + BASE_ADDRESS # so once click event of that menu item is triggered, arbitrary code can be executed
MIDSPEED_ORIG = "\x6F\0\0\0" # original bytecode (call TTSW10.speedmiddle@0x47f4e0)
HELP_MENUID = 54 # similar with above
HELP_ADDR = 0x7d2d8 + BASE_ADDRESS # now the help menu is replaced by syokidata2 subroutine (refresh event)
REFRESH_ADDR = 0x54de8 + BASE_ADDRESS # TTSW10.syokidata2
REFRESH_XYPOS_ADDR = 0x42c38 + BASE_ADDRESS # TTSW10.mhyouji
TIMER1_ADDR = 0x43120 + BASE_ADDRESS
MOVE_ADDR = [0x484c58, 0x484c04, nil, 0x484bb0, 0x484b5c] # down / right / left / up
ITEMS = {'name' => ['OrbOfHero', 'OrbWisdom', 'OrbFlight', 'Elixir', 'Mattock', 'DestrBall', 'WarpWing', 'AscentWing',
         'DescntWing', 'SnowCryst', 'MagicKey', 'SupMattock'], 'position' => [0, 1, 2, 4, 5, 6, 7, 8, 9, 11, 12, 13], 'address' =>
         [0x4b86cc, 0x4b86d0, 0x4b86d4, 0x4b86dc, 0x4b86e0, 0x4b86e4, 0x4b86e8, 0x4b86ec, 0x4b86f0, 0x4b86f8, 0x4b86fc, 0x4b8700],
         'key' => [72, 78, [VK_LEFT,VK_DOWN, VK_RIGHT,VK_UP], 87, 80, 66, 74, 85, 68, 73, 75, 81], # H N [wasd] W P B J U D I K Q
         'event_addr' => [0x480f60, 0x48198c, [0x481e80, 0x481f59, 0x44ed1c, 0x44ed94, 0x44eaf4], 0x48201c, 0x482128, 0x482234,
         0x482340, 0x48244c, 0x482558, 0x482664, 0x482770, 0x48287c, 0x450ba0]} # imgXXwork; the last is Button38Click (Button_Use)

MODIFIER = 0
KEY = 118
INTERVAL_REHOOK = 450 # the interval for rehook (in msec)
INTERVAL_QUIT = 50 # for quit (in msec)
$buf = "\0" * 256
$autoRefresh = true

module Win32
  class API
    def self.msgbox(text, flag=MB_ICONASTERISK)
      if ISWINDOW.call($hWnd || 0).zero?
        $hWnd = 0 # if the window has gone, create a system level msgbox
      else
        SET_FGWIN.call($hWnd)
      end
      return MESSAGE_BOX.call($hWnd, text[0, 1023], 'tswMP', flag | MB_SETFOREGROUND) # can't show too long message
    end
    def call_r(*argv) # provide more info if a win32api returns null
      r = call(*argv)
      return r unless r.zero?
      err = '0x%04X' % API.last_error
      case function_name
      when 'WriteProcessMemory', 'ReadProcessMemory'
        reason = "Cannot read from / write to the TSW process. Please check if TSW V1.2 is running with pID=#{$pID} and if you have proper permissions."
      when 'OpenProcess'
        reason = "Cannot open the TSW process for writing. Please check if TSW V1.2 is running with pID=#{$pID} and if you have proper permissions."
      when 'RegisterHotKey'
        reason = "Cannot register hotkey. It might be currently occupied by other processes or another instance of tswMP. Please close them to avoid confliction. Default: F7 (0+ 118); current: (#{MODIFIER}+ #{KEY}). As an advanced option, you can manually assign `MODIFIER` and `KEY` in `tswMPdebug.txt'."
      else
        reason = "This is a fatal error. That is all we know."
      end
      raise("Err #{err} when calling `#{effective_function_name}'@#{dll_name}.\n#{reason} tswMP has stopped. Details are as follows:\n\nPrototype='#{prototype.join('')}', ReturnType='#{return_type}', ARGV=#{argv.inspect}")
    end
  end
end
# https://github.com/ffi/ffi/issues/283#issuecomment-24902987
# https://github.com/undees/yesbut/blob/master/2008-11-13/hook.rb
module HookProcAPI
  SetWindowsHookEx = API.new('SetWindowsHookEx', 'IKII', 'I', 'user32')
  UnhookWindowsHookEx = API.new('UnhookWindowsHookEx', 'I', 'I', 'user32')
  CallNextHookEx = API.new('CallNextHookEx', 'ILLL', 'I', 'user32')
  GetClassName = API.new('GetClassName', 'LPL', 'L', 'user32')
  ClipCursor = API.new('ClipCursor', 'S', 'I', 'user32')
  GetModuleHandle = API.new('GetModuleHandle', 'I', 'I', 'kernel32')
  RtlMoveMemory = API.new('RtlMoveMemory', 'PLI', 'I', 'kernel32')

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
  @access = nil # the destination is accessible?
  @flying = nil # currently using OrbOfFly; active
  @error = nil # exception within hook callback function
  @lastArrow = 0 # which arrowkey pressed previously? -1: none; 0: left; 1: right

  module_function
  def handleHookExceptions() # exception should not be raised until callback returned
    return if @error.nil?
    preExit
    raise @error
  end
  def finally # code block wrapper
    yield
  end
  def isButtonFocused()
    len = GetClassName.call(GET_FOC.call, $buf, 256)
    return ($buf[0, len] == 'TButton')
  end
  def isInEvent()
    READ_PROCESS.call_r($hPrc, OFFSET_EVENTFLAG+BASE_ADDRESS, $buf, 4, 0)
    result = !($buf.unpack('L')[0].zero?)
    #SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, 'tswMP: Please wait for game event to complete...') if result
    return result
  end
  def abandon()
    unhookM
    @winDown = false
    @flying = nil
  end
  def callFunc(address) # execute the subroutine at the given address
    WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [address-MIDSPEED_ADDR-4].pack('l'), 4, 0)
    SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0)
    WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, 0) # restore
  end
  def _msHook(nCode, wParam, lParam)
    finally do
      break if nCode.to_i < 0 # do not process
      case wParam
      when WM_LBUTTONDOWN, WM_RBUTTONDOWN # teleportation
        if isButtonFocused then abandon(); break end
        break if $x_pos < 0 or $y_pos < 0 or isInEvent
        cheat = (wParam == WM_RBUTTONDOWN)
        if cheat
          x, y = $x_pos, $y_pos
        else
          break unless @access
          y, x = Connectivity.index.divmod(11)
        end
        WRITE_PROCESS.call_r($hPrc, BASE_ADDRESS+OFFSET_XPOS, [x].pack('l'), 4, 0)
        WRITE_PROCESS.call_r($hPrc, BASE_ADDRESS+OFFSET_YPOS, [y].pack('l'), 4, 0)

        WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\x53", 1, 0) # TIMER1TIMER push ebx (re-enable)
        callFunc(REFRESH_XYPOS_ADDR) if $autoRefresh # TTSW10.mhyouji (only refresh braveman position; do not refresh whole map)

        unless @access == 0 or cheat
          callFunc(MOVE_ADDR[@access+2])
        end

        SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, (cheat ? '[CHEAT] ' : '') + 'tswMP: Teleported to (%X,%X). Press a key or move mouse to continue.' % [x, y])
        checkTSWsize()
        break
      when WM_MOUSEMOVE
        if isButtonFocused then abandon(); break end
      else
        break
      end
#     buf = "\0"*24
#     RtlMoveMemory.call(buf, lParam, 24)
#     buf = buf.unpack('L*')
      # the point returned in lparam is DPI-aware, useless here
      # https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/ns-winuser-msllhookstruct#members
      GET_POS.call_r($buf)
      sx, sy = $buf.unpack('ll')
      SRC_CLI.call_r($hWnd, $buf)
      x, y = $buf.unpack('ll')
      dx = sx - x; dy = sy - y
      checkTSWsize()
      left = $MAP_LEFT + dx; top = $MAP_TOP + dy; size = $SIZE * 11
      ClipCursor.call([left, top, left+size, top+size].pack('l4')) # confine cursor pos within map

      x_pos = ((x - $MAP_LEFT) / $SIZE).floor
      y_pos = ((y - $MAP_TOP) / $SIZE).floor

      break if (x_pos == $x_pos and y_pos == $y_pos) or isInEvent # same pos

      WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\x53", 1, 0) # TIMER1TIMER push ebx (re-enable)
      callFunc(TIMER1_ADDR) # elicit TIMER1TIMER
      if x_pos < 0 or x_pos > 10 or y_pos < 0 or y_pos > 10 # outside
        SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')
        $x_pos = $y_pos = -1 # cancel preview
        break
      end
      $x_pos = x_pos; $y_pos = y_pos
      x_left = $MAP_LEFT + $SIZE*x_pos
      y_top = $MAP_TOP + $SIZE*y_pos

READ_PROCESS.call_r($hPrc, OFFSET_FLOOR+BASE_ADDRESS, $buf, 4, 0)
floor = $buf.unpack('L')[0]
Connectivity.check_mag = false
if floor > 40
  READ_PROCESS.call_r($hPrc, OFFSET_SACREDSHIELD+BASE_ADDRESS, $buf, 4, 0)
  Connectivity.check_mag = true if $buf.unpack('l')[0].zero?
end
READ_PROCESS.call_r($hPrc, OFFSET_MAP+floor*123+2+BASE_ADDRESS, $buf, 121, 0)
$mapTiles = $buf.unpack('C121')
READ_PROCESS.call_r($hPrc, OFFSET_XPOS+BASE_ADDRESS, $buf, 4, 0)
ox = $buf.unpack('L')[0]
READ_PROCESS.call_r($hPrc, OFFSET_YPOS+BASE_ADDRESS, $buf, 4, 0)
oy = $buf.unpack('L')[0]
@access = Connectivity.main(ox, oy, x_pos, y_pos)
if @access
  c_ind = 0
else
  c_ind = 2
end
cpt = Connectivity.points.size >> 1
SET_COLOR.call($hDC, HIGHLIGHT_COLOR[c_ind])
# it is possible that when [WIN] key is released (and thus `unhookM` is called), `_msHook` is still running; in this case, do not do the following things:
      SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, 'tswMP: Press alphabet/arrow key to use items' + (@access ? (' or click mouse to teleport to (%X,%X).' % [x_pos, y_pos]) : '.')) if @hmhook
      BIT_BLT.call($hDC, x_left, y_top, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPO) if @hmhook
POLY_LINE.call($hDC, Connectivity.points.pack('l*'), cpt) if @hmhook and @access and cpt > 1

      WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\xc3", 1, 0) if @hmhook # TIMER1TIMER ret (disable; freeze)
    end
    return 0 if nCode == 'init' # upon pressing [WIN] without mouse move
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
      if key == VK_LWIN or key == VK_RWIN
        alphabet = false # alphabet key pressed?
        arrow = false # arrow key pressed?
      else
        break unless @winDown and wParam == WM_KEYDOWN

        alphabet = ITEMS['key'].index(key) # which item chosen?
        alphabet = nil unless @itemAvail.include?(alphabet) # you must have that item
        arrow = ITEMS['key'][2].index(key) # up/downstairs?
        arrow = nil unless @itemAvail.include?(2) # you must have orbOfFly
        break if alphabet.nil? and arrow.nil?
      end
      hWnd = GET_FGWIN.call
      if hWnd != $hWnd # TSW is not active
        len = GetClassName.call(hWnd, $buf, 256)
        if $buf[0, len]!='TTSW10'
          abandon()
          break
        end
        init # if another TSW is active now
      end

      break if isButtonFocused and !@flying # maybe in the middle of an event

      block = true
      if wParam == WM_KEYDOWN
        break if isInEvent
        if alphabet and !@flying
          @winDown = false # de-active; restore
          unhookM

          callFunc(ITEMS['event_addr'][alphabet]) # imgXXwork = click that item
          if isButtonFocused # can use item successfully (so the don't-use button is focused now)
            callFunc(ITEMS['event_addr'][12]) if alphabet > 2 # buttonUseClick = click 'Use' (excluding OrbOfHero/Wisdom)
          else
            SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Could not use #{ITEMS['name'][alphabet]}!")
          end

        elsif arrow
          if @flying # already flying: arrow keys=up/downstaris
            arrow >>= 1
            callFunc(ITEMS['event_addr'][2][arrow+2]) # click Down/Up
            
            SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, @flying)
            if @lastArrow != arrow
              INVAL_RECT.call($hWnd, [(@lastArrow>0 ? 5 : 4)*$SIZE/2+$ORIGIN_X, $ORIGIN_Y, (@lastArrow.zero? ? 5 : 6)*$SIZE/2+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), 0)
              sleep(0.05) if @lastArrow < 0
              DRAW_TEXT_W.call($hDC, ["\xBC\x25", "\xB2\x25"][arrow], 1, [(4+arrow)*$SIZE/2+$ORIGIN_X, $ORIGIN_Y, (5+arrow)*$SIZE/2+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), arrow << 1)
              BIT_BLT.call($hDC, (4+arrow)*$SIZE/2+$ORIGIN_X, $ORIGIN_Y, $SIZE/2, $SIZE, $hDC, 0, 0, RASTER_DPO)
              @lastArrow = arrow
            end
          else
            unhookM
            WRITE_PROCESS.call_r($hPrc, ITEMS['event_addr'][2][1], "\x90"*6, 6, 0) if arrow == 3 # bypass OrbOfFly restriction (JNZ->NOP)
            callFunc(ITEMS['event_addr'][2][0]) # Image4Click (OrbOfFly)
            WRITE_PROCESS.call_r($hPrc, ITEMS['event_addr'][2][1], "\x0F\x85\xA2\0\0\0", 6, 0) if arrow == 3 # restore (JNZ)
            if isButtonFocused # can use OrbOfFly successfully (so the up/down/ok button is focused now)
              @flying = (arrow == 3 ? '[CHEAT] ' : '') + 'tswMP: Use arrow keys to fly up/down; release [WIN] to confirm.'
              SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, @flying)
              @lastArrow = -1
              sleep(0.05)
              DRAW_TEXT_W.call($hDC, "\xBC\x25\xB2\x25", 2, [2*$SIZE+$ORIGIN_X, $ORIGIN_Y, 3*$SIZE+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), 0) # U+25BC/25B2 = down/up triangle
              SET_COLOR.call($hDC, HIGHLIGHT_COLOR[arrow == 3 ? 2 : 0])
              BIT_BLT.call($hDC, 2*$SIZE+$ORIGIN_X, $ORIGIN_Y, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPO)
            else
              @winDown = false
              len = SEND_MESSAGE.call($hWndText, WM_GETTEXT, 256, $buf)
              SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Could not use #{ITEMS['name'][2]}!") if len < 31 or len > 64 # otherwise, it's because "You must be near the stairs to fly!"
            end
          end
        elsif !@winDown # only trigger at the first time
          @winDown = true
          checkTSWsize
          hookM

          @itemAvail = []
          for i in 0..11 # check what items you have
            READ_PROCESS.call_r($hPrc, ITEMS['address'][i], $buf, 4, 0)
            next if $buf.unpack('L')[0] < 1
            @itemAvail << i
            y = ITEMS['position'][i]
            x, y = y%3, y/3
            x = x * $SIZE + $ORIGIN_X
            y = y * $SIZE + $ORIGIN_Y
            if i == 2
              DRAW_TEXT_W.call($hDC, "\xBC\x25\xB2\x25", 2, [x, y, x+$SIZE, y+$SIZE].pack('l4'), 0) # U+25BC/25B2 = down/up triangle
            else
              DRAW_TEXT.call($hDC, ITEMS['key'][i].chr, 1, [x, y, x+$SIZE, y+$SIZE].pack('l4'), 0)
            end
            SET_COLOR.call($hDC, HIGHLIGHT_COLOR[3])
            BIT_BLT.call($hDC, x, y, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPO)
          end
          _msHook('init', WM_MOUSEMOVE, 0) # upon pressing [WIN] without mouse move
        end
      elsif wParam == WM_KEYUP # (alphabet == false; arrow == false)
        unless @winDown then block = false; break end # if somehow [WIN] key down signal is not intercepted, then do not block (otherwise [WIN] key will always be down)

        callFunc(ITEMS['event_addr'][2][4]) if @flying # click OK
        abandon
      end
    end
    return 1 if block # block input
    return CallNextHookEx.call(@hkhook, nCode, wParam, lParam)
  rescue Exception => @error
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
    abandon()
    hookK
  end
  def hookM
    return false if @hmhook
    @hmhook = SetWindowsHookEx.call_r(WH_MOUSE_LL, MouseProc, @hMod, 0)
    return true
  end
  def unhookM
    return false unless @hmhook
    UnhookWindowsHookEx.call(@hmhook)
    @hmhook = nil

    WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\x53", 1, 0) # TIMER1TIMER push ebx (restore; re-enable)
    $x_pos = $y_pos = -1
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')
    INVAL_RECT.call($hWnd, $itemsRect, 0) # redraw item bar
    ClipCursor.call(nil) # do not confine cursor range
  end
  private :_msHook
  private :_keyHook
end

def preExit() # finalize
  HookProcAPI.unhookK
  HookProcAPI.unhookM
  WRITE_PROCESS.call($hPrc, HELP_ADDR, "\x53\x8B\xD8\x6A\x05\x68", 7, 0) # restore the function of the help menu
  API.new('DeleteDC', 'L', 'L', 'gdi32').call($hDC)
  API.new('DeleteObject', 'L', 'L', 'gdi32').call_r($hPen)
  API.new('UnregisterHotKey', 'LI', 'L', 'user32').call(0, 0)
  API.new('CloseHandle', 'L', 'L', 'kernel32').call($hPrc)
end
def menuRefresh() # change the function of the help menu to "refresh"
  flag = $autoRefresh ? 0xc3 : 0x90 # how this bytecode is set won't affect the outcome of asm code
  # instead, this flag can tell tswKai if $autoRefresh is turned on/off here
  WRITE_PROCESS.call_r($hPrc, HELP_ADDR, [0xe8, REFRESH_ADDR-HELP_ADDR-5, flag, 0xc3].pack('clcc'), 7, 0) # Help2Click -> call 454de8; ret; # syokidata2
end
def checkTSWsize()
  GET_RECT.call_r($hWnd, $buf)
  w, h = $buf[8, 8].unpack('ll')
  return if w == $W and h == $H
  $W, $H = w, h
  $MAP_LEFT, $MAP_TOP = ($W*0.225).round, ($H*0.057).round # also in: dword_48c578; dword_48c57c
  $ORIGIN_X, $ORIGIN_Y = ($W/44.5).round, ($H/2.21).round
  $SIZE = ($W*0.025 + $H*0.0375).round
  $itemsRect = [$ORIGIN_X, $ORIGIN_X, $ORIGIN_X+$SIZE*3, $ORIGIN_Y+$SIZE*5].pack('l4')
end
def init()
  $hWnd = FIND_WIN.call(0, 0, 'TTSW10', 0)
  $pID = "\0\0\0\0"
  $tID = GET_PID.call($hWnd, $pID)
  $pID = $pID.unpack('L')[0]
  begin
    load('tswMPdebug.txt')
  rescue Exception
  end
  raise("Cannot find the TSW process and/or window. Please check if\nTSW V1.2 is currently running. tswMP has stopped.\n\nAs an advanced option, you can manually assign $pID, $tID\nand $hWnd in `tswMPdebug.txt'.") if $hWnd.zero? or $pID.zero? or $tID.zero?
  ATT_INPUT.call_r(GET_TID.call_r, $tID, 1) # This is necessary for GetFocus to work: 
  #https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getfocus#remarks
  $hPrc = OPEN_PROCESS.call_r(PROCESS_VM_WRITE | PROCESS_VM_READ | PROCESS_VM_OPERATION, 0, $pID)
  $hWndText = 0
  width = 0
  while width < 600 # find the status bar, whose width is always larger than 600 (to avoid mistakenly finding other textbox window)
    $hWndText = FIND_WIN.call($hWnd, $hWndText, 'TEdit', 0)
    if $hWndText.zero?
      API.msgbox("tswMP failed to find the status bar at the bottom of the TSW window. Please check whether this is really a TSW process?\n\n\tPID=#{$pID}, hWND=#{$hWnd}\n\nHowever, tswMP will continue running anyway.", MB_ICONEXCLAMATION)
      break
    end
    GET_RECT.call_r($hWndText, $buf)
    width = $buf.unpack('l4')[2]
  end
  SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Started. Found TSW running - pID=#{$pID}; hWnd=0x#{$hWnd.to_s(16).upcase}")

  checkTSWsize
  $hDC = GET_DC.call_r($hWnd)
  SEL_OBJ.call_r($hDC, $hBr)
  SEL_OBJ.call_r($hDC, $hPen)
  menuRefresh
end

$hBr = GET_OBJ.call_r(DC_BRUSH)
$hPen = API.new('CreatePen', 'IIL', 'L', 'gdi32').call_r(0, 3, HIGHLIGHT_COLOR[4])
init
$time = 0
$x_pos = $y_pos = -1
API.new('RegisterHotKey', 'LILL', 'L', 'user32').call_r(0, 0, MODIFIER, KEY)


HookProcAPI.hookK
API.msgbox("""tswMovePoint is running. Try pressing WinKey!
When WinKey down:
1) Move mouse to select a destination to teleport;
2) Press specified alphabet key to use an item;
3) Press left/right arrow key to use orb of flying;
Then release WinKey to confirm. Other functions:

F7 = Toggle auto-refresh (now is #{$autoRefresh ? "on" : "off"});
F7 twice = Rehook keyboard if WinKey stops working;
F1 = Manually refresh TSW status;
Hold F7 = Quit tswMovePoint.""")

while true
  GET_MESSAGE.call($buf, 0, 0, 0)
  # check if error to be processed within hook callback func
  HookProcAPI.handleHookExceptions

  # 32 bit? 64 bit? 0x312 = hotkey event
  msg = $buf.unpack(MSG_INFO_STRUCT)
  next if msg[1] != WM_HOTKEY
  
  init if ISWINDOW.call($hWnd).zero? # reinit if TSW has quitted
  time = msg[4]
  diff = time - $time
  $time = time

  if GET_FGWIN.call == $hWnd # only respond when TSW is focused
    $autoRefresh = ! $autoRefresh
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, 'tswMP: You turned TSW auto-fresh ' + ($autoRefresh ? 'on.' : 'off. You can press F1 to refresh manually.'))
    menuRefresh
  end
  if diff < INTERVAL_QUIT # hold
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')
    break
  elsif diff < INTERVAL_REHOOK # twice
    HookProcAPI.rehookK
    API.msgbox('Keyboard Re-hooked.')
  end
end
preExit
API.msgbox('tswMovePoint has stopped.')
