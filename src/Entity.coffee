# Parent of all entities (user created game objects)
class Entity
  #The x and y values in the world
  x: 0
  y: 0
  #The start x and y values in the world
  sx: 0
  sy: 0
  #The width/height of the object. Set by the image loader, after seeing image width/height
  w: undefined
  h: undefined
  #If false, the object is not drawen on screen
  visible: true
  #The name of the Entity, set automatically, and is not to be changed.
  name: null
  #The types this Entity belongs to. As default, it belongs to itself, but you may set it to also be type 'enemy' or 'powerup'. You can then use the collision engine to check against certain types. 
  types: []
  #Horisontal and vertical scale of the entity
  scale_x: 1
  scale_y: 1
  #The offset in the image. With offset_x n, the sprite of the Entity is drawn in position -n 
  offset_x: 0
  offset_y: 0
  #The transparency of the sprite from 0 to 1
  alpha: 1
  #The rotation in degrees
  rotation: 0
  #The sprite in the animation that is currently shown. Index 1 shows the file 'name'.png index 2 shows 'name'2.png.
  index: 1
  #The sprite that the Art object draws
  sprite: null 
  #Entities with lower z values will be drawn before those with higher z value
  z: 0

  #By default, the draw function draws the sprite of the entity, overwrite it if something different is desired.
  draw: ->
    Art.entity(this)

  #This method is called when the entity is spawned 
  init: ->
    return null

  #Step i called every step
  step: ->
    return null

  #Checks if this entity is touching another entity
  hits: (other,x = 0,y = 0) ->
    result = Collision.check(this,other,x,y)
    return result[1]

  #Destroying the entity will remove it from the world
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
        

