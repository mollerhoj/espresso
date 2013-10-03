# ## World
# The World class manages the game world and what can be seen
# by the player.
class World
  _entities: []
  _entities_to_destroy: [] #entites must wait to be destroyed
  x: 0
  y: 0
  pause: false

  # create level
  load_level: (name) ->
    level = AppData.levels[name]
    for key,value of level.data
      @spawn(value.name,value.x,value.y)

  # destroy all
  destroy_all: ->
    temp = @_entities.slice(0)
    for e in temp
      @_entities.remove e

  # reset
  reset: ->
    @destroy_all()
    @create_level()

  # next level
  next_level: ->
    @destory_all()
    @create_level()
    
  # get all entities
  all_entities: ->
    return @_entities

  # Set entity to be destroied
  destroy: (entity) ->
    @_entities_to_destroy.push entity

  # Remove all entities that are set to be destroid
  _remove_destroyed: ->
    for e in @_entities_to_destroy
      @_entities.remove e
    @_entities_to_destroy = []

  # Spawn new
  spawn: (name,x = 0,y = 0) ->
    entity = new AppData.entities[name]
    entity.world = this
    entity.sx = x
    entity.sy = y

    if entity.name == null
      entity.name = name
    
    if entity.sprite == null
      entity.sprite = new Sprite
      if Game.images[name] != null
        entity.sprite.name = name
        entity.w = Game.images[name].width
        entity.h = Game.images[name].height
      else
        entity.sprite.name = 'PlaceHolder' 

    @_entities.push (entity)
    entity.reset()
    entity.init()
    return entity

  # Find the number of instances of a class
  number_of: (c) ->
    return @objectsOfClass(c).length

  # Find if there exists an instance of a class
  exists: (c) ->
    return @number_of c > 0

  # Draw all the _entities
  draw: ->
    #Draw background
    Art.color '#EFF8FB'
    Art.rectangleC 0,0,AppData.width * AppData.scale / Art.get_scale(),AppData.height * AppData.scale / Art.get_scale(),true
    Art.color '#000000'

    #Sort for z values. not tested.
    @_entities.sort (a,b) ->
      return if a.z > b.z then 1 else -1
    
    #Draw all entities
    for entity in @_entities when entity.visible is true
      if Art.get_alpha() != 1
        Art.alpha 1
      entity.draw()

  # Step for all _entities
  step:   ->
    Keyboard.step()
   
    if @pause == false
      for entity in @_entities
        if typeof entity.step is "function"
          entity.step()

    @_remove_destroyed()
