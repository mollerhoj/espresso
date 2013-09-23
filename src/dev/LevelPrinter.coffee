class LevelPrinter

  @get_board: ->
    cell_width= Settings.grid.cell_width
    cell_height= Settings.grid.cell_height
    board = []
    
    for e in World.all_entities()
      if e.sx % cell_width == 0 and e.sy % cell_height == 0
        subboard = board[e.sx/cell_width]
        if not subboard
          subboard = []
        subboard[e.sy/cell_height] = e.name
        board[e.sx/cell_width] = subboard
    return board

  @print: ->
    i = 1
    txt = ''
    newline = "&#10;"
    
    LevelData.level = new Object()

    # If these lines are uncommented, all entites that alignes with the grid
    # will get printed as a board variable.
    #board = LevelPrinter.get_board()
    #LevelData.level[0] = board
    #txt += '    board: ' + board.deepToString() + newline

    for e in World.all_entities()
      txt += "    " + i + ":" + newline
      txt += "      name: '" + e.name + "'" + newline
      txt += '      x: ' + e.sx + newline
      txt += '      y: ' + e.sy + newline

      o = new Object()
      o.name = e.name
      o.x = e.sx
      o.y = e.sy
      LevelData.level[i] = o
      i += 1

    $('#output').html(txt)
