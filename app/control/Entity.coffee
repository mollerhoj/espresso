# Parent of all entities (user created game objects)
class Entity
  x: 0
  y: 0
  sx: 0
  sy: 0
  w: undefined
  h: undefined
  r: 0
  visible: true
  name: null
  scale_x: 1
  scale_y: 1
  offset_x: 0
  offset_y: 0
  alpha: 1
  rotation: 0
  index: 1
  sprite: null 
  world: null
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

  move_towards: (x,y,speed) ->
    #dir = @direction_to(x,y)
    
    
  direction_to: (x,y) ->
    #dx = x - @x;
    #dy = y - @y;
    

  #Checks if this entity is touching another entity
  hits: (other,x = 0,y = 0) ->
    @x += x
    @y += y
    result = null #@collision(this,other,x,y)
    @x -= x
    @y -= y
    return result

  hit: (c) ->
    for e in @world.all_entities()
      if e.name == c
        if @objects_touch(this,e)
          return e
    return null

  objects_touch: (obj1,obj2) ->
    return @objects_distance(obj1,obj2) <= obj1.r+obj2.r

  objects_distance: (obj1,obj2) ->
    return @points_distance(obj1.x,obj1.y,obj2.x,obj2.y)

  points_distance: (x1,y1,x2,y2) ->
    return Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2))

  destroy: ->
    @world.destroy this

  reset: ->
    @x = @sx
    @y = @sy

  # TODO. This should be moved to the collsion object.
  mouse_hits: ->
    return Keyboard.MOUSE_X > @x-@w/2 and
           Keyboard.MOUSE_X < @x+@w/2 and
           Keyboard.MOUSE_Y > @y-@h/2 and
           Keyboard.MOUSE_Y < @y+@h/2
