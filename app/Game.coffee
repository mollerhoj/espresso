# ## Game
# The game class handles top level game loop and initialisation.
class Game

  run: =>
    World.init()
    setInterval(@main, 16)

  main: =>
    World.step()
    World.draw()
