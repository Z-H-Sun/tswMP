require 'win32/api'
include Win32
GET_MESSAGE = API.new('GetMessage','PLLL','L', 'user32')
SEND_MESSAGE = API.new('SendMessage', 'LLLP', 'L', 'user32')
GET_RECT = API.new('GetClientRect','LP','L', 'user32')
FILL_RECT = API.new('FillRect', 'LPL', 'L', 'user32')
OPEN_PROCESS = API.new('OpenProcess', 'LLL', 'L', 'kernel32')
READ_PROCESS = API.new('ReadProcessMemory', 'LLPLP', 'L', 'kernel32')
WRITE_PROCESS = API.new('WriteProcessMemory', 'LLPLP', 'L', 'kernel32')
GET_TID = API.new('GetCurrentThreadId', 'V', 'I', 'kernel32')
GET_PID = API.new('GetWindowThreadProcessId', 'LP', 'L', 'user32')
LST_ERR = API.new('GetLastError', 'V', 'L', 'kernel32')
ATT_INPUT = API.new('AttachThreadInput', 'III', 'I', 'user32')
MESSAGE_BOX = API.new('MessageBox', 'LPPI', 'L', 'user32')
ISWINDOW = API.new('IsWindow', 'L', 'L', 'user32')
FIND_WIN = API.new('FindWindowEx', 'LLPL', 'L', 'user32')
DRAW_TEXT = API.new('DrawText', 'LPIPL', 'L', 'user32')
BIT_BLT = API.new('BitBlt', 'LLLLLLLLL', 'L', 'gdi32')
INVAL_RECT = API.new('InvalidateRect','LPL','L', 'user32')
GET_FOC = API.new('GetFocus','V','L', 'user32')
GET_POS = API.new('GetCursorPos','P','L', 'user32')
SRC_CLI = API.new('ScreenToClient','LP','L', 'user32')
GET_DC = API.new('GetDC', 'L', 'L', 'user32')
GET_OBJ = API.new('GetStockObject', 'L', 'L', 'gdi32')
SEL_OBJ = API.new('SelectObject', 'LL', 'L', 'gdi32')
SET_COLOR = API.new('SetDCBrushColor', 'LL', 'L', 'gdi32')

WM_SETTEXT = 0xC
WM_GETTEXT = 0xD
WM_COMMAND = 0x111
DC_BRUSH = 18
PROCESS_VM_WRITE = 0x20
PROCESS_VM_READ = 0x10
PROCESS_VM_OPERATION = 0x8
MB_ICONINFORMATION = 0x40
MB_ICONEXCLAMATION = 0x30
# Ternary Raster Operations
RASTER_DPO = 0xFA0089
RASTER_DPNO = 0xAF0229

BASE_ADDRESS = 0x400000
OFFSET_XPOS = 0xb86a0
OFFSET_YPOS = 0xb86a4
MIDSPEED_MENUID = 33 # The idea is to hijack the midspeed menu
MIDSPEED_ADDR = 0x7f46d + BASE_ADDRESS # so once click event of that menu item is triggered, arbitrary code can be executed
MIDSPEED_ORIG = "\x6F\0\0\0" # original bytecode (call TTSW10.speedmiddle@0x47f4e0)
HELP_MENUID = 54 # similar with above
HELP_ADDR = 0x7d2d8 + BASE_ADDRESS # now the help menu is replaced by syokidata2 subroutine (refresh event)
REFRESH_ADDR = 0x54de8 + BASE_ADDRESS # TTSW10.syokidata2
TIMER1_ADDR = 0x43120 + BASE_ADDRESS
ITEMS = {'name' => ['OrbOfHero', 'OrbOfWis', 'OrbOfFly', 'Elixir', 'Mattock', 'DestructBall', 'SpaceWing', 'UpperWing',
         'LowerWing', 'SnowFlake', 'MagicKey', 'SuperMattock'], 'position' => [0, 1, 2, 4, 5, 6, 7, 8, 9, 11, 12, 13], 'address' =>
         [0x4b86cc, 0x4b86d0, 0x4b86d4, 0x4b86dc, 0x4b86e0, 0x4b86e4, 0x4b86e8, 0x4b86ec, 0x4b86f0, 0x4b86f8, 0x4b86fc, 0x4b8700],
         'key' => [72, 78, [37, 39], 87, 80, 66, 74, 85, 68, 73, 75, 81], # H N [wasd] W P B J U D I K Q
         'event_addr' => [0x480f60, 0x48198c, [0x481e80, 0x481f59, 0x44ed1c, 0x44ed94, 0x44eaf4], 0x48201c, 0x482128, 0x482234,
         0x482340, 0x48244c, 0x482558, 0x482664, 0x482770, 0x48287c, 0x450ba0]} # imgXXwork; the last is Button38Click (Button_Use)

