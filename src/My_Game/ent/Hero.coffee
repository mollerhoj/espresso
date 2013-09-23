# ## Hero
class Hero extends Entity
  # The sprite that represents the player and can be controlled and
  # moved through the world.
  speed: 0.5
  w: 16
  h: 16
  gravity: 0.1
  scale_y: -1
  friction: 0.5
  max_speed: 1
  jumpPower: 1.5
  dx: 0
  dy: 0
  onGround: false
  rotation: 0
 
  # Step method
  step: ->

    if @hits('Danger')
      World.reset()

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

    # xr
    
    -1.7
    0.7


    @xr = @x % 1
    if Math.abs(@xr) > 0.5
      @xr= -@xr+0.5*Math.sign(@x)

    # yr
    @yr = @y % 1
    if @yr > 0.5
      @yr= -@yr+0.5

    for i in [0..Math.round(@dx)]
      if not @hits('Solid',Math.sign(@dx),0)
        @x+=Math.sign(@dx)
      else
        @dx = 0

    for i in [0..Math.round(@dy)]
      if not @hits('Solid',0,Math.sign(@dy))
        @y+=Math.sign(@dy)
      else
        @dy = 0
    
    @x +=@xr
    @y +=@yr
    
    if Keyboard.hold('UP')
      if @onGround == true
        @dy = -@jumpPower

    if Keyboard.hold('LEFT')
        @dx = Math.max(@dx-@speed-@friction,-@max_speed)
    if Keyboard.hold('RIGHT')
        @dx = Math.min(@dx+@speed+@friction,@max_speed)

    # Outside
    if @y > World.height
      World.reset()
    
  # The hero starts the game in the centre of the world.
  reset: ->
    @dx = 0
    @dy = 0
    super
