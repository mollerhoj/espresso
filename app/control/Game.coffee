# ## Game
# The game class handles top level game loop and initialisation.
class Game
  @context = null
  @worlds = []
  @images = {}
  @zoom_level: 1
  @pause = false
  @editor = null
  @mode = ""

  @add_world: ->
    Game.worlds.push(new World)

  @init:(mode) ->
    @mode = mode
    #Create canvas:
    Game.context = Game.create_canvas()

    #Adjust zoom level:
    Game.set_zoom(AppData.scale)

    Game.setup_keyboard()

    #Load Art
    i = new ImageLoader()
    i.onload = Game.start
    i.load_images()
    
  @start: =>
    #Create a world
    Game.add_world()

    #Create editor
    if @mode=="build"
      Game.editor = new Editor(Game.worlds[0])

    #Start running
    setInterval(Game.run, 16)

  @set_zoom: (rate) ->
    Game.context.scale(rate/Game.zoom_level,rate/Game.zoom_level)
    Game.zoom_level = rate

  # To own load images class
  @create_canvas: ->
    canvas = document.createElement("canvas")
    canvas.width = AppData.width * AppData.scale
    canvas.height = AppData.height * AppData.scale
    $("#game").append(canvas)
    context = canvas.getContext("2d")
    context.textBaseline = 'top'
    context.imageSmoothingEnabled = false # Spec
    context.mozImageSmoothingEnabled = false # Mozilla
    context.webkitImageSmoothingEnabled = false # Chrome / Safari
    return context

  @setup_keyboard: ->
    $("body").keydown (e) =>
      Keyboard.key_pressed(e.keyCode)
    $("body").keyup (e) =>
      Keyboard.key_released(e.keyCode)
    $("#game").mousemove(Keyboard.mouse_move)
    $("#game").mousedown(Keyboard.mouse_down)
    $("#game").mouseup(Keyboard.mouse_up)
    $("#game").bind "contextmenu", (e) -> return false # remove contextmenu

  @run: =>
    for world in Game.worlds
      world.step()
      world.draw()

    if Game.editor
      Game.editor.step()
      Game.editor.draw()
