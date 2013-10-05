class SnakeBody extends Entity
  time: 0
  solid: false
  e: null
  z: 1

  init: ->
    @e = @world.spawn('SnakeBodyShadow',@x,@y)

  destroy: ->
    @e.destroy()
    super()

  step: ->
    @time += 1
    if @time > 10
      @solid = true

    if @time > 60+GameController.score*10
      @destroy()
    

