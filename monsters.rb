module Monsters
=begin
  MONSTERS = [[35, 18, 1, 1], # slime G
  [45, 20, 2, 2], # slime R
  [130, 60, 3, 8], # slime B
  [35, 38, 3, 3], # bat
  [60, 32, 8, 5], # priest
  [100, 95, 30, 22], # high priest
  [50, 48, 22, 12], # gateman C
  [100, 180, 110, 100], # gateman B
  [50, 42, 6, 6], # skeleton C
  [55, 52, 12, 8], # skeleton B
  [100, 65, 15, 30], # skeleton A
  [60, 100, 8, 12], # big bat
  [260, 85, 5, 18], # zombie
  [320, 120, 15, 30], # zombie K
  [20, 100, 68, 28], # rock
  [8000, 5000, 1000, 500], # zeno (can also be 800/500/100 or 1000/625/125)
  [230, 450, 100, 100], # sorcerer
  [444, 199, 66, 144], # vampire
  [1200, 180, 20, 50], # octopus (gold is 100 if index==104)
  [1500, 600, 250, 800], # dragon
  [120, 150, 50, 100], # G knight
  [160, 230, 105, 65], # knight
  [100, 680, 50, 55], # swordsman
  [210, 200, 65, 45], # soldier
  [220, 180, 30, 35], # G soldier
  [320, 140, 20, 30], # slime man
  [4500, 560, 310, 1000], # archsorcerer
  [200, 390, 90, 50], # V bat
  [360, 310, 20, 40], # slime K
  [200, 380, 130, 90], # magician A
  [220, 370, 110, 80], # magician B
  [180, 430, 210, 120], # B knight
  [180, 460, 360, 200]] # gateman A
=end
  @check_mag = false # whether to check sorcerers and magicians
  class << self
    attr_writer :check_mag
  end
  module_function
  def getMonsterID(tileID)
    return 19 if tileID == 122
    if tileID < 61 or tileID > 158
      nil
    elsif tileID < 97
      tileID - 61 >> 1
    elsif tileID < 106
      18
    elsif tileID < 133
      nil
    else
      tileID - 93 >> 1
    end
  end
  def checkMap()
    return unless @check_mag
    for i in 0...121
      y, x = i.divmod(11)
      if $mapTiles[i] == 6
        left  = (x >  0) ? getMonsterID($mapTiles[i -  1]) : nil
        right = (x < 10) ? getMonsterID($mapTiles[i +  1]) : nil
        up    = (y >  0) ? getMonsterID($mapTiles[i - 11]) : nil
        down  = (y < 10) ? getMonsterID($mapTiles[i + 11]) : nil
        if (left == 16 && right == 16) || (up == 16 && down == 16) || # flanked by sorcerers
        left == 29 || right == 29 || up == 29 || down == 29 || # adjacent mag A
        left == 30 || right == 30 || up == 30 || down == 30 # adjacent mag B
          $mapTiles[i] = 255
        end
      end
    end
  end
end
