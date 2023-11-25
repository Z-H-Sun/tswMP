# encoding: ASCII-8Bit
# CHN strings encoding is UTF-8

require './stringsGBK'

$isCHN = false
$str = Str::StrEN
module Str
  TTSW10_TITLE_STR_ADDR = 0x88E74 + BASE_ADDRESS
  APP_VERSION = '1.2'
  @strlen = 0
  module StrEN
    LONGNAMES = ['Life Pt (HP)', 'Offense(ATK)', 'Defense(DEF)', 'Gold Count', 'CurrentFloor', 'HighestFloor', 'X Coordinate', 'Y Coordinate', '(Yellow) Key', 'Blue Key', 'Red  Key', 'Altar Visits',
'Weapon(Sword)', 'Shield Level', 'OrbOfHero', 'OrbOfWisdom', 'OrbOfFlight', 'Cross', 'Elixir', 'Mattock', 'DestructBall', 'WarpWing', 'AscentWing', 'DescentWing', 'DragonSlayer', 'SnowCrystal', 'MagicKey', 'SuperMattock', 'LuckyGold']
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
'tswMovePoint is running. Press the [WIN]/[TAB] key to use!

When the [WIN] or [TAB] hotkey is down:
1) Move the mouse and then click to teleport in the map
   (Right click = cheat);
2) Press a specified alphabet key to use an item or any
   arrow keys to use Orb of Flight (Up arrow = cheat).

When holding the hotkey, you can also see:
* the next critical value and damage of each monster and
* other useful data (if you hover the mouse on a monster)
on the map and in the status bar if you have Orb of Hero.

In addition, you can:
Double press F7	= Re-register hotkeys if they stop working;
Hold F7        	= Quit tswMovePoint.',
'Re-registered [WIN] and [TAB] hotkeys.',
'tswMovePoint has stopped.',
'DMG:%s = %s * %sRND | %dG%s',
' | PrevCRI:%s', # 15
' | NextCRI:%s',

'Inf', # -2
'.' # -1
    ]
  end

  module StrCN
    LONGNAMES = ['生 命 力', '攻 击 力', '防 御 力', '金 币 数', '当 前 楼 层', '最 高 楼 层', 'Ｘ 坐 标', 'Ｙ 坐 标', '黄 钥 匙', '蓝 钥 匙', '红 钥 匙', '祭 坛 次 数',
'佩 剑 等 级', '盾 牌 等 级', '勇 者 灵 球', '智 慧 灵 球', '飞 翔 灵 球', '十 字 架', '万 灵 药', '魔    镐', '破 坏 爆 弹', '瞬 移 之 翼', '升 华 之 翼', '降 临 之 翼', '屠 龙 匕', '雪 之 结 晶', '魔 法 钥 匙', '超 级 魔 镐', '幸 运 金 币']
    STRINGS = [
'tswMP: 请等待游戏内部事件结束……', # 0
'tswMP: 单击鼠标传送至 (%X,%X)%s',
'tswMP: 移动鼠标选择一个传送的目的地。',
'tswMP: 无法前往 (%X,%X)，请移动鼠标另选一个目的地。',
'tswMP: 按下字母键 / 方向键使用相应的宝物。',
'tswMP: 已传送至 (%X,%X)。移动鼠标继续传送%s', # 5
'，或按下对应按键使用宝物。',
'tswMP: 使用方向键上 / 下楼，最后松开 [WIN] 或 [TAB] 键确认。',
'tswMP: 已 作 弊 ！',
'tswMP: 已启动。发现运行中的 TSW - pID=%d; hWnd=0x%08X',
'tswMP: 无法使用%s！', # 10
'tswMP（座標移動）已开启。按 [WIN]/[TAB] 键使用！

当按下 [WIN] 或 [TAB] 快捷键时：
1) 单击鼠标可传送到地图上的新位置（右键＝作弊）；
2) 按下特定字母键可使用对应的宝物；或按下任一
   方向键，可以使用飞翔灵球（▲ 上方向键＝作弊）。

若拥有勇者灵球，在快捷键按下时还可在地图上显示：
* 当前地图中所有怪物的下一临界及总伤害；以及
* 将鼠标移到某个怪物上时，在右下状态栏显示怪物的
  基本属性，并在底部状态栏显示其他重要数据。

此外，还可以:
双击 F7     	＝当快捷键失效时重置快捷键；
长按 F7     	＝退出本程序。',
'已重置 [WIN] 及 [TAB] 快捷键。',
'tswMovePoint（座標移動）已退出。',
'伤害：%s = %s × %s回合｜%d金币%s',
'｜上一临界：%s', # 15
'｜临界：%s',

'∞', # -2
'。' # -1
    ]
  end

  module_function
  def utf8toWChar(string)
    arr = string.unpack('U*')
    @strlen = arr.size
    arr.push 0 # end by \0\0
    return arr.pack('S*')
  end
  def strlen() # last length
    @strlen
  end
  def isCHN()
    ReadProcessMemory.call_r($hPrc, TTSW10_TITLE_STR_ADDR, $buf, 32, 0)
    title = $buf[0, 32]
    if title.include?(APP_VERSION)
      if title.include?(StrEN::APP_NAME)
        $str = Str::StrEN
        return ($isCHN = false)
      elsif title.include?(StrCN::APP_NAME)
        $str = Str::StrCN
        return ($isCHN = true)
      end
    end
    raise_r('This is not a compatible TSW game: '+title.rstrip)
  end
end
