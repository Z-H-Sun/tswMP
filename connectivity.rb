module Connectivity
  @queue = []
  @queue_mag = [] # where sorcerers or magicians are in the way
  @check_mag = false # whether to check sorcerers and magicians
  @ancestor = Array.new(121) # for each position, record its parent position (where it is moved from)
  @points = []
  @destTile = 0
  class << self
    attr_writer :check_mag
    attr_reader :points
    attr_reader :index
    attr_reader :destTile
  end

  module_function
  def main(ox, oy, tx, ty) # starting point: (ox, oy); end point: (tx, ty)
    @t_index = 11*ty + tx
    @destTile = $mapTiles[@t_index]
    case @destTile
    when 4, 5, 8, 13, 14, 15, 17, 115..121, 123..132, 159..255 # gate; prison; lava; starlight; wings of altar; dragon; other
      return nil
    end
    @o_index = 11*oy + ox
    @queue = [@o_index]
    @queue_mag = []
    @ancestor.fill(nil)
    @ox = ox; @oy = oy
    @tx = tx; @ty = ty
    @init = true
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
  def check(index, check_mag=@check_mag)
    @y, @x = index.divmod(11)
    @left  = (@x >  0) ? $mapTiles[index -  1] : nil
    @right = (@x < 10) ? $mapTiles[index +  1] : nil
    @up    = (@y >  0) ? $mapTiles[index - 11] : nil
    @down  = (@y < 10) ? $mapTiles[index + 11] : nil
    return true unless check_mag
    if (@left == 93 && @right == 93) || (@up == 93 && @down == 93) || # flanked by sorcerers
    @left == 151 || @left == 153 || @right == 151 || @right == 153 || @up == 151 || @up == 153 || @down == 151 || @down == 153 # magicians
      $mapTiles[index] = -1
      @queue_mag.push(index)
      return false
    end
    return true
  end
  def floodfill()
    until @queue.empty?
      @index = @queue.shift # current index; remove the first element of @queue
      next if $mapTiles[@index] <= 0 # already visited before
      if @index == @o_index
        next unless @init # do not process unless for the first time
        check(@index, false) # just initialize @x, @y, @left, @right, @up, & @down
        @init = false
      else
        next unless check(@index)
        $mapTiles[@index] = 0
      end
      dx = @x - @tx; dy = @y - @ty
      if (dx*dy).zero? and (dx+dy).abs == 1 # (0,+-1) or (+-1,0), i.e. 1 step away. If so, we can stop now [note: do not consider (0,0)]
        if @destTile == 0 or @destTile == 6
          return 0 unless @check_mag # in this case, can directly go to that destination
          return 0 if check(@t_index) # check the destination
        end
        return dx | (dy << 1) # otherwise, should go to @index and then go -2: down; -1:right; 0: X; 1:left; 2: up
      end

      if @left  == 6 then @queue.push(@index -  1); @ancestor[@index -  1] = @index end
      if @right == 6 then @queue.push(@index +  1); @ancestor[@index +  1] = @index end
      if @up    == 6 then @queue.push(@index - 11); @ancestor[@index - 11] = @index end
      if @down  == 6 then @queue.push(@index + 11); @ancestor[@index + 11] = @index end
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