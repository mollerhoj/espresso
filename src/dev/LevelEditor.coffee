# Level Editor
class LevelEditor
  _visible: false
  hold: null
  active: false
  menu: null
  grid: null

  #The constructor takes the menu that determins the leveleditors choices
  constructor: (menu) ->
    @menu = menu

  step: ->
    if not @active then return
    
    # Create objects
    if Keyboard.press('MOUSE_LEFT')
      @hold = World.spawn(@menu.selected_button.text,Keyboard.MOUSE_X,Keyboard.MOUSE_Y)
    if @hold
      @hold.x = Keyboard.MOUSE_X
      @hold.y = Keyboard.MOUSE_Y
      if Keyboard.hold('SHIFT') and @grid
        @hold.x -= (Keyboard.MOUSE_X - @grid.offset_x) % @grid.cell_width
        @hold.y -= (Keyboard.MOUSE_Y - @grid.offset_y) % @grid.cell_height
      @hold.sx = @hold.x
      @hold.sy = @hold.y

    if Keyboard.release('MOUSE_LEFT')
      LevelPrinter.print()
      @hold = null

    # Destroy objects
    if Keyboard.hold('MOUSE_RIGHT')
      temp_all_entities = World.all_entities().slice(0)
      for e in temp_all_entities when e.mouse_hits()
        e.destroy()
      LevelPrinter.print()

  draw: -> #TODO perhaps make a tool class to extend from with a filler draw method.
