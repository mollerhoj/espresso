# Parent of all entities (user created game objects)
class Entity
  x: 0
  y: 0
  sx: 0
  sy: 0
  w: undefined
  h: undefined
  visible: true
  name: null
  types: [] #Types used in collision
  scale_x: 1
  scale_y: 1
  offset_x: 0
  offset_y: 0
  alpha: 1
  rotation: 0
  index: 1
  sprite: null 
  z: 0

  draw: ->
    if @sprite
      @sprite.x = @x
      @sprite.y = @y
      @sprite.draw()

  init: ->
    return null

  step: ->
    return null

  #Checks if this entity is touching another entity
  hits: (other,x = 0,y = 0) ->
    result = Collision.check(this,other,x,y)
    return result[1]

  destroy: ->
    World.destroy this

  reset: ->
    @x = @sx
    @y = @sy

  # TODO. This should be moved to the collsion object.
  mouse_hits: ->
    return Keyboard.MOUSE_X > @x and
           Keyboard.MOUSE_X < @x+@w and
           Keyboard.MOUSE_Y > @y and
           Keyboard.MOUSE_Y < @y+@h
