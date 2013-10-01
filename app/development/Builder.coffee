class Builder
  active: true
  hold: false
  entity: null
  world: null
  grid: null

  constructor: ->
    #Ugly but don't know how else:
    @world = Game.worlds[0]

  save: ->
    i = 1
    EditorState.level = new Object()
    for e in @world.all_entities()
      o = new Object()
      o.name = e.name
      o.x = e.sx
      o.y = e.sy
      EditorState.level[i] = o
      i += 1

  step: ->
    #Ugly but don't know how else:
    if not grid
      grid = Game.editor.grid

    if not @active then return
    
    # Create objects
    if Keyboard.press('MOUSE_LEFT')
      @hold = @world.spawn(@entity,Keyboard.MOUSE_X,Keyboard.MOUSE_Y)
    if @hold
      @hold.x = Keyboard.MOUSE_X
      @hold.y = Keyboard.MOUSE_Y
      if Keyboard.hold('SHIFT') and @grid
        @hold.x -= (Keyboard.MOUSE_X - @grid.offset_x) % @grid.cell_width
        @hold.y -= (Keyboard.MOUSE_Y - @grid.offset_y) % @grid.cell_height
      @hold.sx = @hold.x
      @hold.sy = @hold.y

    if Keyboard.release('MOUSE_LEFT')
      @save()
      @hold = null

    # Destroy objects
    if Keyboard.hold('MOUSE_RIGHT')
      temp_all_entities = @world.all_entities().slice(0)
      for e in temp_all_entities when e.mouse_hits()
        e.destroy()
      @save()
