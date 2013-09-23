class Hero extends Entity
  speed: 0.2
  sprite: 'Star'
  type: 'Star'
  w: 32
  h: 32
  gravity: 0.03
  friction: 0.05
  max_speed: 1 
  jumpPower: 1.8
  dx: 0
  dy: 0
  vtime: 0
  htime: 0
  onGround: false
  rotation: 0
  scale_x: 1
  power: true 
  face: 1

  boxing_power: 3
  balloon_power: 2
  umbrella_power: 80
  ghost_power: 20

  umbrella_time: 0
  ghost_time: 0
  ghost: false
 
  # Step method
  step: ->
    @umbrella_time -=1

    if @ghost_time > 0
      @ghost_time -=1
      @ghost = true
    else
      if not @hits('Solid')
        @ghost = false

    #Control
    if Keyboard.hold('LEFT') and @type != 'Star'
      @face = -1
      @dx -= Math.max(0,Math.min(@speed,@max_speed+@dx))
      if @onGround == true
        @dx -= @friction

    if Keyboard.hold('RIGHT') and @type != 'Star'
      @face = 1
      @dx += Math.max(0,Math.min(@speed,@max_speed-@dx))
      if @onGround == true
        @dx += @friction

    if Keyboard.hold('UP') and @type != 'Star'
      if @onGround == true
        @dy = -@jumpPower

    if Keyboard.press('SPACE')
      if @power == true
        @power = false
        switch @type
          when 'Balloon'
            @dy = -@balloon_power
          when 'Boxing_Glove'
            @dx = @face * @boxing_power
          when 'Umbrella'
            @umbrella_time = @umbrella_power
          when 'Ghost'
            @ghost_time = @ghost_power

    #
    @scale_x = @face

    #Hitting item
    i = @hits('Item')
    if i
      @x = i.x
      @y = i.y
      @umbrella_time = 0
      @ghost_time = 0
      i.destroy()
      @sprite = i.sprite
      @type = i.sprite
      @power = true

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
      if not @hits('Solid',0,Math.sign(@dy)) or @ghost
        @y+=Math.sign(@dy)
      else
        @dy=0
    
    for i in [0...Math.floor(hrep)]
      if not @hits('Solid',Math.sign(@dx),0) or @ghost
        @x+=Math.sign(@dx)
      else
        @dx=0

    #Check if hits ground
    if @hits('Solid',0,1) and not @ghost
      @onGround = true
    else
      @onGround = false

    # Gravity
    if @onGround == false
      if not (@type == 'Star' and @power == true)
        @dy += @gravity

    # Friction
    if @onGround == true
      @dx = Math.sign(@dx) * Math.max(0,Math.abs(@dx)-@friction)

    # in air /Max_speed friction
    if Math.abs(@dx) > @max_speed
      @dx = Math.sign(@dx) * Math.max(0,Math.abs(@dx)-0.1)

    #Animation
    @index = 1

    if @type == 'Star' and @power == false
      @rotation += 2
    else
      @rotation = 0

    if @umbrella_time > 0
      @dy = 0
      @index = 2

    if @ghost
      @index = 2

    if @type == 'Balloon' and @power == false
      @index = 2

    #hits goal
    if @hits('Goal')
      World.reset()

    #Outside world
    if @y > Settings.height
      World.reset()


