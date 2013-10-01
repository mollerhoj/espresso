class Editor
  grid: null
  builder: null
  printer: null

  entity_selector: null

  pause_button: null

  grid_x_button: null
  grid_y_button: null
  grid_width_button: null
  grid_height_button: null
  grid_toggle_button: null

  constructor: ->
    @printer = new LevelPrinter

    @print_output = $('#printer_output')
    @print_type_selector = $("#print_type_selector")
    @print_type_selector.change(@print_type_change)
    @print_button = $("#print_button")
    @print_button.click(@print)

    @builder = new Builder

    @entity_selector = $("#entity_selector")
    @entity_selector.change(@entity_change)
    @entity_change()

    @pause_button = $("#pause_toggle")
    @pause_button.click(@toggle_pause)
    @pause_button.click(@entity_change)

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

  step: ->
    @builder.step()

  print_type_change: =>
    @printer.type = @print_type_selector.val()

  print: =>
    @print_output.html(@printer.print())

  entity_change: =>
    @builder.entity = @entity_selector.val()
    
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

  draw: ->
    @grid.draw()