MODIFIER = 0
KEY = 118
INTERVAL_REHOOK = 450 # the interval for rehook (in msec)
INTERVAL_QUIT = 50 # for quit (in msec)
$autoRefresh = true

module Win32
  class API
    def call_r(*argv) # provide more info if a win32api returns null
      r = call(*argv)
      return r unless r.zero?
      err = '0x' + LST_ERR.call.to_s(16).upcase
      case function_name
      when 'WriteProcessMemory', 'ReadProcessMemory'
        reason = "Cannot read from / write to the TSW process. Please check if TSW V1.2 is\nrunning with pID=#{$pID} and if you have proper permissions.\n"
      when 'OpenProcess'
        reason = "Cannot open the TSW process for writing. Please check if\nTSW V1.2 is running with pID=#{$pID} and if you have proper\npermissions. "
      when 'RegisterHotKey'
        reason = "Cannot register hotkey. It might be currently occupied by\nother processes or another instance of tswMP. Please close\nthem to avoid confliction. Default: F7 (0+ 118); current:\n(#{MODIFIER}+ #{KEY}). As an advanced option, you can manually assign\nMODIFIER and KEY in `tswMPdebug.txt'.\n\n"
      else
        reason = "This is a fatal error. That is all we know. "
      end
      raise("Err #{err} when calling `#{effective_function_name}'@#{dll_name}.\n#{reason}tswMP has stopped. Details are as follows:\n\nPrototype='#{prototype.join('')}', ReturnType='#{return_type}', ARGV=#{argv.inspect}")
    end
  end
end
# https://github.com/ffi/ffi/issues/283#issuecomment-24902987
# https://github.com/undees/yesbut/blob/master/2008-11-13/hook.rb
module HookProcAPI
  SetWindowsHookEx = API.new('SetWindowsHookEx', 'IKII', 'I', 'user32')
  UnhookWindowsHookEx = API.new('UnhookWindowsHookEx', 'I', 'I', 'user32')
  CallNextHookEx = API.new('CallNextHookEx', 'ILLL', 'I', 'user32')
  GetForegroundWindow = API.new('GetForegroundWindow', 'V', 'L', 'user32')
  GetClassName = API.new('GetClassName', 'LPL', 'L', 'user32')
  GetModuleHandle = API.new('GetModuleHandle', 'I', 'I', 'kernel32')
  RtlMoveMemory = API.new('RtlMoveMemory', 'PLI', 'I', 'kernel32')

  WH_KEYBOARD_LL = 13
  WH_MOUSE_LL = 14
  WM_KEYDOWN = 0x100
  WM_KEYUP = 0x101
  WM_MOUSEMOVE = 0x200
  VK_LWIN = 0x5B
  VK_RWIN = 0x5C
  @hMod = GetModuleHandle.call_r(0)
  @hkhook = nil
  @hmhook = nil
  @itemAvail = [] # the items you have
  @winDown = false # [WIN] pressed; active
  @flying = false # currently using OrbOfFly; active
  @error = nil # exception within hook callback function
  @itemsRect = [0] * 4 # the whole items region
  @lastArrow = 0 # which arrowkey pressed previously? -1: none; 0: left; 1: right
  class << self
    attr_writer :itemsRect
    attr_accessor :itemsRect
  end
  def self.handleHookExceptions() # exception should not be raised until callback returned
    return if @error.nil?
    preExit
    raise @error
  end
  def self.finally # block wrapper
    yield
  end
  def self.isButtonFocused()
    buf = ' '*16
    GetClassName.call(GET_FOC.call, buf, 16)
    return (buf[0, 7] == 'TButton')
  end
  def self._msHook(nCode, wParam, lParam)
    finally do
      break if wParam != WM_MOUSEMOVE
