SHOW_MONSTER_STATUS_ADDR = 0x4b78c + BASE_ADDRESS # TTSW10.monshyouji
CUR_MONSTER_ID_ADDR = 0x8c5b8 + BASE_ADDRESS
MONSTER_STATUS_FACTOR_ADDR = 0xb8904 + BASE_ADDRESS
MONSTER_STATUS_ADDR = 0x89910 + BASE_ADDRESS
MONSTER_STATUS_LEN = 132 # 33*4 (4=HP/ATK/DEF/GOLD)
MONSTER_STATUS_TYPE = 'L132'
DAMAGE_DISPLAY_FONT = [16, 6, 0, 0, 700, 0, 0, 0, 0, 0, 0, NONANTIALIASED_QUALITY, 0, 'Tahoma']

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
  @cross = false
  @dragonSlayer = false
  @luckyGold = false
  @heroATK = 100
  @heroDEF = 100
  @statusFactor = 1
  class << self
    attr_writer :cross
    attr_writer :dragonSlayer
    attr_writer :luckyGold
    attr_writer :heroATK
    attr_writer :heroDEF
    attr_writer :statusFactor # 1 or 44
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
  def getStatus(monster_id)
    mHP, mATK, mDEF, mGold = $monStatus[monster_id*4, 4]
#OCTOPUS HEAD?
    mGold *= 2 if @luckyGold
    mHP *= @statusFactor
    mATK *= @statusFactor
    mDEF *= @statusFactor
    oneTurnDmg = mATK - @heroDEF
    oneTurnDmg = 0 if oneTurnDmg < 0
    heroATKfactor = ((monster_id == 17 && @cross) || (monster_id == 19 && @dragonSlayer)) ? 2 : 1
    
    oneTurnDmg2Mon = @heroATK*heroATKfactor - mDEF
    if oneTurnDmg2Mon <= 0
      dmg = 'NaN'
      criVals = [1-oneTurnDmg]
    else
      turnsCount = (mHP-1) / oneTurnDmg2Mon
      dmg = turnsCount * oneTurnDmg
      criVals = []
      for i in 0..4 # prev and next 4 critical values
        next if turnsCount < i
        criVals << ((mHP-1)/(turnsCount+1-i)+mDEF)/heroATKfactor + 1 - @heroATK
      end
    end
    return dmg, oneTurnDmg, turnsCount, criVals
  end
end
