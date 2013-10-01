class LevelPrinter
  world: null
  newline: "&#10;"

  constructor: ->
    #Wrong, but have not decided on solution
    @world = Game.worlds[0]

  #get_board: ->
    #cell_width= Settings.grid.cell_width
    #cell_height= Settings.grid.cell_height
    #board = []
    #
    #for e in World.all_entities()
    #  if e.sx % cell_width == 0 and e.sy % cell_height == 0
    #    subboard = board[e.sx/cell_width]
    #    if not subboard
    #      subboard = []
    #    subboard[e.sy/cell_height] = e.name
    #    board[e.sx/cell_width] = subboard
    #return board

  print: ->
    txt = ''
    n = Object.keys(EditorState.level).length
    for i in [1..n]
      e = EditorState.level[i]
      txt += "    " + i + ":" + @newline
      txt += "      name: '" + e.name + "'" + @newline
      txt += '      x: ' + e.x + @newline
      txt += '      y: ' + e.y + @newline
    return txt
