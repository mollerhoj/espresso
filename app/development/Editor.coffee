class Editor
  grid: null
  pause_button: null
  grid_x_button: null
  grid_y_button: null
  grid_width_button: null
  grid_height_button: null
  grid_toggle_button: null

  constructor: ->
    @pause_button = $("#pause_toggle")
    @pause_button.click(@toggle_pause)

    @grid = new Grid
    @grid_x_button = $("#grid_x")
    @grid_y_button = $("#grid_y")
    @grid_width_button = $("#grid_width")
    @grid_height_button = $("#grid_height")
    @grid_toggle_button = $("#grid_toggle")

    @grid_x_button.change(@grid_move)
    @grid_y_button.change(@grid_move)
    @grid_width_button.change(@grid_move)
    @grid_height_button.change(@grid_move)
    @grid_toggle_button.click(@toggle_grid)

  grid_move: =>
    @grid.x = $("#grid_x").val()
    @grid.y = $("#grid_y").val()
    @grid.width = $("#grid_width").val()
    @grid.height = $("#grid_height").val()

  toggle_grid: =>
    if @grid.visible
      @grid.visible = false
      @grid_toggle_button.html('Grid on')
    else
      @grid.visible = true
      @grid_toggle_button.html('Grid off')

  toggle_pause: =>
    if Game.pause
      Game.pause = false
      @pause_button.html('Pause')
    else
      Game.pause = true
      @pause_button.html('Play')

    for world in Game.worlds
      world.pause = Game.pause
      console.log world.pause

  draw: ->
    @grid.draw()
