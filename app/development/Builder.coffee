class Builder
  active: true
  hold: false
  entity: null
  world: null
  grid: null
  editor_state: null
  editor: null

  constructor:(editor) ->
    @editor = editor
    @editor_state = new EditorState
    #Ugly but don't know how else:
    @world = Game.worlds[0]

  save_level:(name) ->
    i = 1
    console.log @editor_state
    console.log @editor_state.data
    lvl = @editor_state.data[name] = new Object()
    for e in @world.all_entities()
      o = new Object()
      o.name = e.name
      o.x = e.sx
      o.y = e.sy
      lvl[i] = o
      i += 1

  load_level:(name) ->
    lvl = @editor_state
    for key,value of lvl.data[name]
      @world.spawn(value.name,value.x,value.y)

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
      @save_level(@editor.level)
      @hold = null

    # Destroy objects
    if Keyboard.hold('MOUSE_RIGHT')
      temp_all_entities = @world.all_entities().slice(0)
      for e in temp_all_entities when e.mouse_hits()
        e.destroy()
      @save_level(@editor.level)
