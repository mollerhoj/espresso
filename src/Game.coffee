# ## Game
# The game class handles top level game loop and initialisation.
class Game

  run: =>
    World.init()
    if Settings.mode == 'Development'
      Toolbox.init()
    setInterval(@main, 16)

  main: =>
    World.step()
    World.draw()
    if Settings.mode == 'Development'
      Toolbox.step()
      Toolbox.draw()

