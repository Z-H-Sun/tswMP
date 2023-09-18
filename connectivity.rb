require './monsters'

MAP_ADDR = 0xb8934 + BASE_ADDRESS
MAP_TYPE = 'C121'
SACREDSHIELD_ADDR = 0xb872c + BASE_ADDRESS

module Connectivity
  @queue = []
  @ancestor = Array.new(121) # for each position, record its parent position (where it is moved from)
  @route = nil
  @destTile = 0
  class << self
    attr_reader :route
    attr_reader :destTile
  end
# note: in order to detect magic attacks (mark these floor tiles as impassible), need to call `Monsters.checkMap` beforehand
  module_function
  def main(tx, ty) # end point: (tx, ty)
    @route = nil # clear last route
    t_index = 11*ty + tx
    @destTile = $mapTiles[t_index]
    return nil if @destTile > 0 # inaccessible
    @destTile = -@destTile

    case @destTile
    when 4, 5, 8, 13, 14, 15, 17, 115..121, 123..132, 159..254 # gate; prison; lava; starlight; wings of altar; dragon (not head); other
      return nil # impassible
    when 0
      access = 0 # in this case, can directly go to that destination
    else
      access = @ancestor[t_index] - t_index # in this case, should first go to somewhere 1 step away from destination
    end

    @route = [tx*$TILE_SIZE+$MAP_LEFT+$TILE_SIZE/2, ty*$TILE_SIZE+$MAP_TOP+$TILE_SIZE/2]
    index = @ancestor[t_index]
    loop do
      y, x = index.divmod(11)
      @route.push(x*$TILE_SIZE+$MAP_LEFT+$TILE_SIZE/2, y*$TILE_SIZE+$MAP_TOP+$TILE_SIZE/2)
      break if index == @o_index
      index = @ancestor[index]
    end
    return access
  rescue # unlikely, but in case the ancestor of a position can't be found, return false
    return nil
  end
  def floodfill(ox, oy) # starting point: (ox, oy)
    @o_index = 11*oy + ox
    @queue = [@o_index]
    @ancestor.fill(nil)

    init = true
    until @queue.empty?
      index = @queue.shift # current index; remove the first element of @queue
      next if $mapTiles[index].zero? # already visited before
      if init then init = false else $mapTiles[index] = 0 end
      y, x = index.divmod(11)

      neighbor(index,  -1) if x >  0
      neighbor(index,   1) if x < 10
      neighbor(index, -11) if y >  0
      neighbor(index,  11) if y < 10
    end
  end
  def neighbor(index, offset)
    index2 = index + offset
    id = $mapTiles[index2]
    return if id <= 0 # already has an ancestor

    if id == 6
      @queue.push(index2)
    else
      $mapTiles[index2] = -id # search ends here, but still need to record an ancestor, and mark its status as completed
    end
    @ancestor[index2] = index
  end
end
