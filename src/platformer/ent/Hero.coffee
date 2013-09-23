class Hero extends Entity
  speed: 0.2
  w: 16
  h: 16
  gravity: 0.2
  friction: 0.2
  max_speed: 1
  jumpPower: 4
  dx: 0
  dy: 0
  vtime: 0
  htime: 0
  onGround: false
  rotation: 0
  
  # Step method
  step: ->

    #Control
    if Keyboard.hold('LEFT')
      @dx -= @speed
      if @onGround == true
        @dx -= @friction

    if Keyboard.hold('RIGHT')
      @dx += @speed
      if @onGround == true
        @dx += @friction

    if Keyboard.hold('UP')
      if @onGround == true
        @dy = -@jumpPower

    #Engine
    vrep=Math.abs(@dy)
    hrep=Math.abs(@dx)

    if @dy > 0
      @vtime+=@dy-Math.floor(@dy)
    if @dy < 0
      @vtime+=Math.abs(@dy-Math.ceil(@dy))
    if @vtime>=1
      @vtime-=1
      vrep +=1

    if @dx > 0
      @htime+=@dx-Math.floor(@dx)
    if @dx < 0
      @htime+=Math.abs(@dx-Math.ceil(@dx))
    if @htime>=1
      @htime-=1
      hrep +=1

    for i in [0...Math.floor(vrep)]
      if not @hits('Solid',0,Math.sign(@dy))
        @y+=Math.sign(@dy)
      else
        @dy=0
    
    for i in [0...Math.floor(hrep)]
      if not @hits('Solid',Math.sign(@dx),0)
        @x+=Math.sign(@dx)
      else
        @dx=0

    #Check if hits ground
    if @hits('Solid',0,1)
      @onGround = true
    else
      @onGround = false

    # Gravity
    if @onGround == false
      @dy += @gravity

    # Friction
    if @onGround == true
      @dx = Math.sign(@dx) * Math.max(0,Math.abs(@dx)-@friction)
