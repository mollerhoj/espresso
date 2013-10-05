class GameController extends Entity
  @score: 0
  text: null
  world: null
  
  init: ->
    @text = new Text('10',10,10)
    @world.spawn('Snake',100,100)
    @world.spawn('Apple',100,100)

  draw: ->
    @text.string = GameController.score
    @text.draw()


