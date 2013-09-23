# ## World
# The World class manages the game world and what can be seen
# by the player.
class World
  @_entities: []
  @_entities_to_destroy: [] #entites must wait to be destroyed
  @frozen: false

  # When the world is created it adds a canvas to the page and
  # inserts all the _entities that are needed into the entity array.
  @init: ->
    ctx = World.create_canvas()
    Art.init(ctx,World.art_loaded)

  #When all art has been loaded, init can continue
  @art_loaded: ->
    World.create_level()
    Keyboard.init()

  # create level
  @create_level: () ->
    for key,value of LevelData.level
      World.spawn(value.name,value.x,value.y)

  # destroy all
  @destroy_all: ->
    temp = World._entities.slice(0)
    for e in temp
      World._entities.remove e

  # reset
  @reset: ->
    @destroy_all()
    @create_level()

  # next level
  @next_level: ->
    @destory_all()
    @create_level()
    
  # get all entities
  @all_entities: ->
    return @_entities

  # Set entity to be destroied
  @destroy: (entity) ->
    World._entities_to_destroy.push entity

  # Remove all entities that are set to be destroid
  @_remove_destroyed: ->
    for e in World._entities_to_destroy
      World._entities.remove e
    World._entities_to_destroy = []

  # Spawn new
  @spawn: (name,x = 0,y = 0) ->
    entity = new AppData.entities[name]
    if entity.name == null
      entity.name = name
    
    if entity.sprite == null
      if Art.image_exists(name)
        entity.sprite = name
      else
        entity.sprite = 'PlaceHolder' #TODO: this cant be right..
    
    entity.sx = x
    entity.sy = y

    if entity.w == undefined and entity.sprite != null
      entity.w = Art.sprite_width(entity.sprite)
    if entity.h == undefined and entity.sprite != null
      entity.h = Art.sprite_height(entity.sprite)
    World._entities.push (entity)
    entity.reset()
    entity.init()
    return entity

  # Find the number of instances of a class
  @number_of: (c) ->
    return World.objectsOfClass(c).length

  # Find if there exists an instance of a class
  @exists: (c) ->
    return World.number_of c > 0

  # Create an HTML5 canvas element and append it to the document
  @create_canvas: ->
    canvas = document.createElement("canvas")
    canvas.width = Settings.width
    canvas.height = Settings.height
    $("#game").append(canvas)
    return canvas.getContext("2d")

  # Draw all the _entities
  @draw: ->
    #Draw background
    Art.color '#EFF8FB'
    Art.rectangleC 0,0,Settings.width / Art.get_scale(),Settings.height / Art.get_scale(),true

    #Sort for z values. not tested.
    World._entities.sort (a,b) ->
      return if a.z > b.z then 1 else -1
    
    #Draw all entities
    for entity in World._entities when entity.visible is true
      if Art.get_alpha() != 1
        Art.alpha 1
      entity.draw()

  # Step for all _entities
  @step:   ->
    Keyboard.step()
   
    if World.frozen == false
      for entity in World._entities
        if typeof entity.step is "function"
          entity.step()

    World._remove_destroyed()