#     buf = "\0"*24
#     RtlMoveMemory.call(buf, lParam, 24)
#     buf = buf.unpack('L*')
      # the point returned in lparam is DPI-aware, useless here
      # https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/ns-winuser-msllhookstruct#members
      xy = "\0"*8
      GET_POS.call_r(xy)
      SRC_CLI.call_r($hWnd, xy)
      x, y = xy.unpack('ll')
      x_pos = ((x - $W*0.225) / $SIZE).floor
      y_pos = ((y - $H*0.057) / $SIZE).floor

      break if x_pos == $x_pos and y_pos == $y_pos # same pos

      WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\x53", 1, '    ') # TIMER1TIMER push ebx (re-enable)
      WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [TIMER1_ADDR-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # call TIMER1TIMER
      SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0) # refresh once using timer1
      WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore
      if x_pos < 0 or x_pos > 10 or y_pos < 0 or y_pos > 10 # outside
        SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')
        $x_pos = $y_pos = -1 # cancel preview
        break
      end
      $x_pos = x_pos; $y_pos = y_pos
      x_left = ($W*0.225 + $SIZE*x_pos).round
      y_top = ($H*0.057 + $SIZE*y_pos).round
      SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Teleport to (#{x_pos.to_s(16).upcase},#{y_pos.to_s(16).upcase})? Release [WIN] to confirm.")
      BIT_BLT.call($hDC, x_left, y_top, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPO)

      WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\xc3", 1, '    ') # TIMER1TIMER ret (disable; freeze)
    end
    return 0 if nCode == 'init' # upon pressing [WIN] without mouse move
    return CallNextHookEx.call(@hmhook, nCode, wParam, lParam)
  # no need to "rescue" here since the exceptions could be handled in _keyHook
  end
  def self._keyHook(nCode, wParam, lParam)
    # 'LLL': If the prototype is set as 'LLP', the size of the pointer could not be correctly assigned
    # Therefore, the address of the pointer is retrieved instead, and RtlMoveMemory is used to get the pointer data
    buf = "\0"*20
    RtlMoveMemory.call(buf, lParam, 20)
    buf = buf.unpack('L*')
    block = false # block input?
    finally do
      if buf[0] == VK_LWIN or buf[0] == VK_RWIN
        alphabet = false # alphabet key pressed?
        arrow = false # arrow key pressed?
      else
        break unless @winDown and wParam == WM_KEYDOWN

        alphabet = ITEMS['key'].index(buf[0]) # which item chosen?
        alphabet = nil unless @itemAvail.include?(alphabet) # you must have that item
        arrow = ITEMS['key'][2].index(buf[0]) # up/downstairs?
        arrow = nil unless @itemAvail.include?(2) # you must have orbOfFly
        break if alphabet.nil? and arrow.nil?
      end
      hWnd = GetForegroundWindow.call
      if hWnd != $hWnd # TSW is not active
        buf = ' '*16
        GetClassName.call(hWnd, buf, 16)
        break if buf[0, 6]!='TTSW10'
        init # if another TSW is active now
      end

      break if isButtonFocused and !@flying # maybe in the middle of an event

      block = true
      if wParam == WM_KEYDOWN
        if alphabet and !@flying
          @winDown = false # de-active; restore
          unhookM
          INVAL_RECT.call($hWnd, @itemsRect, 0)

          WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [ITEMS['event_addr'][alphabet]-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # imgXXwork
          SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0) # click that item
          WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore

          if isButtonFocused # can use item successfully (so the don't-use button is focused now)
            if alphabet > 2 # exclude OrbOfHero/Wisdom
              WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [ITEMS['event_addr'][12]-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # buttonUseClick
              SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0) # click 'use'
              WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore
            end
          else
            SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Could not use #{ITEMS['name'][alphabet]}!")
          end

        elsif arrow
          if @flying # already flying: left/up=down/upstaris
            WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [ITEMS['event_addr'][2][arrow+2]-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # Up/Down
            SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0)
            WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore
            
            if @lastArrow != arrow
              INVAL_RECT.call($hWnd, [(2+0.5*(@lastArrow>0 ? 1 : 0))*$SIZE+$ORIGIN_X, $ORIGIN_Y, (2.5+0.5*(@lastArrow.zero? ? 0: 1))*$SIZE+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), 0)
              sleep(0.05) if @lastArrow < 0
              DRAW_TEXT.call($hDC, ['<-', '->'][arrow], -1, [(2+0.5*arrow)*$SIZE+$ORIGIN_X, $ORIGIN_Y, (2.5+0.5*arrow)*$SIZE+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), arrow*2)
              BIT_BLT.call($hDC, (2+0.5*arrow)*$SIZE+$ORIGIN_X, $ORIGIN_Y, $SIZE/2, $SIZE, $hDC, 0, 0, RASTER_DPO)
              @lastArrow = arrow
            end
          else
            unhookM
            WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [ITEMS['event_addr'][2][0]-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # Image4Click (OrbOfFly)
            WRITE_PROCESS.call_r($hPrc, ITEMS['event_addr'][2][1], "\x90"*6, 6, '    ') if arrow == 1 # bypass OrbOfFly restriction (JNZ->NOP)
            SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0)
            WRITE_PROCESS.call_r($hPrc, ITEMS['event_addr'][2][1], "\x0F\x85\xA2\0\0\0", 6, '    ') if arrow == 1 # restore (JNZ)
            WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore
            if isButtonFocused # can use OrbOfFly successfully (so the up/down/ok button is focused now)
              @flying = true
              SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Use left/right arrow key to fly down/up; release [WIN] to confirm.")
              @lastArrow = -1
              sleep(0.05)
              DRAW_TEXT.call($hDC, '<->', -1, [2*$SIZE+$ORIGIN_X, $ORIGIN_Y, 3*$SIZE+$ORIGIN_X, $ORIGIN_Y+$SIZE].pack('l4'), 0)
              BIT_BLT.call($hDC, 2*$SIZE+$ORIGIN_X, $ORIGIN_Y, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPNO)
            else
              @winDown = false
              INVAL_RECT.call($hWnd, @itemsRect, 0)
              len = SEND_MESSAGE.call($hWndText, WM_GETTEXT, 72, ' '*72)
              SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Cannot use #{ITEMS['name'][2]}! Are you in the middle of an event or do you really have it?") if len < 31 or len > 64 # otherwise, it's because "You must be near the stairs to fly!"
            end
          end
        elsif !@winDown # only trigger at the first time
          @winDown = true
          checkTSWsize
          hookM

          @itemAvail = []
          for i in 0..11 # check what items you have
            buf = "\0\0\0\0"
            READ_PROCESS.call_r($hPrc, ITEMS['address'][i], buf, 4, '    ')
            next if buf.unpack('L')[0] < 1
            @itemAvail << i
            y = ITEMS['position'][i]
            x, y = y%3, y/3
            x = x * $SIZE + $ORIGIN_X
            y = y * $SIZE + $ORIGIN_Y
            if i == 2 then char = "<->" else char = ITEMS['key'][i].chr end
            DRAW_TEXT.call($hDC, char, -1, [x, y, x+20, y+20].pack('l4'), 0)
            BIT_BLT.call($hDC, x, y, $SIZE, $SIZE, $hDC, 0, 0, RASTER_DPNO)
          end
          if @itemAvail.empty? # you have no items available
            _msHook('init', WM_MOUSEMOVE, 0) # upon pressing [WIN] without mouse move
          else
            SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Press alphabet/arrow key to use items or move mouse to teleport.") unless @itemAvail.empty?
          end
        end
      elsif wParam == WM_KEYUP # (alphabet == false; arrow == false)
        @winDown = false
        if statusM # if alphabet/arrow key not pressed, you are teleporting instead
          x_pos, y_pos = $x_pos, $y_pos
          unhookM
          INVAL_RECT.call($hWnd, @itemsRect, 0)
          if x_pos != -1 and y_pos != -1
            WRITE_PROCESS.call_r($hPrc, BASE_ADDRESS+OFFSET_XPOS, [x_pos].pack('l'), 4, '    ')
            WRITE_PROCESS.call_r($hPrc, BASE_ADDRESS+OFFSET_YPOS, [y_pos].pack('l'), 4, '    ')
            unhookM

            SEND_MESSAGE.call($hWnd, WM_COMMAND, HELP_MENUID, 0) if $autoRefresh

            SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Teleported to (#{x_pos.to_s(16).upcase},#{y_pos.to_s(16).upcase}) successfully.")
          end
        end
        if @flying
          @flying = false
          WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, [ITEMS['event_addr'][2][4]-MIDSPEED_ADDR-4].pack('l'), 4, '    ') # OK
          SEND_MESSAGE.call($hWnd, WM_COMMAND, MIDSPEED_MENUID, 0) # click ok button
          WRITE_PROCESS.call_r($hPrc, MIDSPEED_ADDR, MIDSPEED_ORIG, 4, '    ') # restore
        end
        
      end
    end
    return 1 if block # block input
    return CallNextHookEx.call(@hkhook, nCode, wParam, lParam)
  rescue Exception => @error
    return CallNextHookEx.call(@hkhook, nCode, wParam, lParam)
  end
  MouseProc = API::Callback.new('LLL', 'L', &method(:_msHook))
  KeyboardProc = API::Callback.new('LLL', 'L', &method(:_keyHook))

  def self.hookK
    return false if @hkhook != nil
    @hkhook = SetWindowsHookEx.call_r(WH_KEYBOARD_LL, KeyboardProc, @hMod, 0)
#   puts 'hookK called!'
    return true
  end
  def self.unhookK
    return false if @hkhook == nil
    return false if UnhookWindowsHookEx.call(@hkhook).zero?
#   puts 'unhookK called!'
    @hkhook = nil
    return true
  end
  def self.rehookK
    unhookK
    unhookM
    @itemAvail = [] # the items you have
    @winDown = false # [WIN] pressed; active
    @flying = false # currently using OrbOfFly; active

    hookK
  end
  def self.statusK
    return !@hkhook.nil?
  end
  def self.hookM
    return false if @hmhook != nil
    @hmhook = SetWindowsHookEx.call_r(WH_MOUSE_LL, MouseProc, @hMod, 0)
#   puts 'hookM called!'
    return true
  end
  def self.unhookM
    return false if @hmhook == nil

    WRITE_PROCESS.call_r($hPrc, TIMER1_ADDR, "\x53", 1, '    ') # TIMER1TIMER push ebx (restore; re-enable)
    $x_pos = $y_pos = -1
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')

    return false if UnhookWindowsHookEx.call(@hmhook).zero?
#   puts 'unhookM called!'
    @hmhook = nil
    return true
  end
  def self.statusM
    return !@hmhook.nil?
  end
end

def preExit() # finalize
  HookProcAPI.unhookK
  HookProcAPI.unhookM
  WRITE_PROCESS.call($hPrc, HELP_ADDR, "\x53\x8B\xD8\x6A\x05\x68", 7, '    ') # restore the function of the help menu
  API.new('DeleteDC', 'L', 'L', 'gdi32').call($hDC)
  API.new('UnregisterHotKey', 'LI', 'L', 'user32').call(0, 0)
  API.new('CloseHandle', 'L', 'L', 'kernel32').call($hPrc)
end
def menuRefresh() # change the function of the help menu to "refresh"
  flag = $autoRefresh ? 0xc3 : 0x90 # how this bytecode is set won't affect the outcome of asm code
  # instead, this flag can tell tswKai if $autoRefresh is turned on/off here
  WRITE_PROCESS.call_r($hPrc, HELP_ADDR, [0xe8, REFRESH_ADDR-HELP_ADDR-5, flag, 0xc3].pack('clcc'), 7, '    ') # Help2Click -> call 454de8; ret; # syokidata2
end
def checkTSWsize()
  wh = ' ' * 16
  GET_RECT.call_r($hWnd, wh)
  $W, $H = wh[8, 8].unpack('ll')
  $ORIGIN_X, $ORIGIN_Y = ($W/44.5).round, ($H/2.21).round
  $SIZE = ($W*0.025 + $H*0.0375).round
  HookProcAPI.itemsRect = [$ORIGIN_X, $ORIGIN_X, $ORIGIN_X+$SIZE*3, $ORIGIN_Y+$SIZE*5].pack('L4')
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
  wh = ' ' * 16
  while width < 600 # find the status bar, whose width is always larger than 600 (to avoid mistakenly finding other textbox window)
    $hWndText = FIND_WIN.call($hWnd, $hWndText, 'TEdit', 0)
    if $hWndText.zero?
      MESSAGE_BOX.call($hWnd, "tswMP failed to find the status bar at the bottom of the TSW window. Please check whether this is really a TSW process?\n\n\tPID=#{$pID}, hWND=#{$hWnd}\n\nHowever, tswMP will continue running anyway.", 'tswMP', MB_ICONEXCLAMATION)
      break
    end
    GET_RECT.call_r($hWndText, wh)
    width = wh.unpack('L4')[2]
  end
  SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, "tswMP: Started. Found TSW running - pID=#{$pID}; hWnd=0x#{$hWnd.to_s(16).upcase}")

  checkTSWsize
  $hDC = GET_DC.call_r($hWnd)
  $hBr = GET_OBJ.call(DC_BRUSH)
  SET_COLOR.call_r($hDC, 0x22A222)
  SEL_OBJ.call_r($hDC, $hBr)
  menuRefresh
