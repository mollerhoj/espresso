class Editor
  grid: null
  builder: null
  world: null
  level: ''

  entity_selector: null

  pause_button: null

  grid_x_button: null
  grid_y_button: null
  grid_width_button: null
  grid_height_button: null
  grid_toggle_button: null

  constructor:(world) ->
    @world = world
    @builder = new Builder(this)
    @grid = new Grid

    @level_selector = $("#level_selector")
    @level_selector.change(@level_change)
    @level_change()

    @save_type_selector = $("#save_type_selector")
    @save_type_selector.change(@save_type_selector)
    @save_button = $("#save_button")
    @save_button.click(@save)

    @entity_selector = $("#entity_selector")
    @entity_selector.change(@entity_change)
    @entity_change()

    @pause_button = $("#pause_toggle")
    @pause_button.click(@toggle_pause)
    @pause_button.click(@entity_change)

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

  step: ->
    @builder.step()

  level_change: =>
    @level = @level_selector.val()
    @world.destroy_all()
    @world.load_level(@level)

  save_type_change: =>
    @builder.save_type = @save_type_selector.val()

  save: =>
    level = @level_selector.val()
    txt = @builder.output_level(level)
    blob = new Blob([txt], {type : 'text/html'})
    saveAs(blob,"#{level}.coffee")

  entity_change: =>
    @builder.entity = @entity_selector.val()
    
  grid_move: =>
    @grid.x = parseInt $("#grid_x").val()
    @grid.y = parseInt  $("#grid_y").val()
    @grid.width = parseInt $("#grid_width").val()
    @grid.height = parseInt $("#grid_height").val()

  toggle_grid: =>
    if @grid.visible
      @grid.visible = false
    else
      @grid.visible = true

  toggle_pause: =>
    if Game.pause
      Game.pause = false
      @pause_button.html('Pause')
    else
      Game.pause = true
      @pause_button.html('Play')

    for world in Game.worlds
      world.pause = Game.pause

  draw: ->
    @grid.draw()
