require './monsters'

MAP_ADDR = 0xb8934 + BASE_ADDRESS
MAP_TYPE = 'C121'
SACREDSHIELD_ADDR = 0xb872c + BASE_ADDRESS

module Connectivity
  @queue = []
  @check_mag = false # whether to check sorcerers and magicians
  @heroHP = 1000
  @ancestor = Array.new(121) # for each position, record its parent position (where it is moved from)
  @monsters = Hash.new()
  @points = []
  @index = 0
  @destTile = 0
  class << self
    attr_writer :check_mag
    attr_writer :heroHP
    attr_reader :points
    attr_reader :index
    attr_reader :destTile
    attr_reader :monsters
  end

  module_function
  def precheck()
    @monsters.clear()
    for i in 0...121
      y, x = i.divmod(11)
      if $mapTiles[i] == 6 and @check_mag
        left  = (x >  0) ? Monsters.getMonsterID($mapTiles[i -  1]) : nil
        right = (x < 10) ? Monsters.getMonsterID($mapTiles[i +  1]) : nil
        up    = (y >  0) ? Monsters.getMonsterID($mapTiles[i - 11]) : nil
        down  = (y < 10) ? Monsters.getMonsterID($mapTiles[i + 11]) : nil
        if (left == 16 && right == 16) || (up == 16 && down == 16) # flanked by sorcerers
          $mapTiles[i] = -3
          HookProcAPI.drawDmg(x, y, (@heroHP + 1 >> 1).to_s, nil)
        elsif left == 29 || right == 29 || up == 29 || down == 29 # adjacent mag A
          $mapTiles[i] = -2
          HookProcAPI.drawDmg(x, y, '200', nil)
        elsif left == 30 || right == 30 || up == 30 || down == 30 # adjacent mag B
          $mapTiles[index] = -1
          HookProcAPI.drawDmg(x, y, '100', nil)
        end
      else
        mID = Monsters.getMonsterID($mapTiles[i])
        next unless mID

        res = @monsters[mID]
        if !res then res = Monsters.getStatus(mID); @monsters[mID] = res end
        dmg = res[0].to_s
        cri = res[3][1]; cri = cri.to_s if cri
        HookProcAPI.drawDmg(x, y, dmg, cri)
      end
    end
  end
  def main(ox, oy, tx, ty) # starting point: (ox, oy); end point: (tx, ty)
    @t_index = 11*ty + tx
    @destTile = $mapTiles[@t_index]
    case @destTile
    when 4, 5, 8, 13, 14, 15, 17, 115..121, 123..132, 159..255 # gate; prison; lava; starlight; wings of altar; dragon; other
      return nil
    end
    @o_index = 11*oy + ox
    @queue = [@o_index]
    @ancestor.fill(nil)
    @ox = ox; @oy = oy
    @tx = tx; @ty = ty
    @init = true

    $mapTiles.map! {|i| i.zero? ? 6 : i} # discard last round graph change
    result = floodfill()
    unless result # magicians in the way? loosen the constraints a bit and search again
      
    end

    if result
      @points = [tx*$TILE_SIZE+$MAP_LEFT+$TILE_SIZE/2, ty*$TILE_SIZE+$MAP_TOP+$TILE_SIZE/2]
      index = @index
      if @index != @t_index # in this case @index is 1 step away from destination
        y, x = @index.divmod(11)
        @points.push(x*$TILE_SIZE+$MAP_LEFT+$TILE_SIZE/2, y*$TILE_SIZE+$MAP_TOP+$TILE_SIZE/2)
        @index = @t_index if result.zero? # can directly go to that position
      end
      while index != @o_index
        index = @ancestor[index]
        y, x = index.divmod(11)
        @points.push(x*$TILE_SIZE+$MAP_LEFT+$TILE_SIZE/2, y*$TILE_SIZE+$MAP_TOP+$TILE_SIZE/2)
      end
    end

    return result
  end
  def floodfill()
    until @queue.empty?
      @index = @queue.shift # current index; remove the first element of @queue
      next if $mapTiles[@index].zero? # already visited before
      if @init then @init = false else $mapTiles[@index] = 0 end
      y, x = @index.divmod(11)

      dx = x - @tx; dy = y - @ty
      if (dx*dy).zero? and (dx+dy).abs == 1 # (0,+-1) or (+-1,0), i.e. 1 step away. If so, we can stop now [note: do not consider (0,0)]
        return 0 if @destTile == 0 or @destTile == 6 # in this case, can directly go to that destination
        return dx | (dy << 1) # otherwise, should go to @index and then go -2: down; -1:right; 0: X; 1:left; 2: up
      end

      if x > 0
        index = @index - 1
        if $mapTiles[index] == 6 then @queue.push(index); @ancestor[index] = @index end
      end
      if x < 10
        index = @index + 1
        if $mapTiles[index] == 6 then @queue.push(index); @ancestor[index] = @index end
      end
      if y > 0
        index = @index - 11
        if $mapTiles[index] == 6 then @queue.push(index); @ancestor[index] = @index end
      end
      if y < 10
        index = @index + 11
        if $mapTiles[index] == 6 then @queue.push(index); @ancestor[index] = @index end
      end
    end
    return nil
  end
end

=begin
# DFS algorithm instead of BFS:
  def main(ox, oy) # starting point: (ox, oy); end point: ($x_pos, $y_pos)
    index = 11*oy + ox
    $mapTiles[index] = 6 # do not consider the origin point; set as floor
    $found = nil
    floodFill(index)
    if $found
      $found = 0 if $mapTiles[11*$y_pos + $x_pos] == 6 # no need to involve one additional move if the destination is floor
    end
    return $found
  end
  def floodFill(index) # index = 11*y + x
    return if $found # stop searching
    return if $mapTiles[index] != 6
    $mapTiles[index] = 0
    y, x = index.divmod(11)
    dx = x - $x_pos; dy = y - $y_pos
    if dx.abs + dy.abs < 2 # 0 0 or 0 +-1 or +-1 0
      $found = dx | (dy << 1) # should go -2: down; -1:right; 0: X; 1:left; 2: up
      return
    end
    floodFill(index -  1) if x > 0
    floodFill(index +  1) if x < 10
    floodFill(index - 11) if y > 0
    floodFill(index + 11) if y < 10
  end
=end