end

init
$time = 0
$x_pos = $y_pos = -1
API.new('RegisterHotKey', 'LILL', 'L', 'user32').call_r(0, 0, MODIFIER, KEY)


HookProcAPI.hookK
MESSAGE_BOX.call($hWnd, """tswMovePoint is running. Try pressing WinKey!
When WinKey down:
1) Move mouse to select a destination to teleport;
2) Press specified alphabet key to use an item;
3) Press left/right arrow key to use orb of flying;
Then release WinKey to confirm. Other functions:

F7 = Toggle auto-refresh (now is #{$autoRefresh ? "on" : "off"});
F7 twice = Rehook keyboard if WinKey stops working;
F1 = Manually refresh TSW status;
Hold F7 = Quit tswMovePoint.""", 'tswMP', MB_ICONINFORMATION)

msg = ' ' * 44
while true
  GET_MESSAGE.call(msg, 0, 0, 0)
  # check if error to be processed within hook callback func
  HookProcAPI.handleHookExceptions

  # 32 bit? 64 bit? 0x312 = hotkey event
  if msg[4, 4] == "\x12\x03\0\0" then offset = 16 elsif msg[8, 4] == "\x12\x03\0\0" then offset = 32 else next end
  
  init if ISWINDOW.call($hWnd).zero? # reinit if TSW has quitted
  time = msg[offset, 4].unpack('L')[0]
  diff = time - $time
  $time = time

  if HookProcAPI::GetForegroundWindow.call == $hWnd # only respond when TSW is focused
    $autoRefresh = ! $autoRefresh
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, 'tswMP: You turned TSW auto-fresh ' + ($autoRefresh ? 'on.' : 'off. You can press F1 to refresh manually.'))
    menuRefresh
  end
  if diff < INTERVAL_QUIT # hold
    SEND_MESSAGE.call($hWndText, WM_SETTEXT, 0, '')
    HookProcAPI.unhookM
    INVAL_RECT.call($hWnd, HookProcAPI.itemsRect, 0)
    break
  elsif diff < INTERVAL_REHOOK # twice
    HookProcAPI.rehookK
    MESSAGE_BOX.call($hWnd, 'Keyboard Re-hooked.', 'tswMP', MB_ICONINFORMATION)
  end
end
MESSAGE_BOX.call($hWnd, 'tswMovePoint has stopped.', 'tswMP', MB_ICONINFORMATION)
preExit