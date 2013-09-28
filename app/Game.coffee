# ## Game
# The game class handles top level game loop and initialisation.
class Game
  @context = null
  @worlds = []
  @images = {}

  @add_world: ->
    Game.worlds.push(new World)

  @init: ->
    #Create canvas:
    Game.context = Game.create_canvas()

    #Load Art
    Art.init()
    i = new ImageLoader()
    i.onload = Game.start
    i.load_images()

  @start: ->
    #Create a world
    Game.add_world()
    #Start running
    setInterval(Game.run, 16)

  # To own load images class
  @create_canvas: ->
    canvas = document.createElement("canvas")
    canvas.width = AppData.width * AppData.scale
    canvas.height = AppData.height * AppData.scale
    $("#game").append(canvas)
    return canvas.getContext("2d")

  @run: =>
    for world in Game.worlds
      world.step()
      world.draw()
