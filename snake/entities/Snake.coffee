class Snake extends Entity
  dir: 0
  time: 0
  z: 10

  step: ->
    if Keyboard.hold('RIGHT') 
      @dir = 0
    if Keyboard.hold('UP') 
      @dir = 90
    if Keyboard.hold('LEFT') 
      @dir = 180
    if Keyboard.hold('DOWN') 
      @dir = 270
      
    if @dir==0
      @x += 4
    if @dir==90
      @y -= 4
    if @dir==180
      @x -= 4
    if @dir==270
      @y += 4

    @sprite.rotation = @dir

    @time+=1
    if @time%(16/8) == 0
      rx = Math.random()*2
      ry = Math.random()*2
      @world.spawn('SnakeBody',@x-1+rx,@y-1+ry)

    if @x < 0
      @x = 320
    if @y < 0
      @y = 240
    if @x > 320
      @x = 0
    if @y > 240
      @y = 0

    #if @hit('SnakeBody')
    #  if @hit('SnakeBody').solid == true
    #    @destroy()

    if @hit('Apple')
      hit = @hit('Apple')
      hit.x = Math.random()*AppData.width
      hit.y = Math.random()*AppData.height
      GameController.score += 1

  outside: ->
    return @x < 0 || @x > 320 || @y < 0 || @y > 240
