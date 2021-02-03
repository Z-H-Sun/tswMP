require 'Win32API'
GET_MESSAGE = Win32API.new('user32','GetMessage','plll','l')
SEND_MESSAGE = Win32API.new('user32', 'SendMessage', 'llll', 'l')
FILL_RECT = Win32API.new('user32', 'FillRect', 'lpl', 'l')
WRITE_PROCESS = Win32API.new('kernel32', 'WriteProcessMemory', 'llplp', 'l')
MESSAGE_BOX = Win32API.new('user32', 'MessageBox', 'lppi', 'l')
WM_SETREDRAW = 0xB
DC_BRUSH = 18
PROCESS_VM_WRITE = 0x20
PROCESS_VM_READ = 0x10
PROCESS_VM_OPERATION = 0x8
MB_ICONINFORMATION = 0x40

BASE_ADDRESS = 0x400000
OFFSET_XPOS = 0xb86a0
OFFSET_YPOS = 0xb86a4

MODIFIER = 0
KEY = 118

$hWnd = Win32API.new('user32', 'FindWindow', 'pi', 'l').call('TTSW10', 0)
$pID = '\0\0\0\0'
Win32API.new('user32', 'GetWindowThreadProcessId', 'lp', 'l').call($hWnd, $pID)
$pID = $pID.unpack('L')[0]
begin
  load('tswMPdebug.txt')
rescue Exception
end
raise("Cannot find the TSW process and/or window. Please check if\nTSW V1.2 is currently running.\n\nAs an advanced option, you can manually assign $hWnd and\n$pID in `tswMPdebug.txt'.") if $hWnd.zero? or $pID.zero?
$hPrc = Win32API.new('kernel32', 'OpenProcess', 'lll', 'l').call(PROCESS_VM_WRITE | PROCESS_VM_READ | PROCESS_VM_OPERATION, 0, $pID)
raise("Cannot open the TSW process for writing. Please check if\nTSW V1.2 is running with pID=#{$pID} and if you have proper\npermissions.") if $hPrc.zero?

wh = ' ' * 16
Win32API.new('user32','GetClientRect','lp','l').call($hWnd, wh)
W, H = wh[8, 8].unpack('ll')
SIZE = (W*0.025 + H*0.0375).round
$hDC = Win32API.new('user32', 'GetDC', 'l', 'l').call($hWnd)
$hBr = Win32API.new('gdi32', 'GetStockObject', 'l', 'l').call(DC_BRUSH)
Win32API.new('gdi32','SetDCBrushColor','ll','l').call($hDC, 0x22A222)
#$hBr = Win32API.new('gdi32', 'CreateHatchBrush', 'll', 'l').call(5, 0x22A222)
Win32API.new('gdi32','SelectObject','ll','l').call($hDC, $hBr)

$time = 0
$x_pos = $y_pos = -1
raise("Cannot register hotkey. It might be currently occupied by\nother processes or another instance of tswMP. Please close\nthem to avoid confliction.\n\nDefault: F7 (0+ 118); current (#{MODIFIER}+ #{KEY}). As an advanced\noption, you can manually assign MODIFIER and KEY in `tswMPdebug.txt'.") if Win32API.new('user32', 'RegisterHotKey', 'lill', 'l').call(0, 0, MODIFIER, KEY).zero?

MESSAGE_BOX.call($hWnd, "tswMovePoint is currently running.\n\nUse hotkey (Default=F7) to operate:\nPress once = preview;\ntwice (at the same position) = confirm;\nonce outside = cancel;\nquickly press twice outside = quit.", 'tswMP', MB_ICONINFORMATION)

msg = ' ' * 44
while true
  GET_MESSAGE.call(msg, 0, 0, 0)
  # 32 bit? 64 bit? 0x312 = hotkey event
  if msg[4, 4] == "\x12\x03\0\0" then offset = 16 elsif msg[8, 4] == "\x12\x03\0\0" then offset = 32 else next end
  time = msg[offset, 4].unpack('L')[0]
  diff = time - $time
  $time = time
  xy = msg[offset + 4, 8]
  Win32API.new('user32','ScreenToClient','lp','l').call($hWnd, xy)
  x, y = xy.unpack('ll')
  x_pos = ((x - W*0.225) / SIZE).floor
  y_pos = ((y - H*0.057) / SIZE).floor
  if x_pos == $x_pos and y_pos == $y_pos # same pos twice
    SEND_MESSAGE.call($hWnd, WM_SETREDRAW, 1, 0)
    res = WRITE_PROCESS.call($hPrc, BASE_ADDRESS+OFFSET_XPOS, [x_pos].pack('l'), 4, '    ')
    res &= WRITE_PROCESS.call($hPrc, BASE_ADDRESS+OFFSET_YPOS, [y_pos].pack('l'), 4, '    ')
    raise("Cannot write to the TSW process. Please check if TSW V1.2 is\nrunning with pID=#{$pID} and if you have proper permissions.") if res.zero?
    next
  end
  if $x_pos >= 0 and $y_pos >= 0 # at preview
    SEND_MESSAGE.call($hWnd, WM_SETREDRAW, 1, 0) # refresh
    sleep(0.2)
  end
  if x_pos < 0 or x_pos > 10 or y_pos < 0 or y_pos > 10 # outside
    break if diff < 500 # press twice
    $x_pos = $y_pos = -1 # cancel preview
    next
  end
  $x_pos = x_pos; $y_pos = y_pos
  x_left = (W*0.225 + SIZE*x_pos).round
  y_top = (H*0.057 + SIZE*y_pos).round
  #FILL_RECT.call($hDC, [x_left, y_top, x_left+SIZE, y_top+SIZE].pack('llll'), $hBr)
  Win32API.new('gdi32', 'BitBlt', 'lllllllll', 'l').call($hDC, x_left, y_top, SIZE, SIZE, $hDC, 0, 0, 0xFA0089) # Pat|Dest

  SEND_MESSAGE.call($hWnd, WM_SETREDRAW, 0, 0) # freeze (disable refresh)
end
MESSAGE_BOX.call($hWnd, "tswMovePoint has stopped.", 'tswMP', MB_ICONINFORMATION)
Win32API.new('gdi32','DeleteDC','l','l').call($hDC)
#Win32API.new('gdi32','DeleteObject','l','l').call($hBr)
Win32API.new('user32', 'UnregisterHotKey', 'li', 'l').call(0, 0)
Win32API.new('kernel32', 'CloseHandle', 'l', 'l').call($hPrc)
