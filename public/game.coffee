# A Utils file
# Below is baseclass extensions
# Might also have a class with helpful methods (sign?)
Array::remove = (e) ->
  @[t..t] = [] if (t = @indexOf(e)) > -1

Array::diff = (a) ->
  @filter (i) ->
    not (a.indexOf(i) > -1)

# Return a copy of the array
Array::copy = ->
  this.slice(0)

Math.sign = (n) ->
  return (if n > 0 then 1 else (if n < 0 then -1 else 0))

Array::unique = ->
  @sort().filter (v, i, o) ->
    (if i and v isnt o[i - 1] then v else 0)


Array::deepToString = ->
  result = "["
  for i in [0...this.length]
    if Object::toString.call(this[i]) is "[object Array]"
      result += this[i].deepToString()
    else if this[i]
      result += this[i]
    if i != this.length-1
      result += ","
  return result + "]"

Audio.loud = false

Audio::say = () ->
    this.play()

window.tgl = (p) ->
  if p
    return false
  else
    return true

window.toggle = (p,t,f) ->
  if p
    f()
    return false
  else
    t()
    return true


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
        



# Art
# The object that draws on the canvas
# methods that ends with C draws relative to canvas. //Are they useful?
class Art
  @images = {}
  @offset_x = 0
  @offset_y = 0
  @_font: 'Georgia'
  @_font_size: 40
  @_font_style: "" # "", bold, italic,
  @_scale = 1
  @_alpha = 1
  @_images_loaded = 0
  @callback = null
  
  # initalize the class
  @init: (canvas,callback) ->
    Art.callback = callback
    Art.canvas = canvas
    Art.canvas.textBaseline = 'top'
    Art.font_update()

    #If in development, load placeholder
    if Settings.mode == 'Development'
      Art.load('PlaceHolder','../src/gfx/PlaceHolder.png')

    #Load all sprites
    for key,value of AppData.sprites
      Art.load(key,"../src/" + AppData.game_name + "/gfx/" + value)

    Art.remove_anti_alias()
    Art.scale Settings.scale

  #Is called everytime an SpriteImage has been loaded. When all has been loaded it calls the callback function.
  @image_loaded: ->
    Art._images_loaded +=1
    number_of_images = Object.keys(AppData.sprites).length
    if Art._images_loaded == number_of_images
      Art.callback() #Makes the init of the game continue after all images are loaded

  #Make zooming look pretty
  @remove_anti_alias: ->
    Art.canvas.imageSmoothingEnabled = false # Spec
    Art.canvas.mozImageSmoothingEnabled = false # Mozilla
    Art.canvas.webkitImageSmoothingEnabled = false # Chrome / Safari

  @get_scale: ->
    return @_scale

  @scale: (rate) ->
    Art.canvas.scale(rate/Art._scale,rate/Art._scale)
    Art._scale = rate

  @load: (name,file) ->
    Art.images[name] = new SpriteImage(file)

  @image_exists: (name) ->
    return Art.images[name] != null

  @_image: (name,index = 1) ->
    if index != 1
      name = name + index
    result = Art.images[name]
    if not result
      result = Art.images['PlaceHolder']
    return result

  @entity: (e) ->
    Art.entityC(e,Art.offset_x,Art.offset_y)

  @entityC: (e,offset_x = 0,offset_y = 0) ->
    x = e.x + offset_x - e.offset_x
    y = e.y + offset_y - e.offset_y
    i = Art._image(e.sprite,e.index)
    if e.rotation == 0 and e.scale_x == 1 and e.scale_y == 1
      Art.canvas.drawImage(i.image,0,0,i.w,i.h,x,y,i.w,i.h)
    else
      Art.canvas.save()
      Art.canvas.translate(x+i.w/2,y+i.h/2)
      Art.canvas.scale(e.scale_x,e.scale_y)
      Art.canvas.rotate(Math.PI/180*e.rotation)
      Art.canvas.drawImage(i.image,0,0,i.w,i.h,-i.w/2,-i.h/2,i.w,i.h)
      Art.canvas.restore()

  @sprite_width: (name) ->
    Art._image(name).w

  @sprite_height: (name) ->
    Art._image(name).h

  @line: (x,y,x2,y2) ->
    Art.lineC(x+Art.offset_x,y+Art.offset_y,x2+Art.offset_x,y2+Art.offset_y)

  @get_alpha: ->
    return Art._alpha

  @alpha: (alpha) ->
    Art._alpha = alpha
    Art.canvas.globalAlpha = alpha

  @lineC: (x,y,x2,y2) ->
    Art.canvas.beginPath()
    Art.canvas.moveTo(x+0.5,y+0.5)
    Art.canvas.lineTo(x2+0.5,y2+0.5)
    Art.canvas.stroke()

  @color: (color) ->
    Art.canvas.fillStyle = color
    Art.canvas.strokeStyle = color

  @fill_color: (color) ->
    Art.canvas.fillStyle = color

  @stroke_color: (color) ->
    Art.canvas.strokeStyle = color

  @font: (font) ->
    Art._font = font
    Art.font_update()

  @font_size: (font_size) ->
    Art._font_size = font_size
    Art.font_update()

  @font_style: (font_style) ->
    Art._font_style = font_style
    Art.font_update()

  @font_update: ->
    Art.canvas.font = Art._font_style + " " + Art._font_size + " " + Art._font

  @text: (string,x,y,rotation = 0) ->
    Art.textC(string,x+Art.offset_x,y+Art.offset_y,rotation)

  @textC: (string,x,y,rotation = 0) ->
    if rotation != 0
        Art.canvas.save()
        Art.canvas.translate(x+Art.text_width(string)/2,y+Art.font_size/2)
        Art.canvas.rotate(Math.PI/180*rotation)
        Art.canvas.fillText(string,-Art.text_width(string)/2,-Art.font_size/2)
        Art.canvas.restore()
    else
        Art.canvas.fillText(string, x, y)

  @text_width: (string) ->
    Art.font_update()
    return Art.canvas.measureText(string).width

  @text_height: (string) ->
    Art.font_update()
    return @_font_size

  @rectangleC: (x,y,w,h,filled = false) ->
    if filled == true
      Art.canvas.fillRect(x,y,w,h)
    else
      Art.canvas.strokeRect(x,y,w,h)

  @rectangle: (x,y,w,h,filled = false) ->
    Art.rectangleC(x+Art.offset_x,y+Art.offset_y,w,h,filled)



class Collision extends Entity
  
    # Check for collision between two objects
    @check: (type1,type2,x,y) ->

      objects1 = []
      objects2 = []

      if typeof type1 == 'object'
        objects1.push type1
      if typeof type2 == 'object'
        objects2.push type2
      
      for e in World.all_entities()
        if e.name == type1 or e.types.indexOf(type1) != -1
          objects1.push e
        if e.name == type2 or e.types.indexOf(type2) != -1
          objects2.push e

      # check for collision (between two squares)
      for o1 in objects1
        for o2 in objects2
          if ((o1.x+x <= o2.x and o1.x+x + o1.w > o2.x) or
             (o1.x+x >= o2.x and o1.x+x < o2.x + o2.w)) and
             ((o1.y+y <= o2.y and o1.y+y + o1.h > o2.y) or
             (o1.y+y >= o2.y and o1.y+y < o2.y + o2.h))
              return [o1,o2]
      return false



# ## Game
# The game class handles top level game loop and initialisation.
class Game

  run: =>
    World.init()
    if Settings.mode == 'Development'
      Toolbox.init()
    setInterval(@main, 16)

  main: =>
    World.step()
    World.draw()
    if Settings.mode == 'Development'
      Toolbox.step()
      Toolbox.draw()



# Keyboard
# Responsible for dealing with keyboard and mouse input
class Keyboard
  @_keyCodes:
    'BACKSPACE': 8
    'TAB': 9
    'ENTER': 13
    'SHIFT': 16
    'CTRL': 17
    'ALT': 18
    'CAPSLOCK': 20
    'ESCAPE': 27
    'SPACE' : 32
    'END': 35
    'HOME': 36
    'LEFT': 37
    'UP': 38
    'RIGHT': 39
    'DOWN':	40
    'INSERT': 45
    'DELETE': 46
    '0': 48
    '1': 49
    '2': 50
    '3': 51
    '4': 52
    '5': 53
    '6': 54
    '7': 55
    '8': 56
    '9': 57
    'A': 65
    'B': 66
    'C': 67
    'D': 68
    'E': 69
    'F': 70
    'G': 71
    'H': 72
    'I': 73
    'J': 74
    'K': 75
    'L': 76
    'M': 77
    'N': 78
    'O': 79
    'P': 80
    'Q': 81
    'R': 82
    'S': 83
    'T': 84
    'U': 85
    'V': 86
    'W': 87
    'X': 88
    'Y': 89
    'Z': 90
    'MULTIPLY': 106
    'ADD': 107
    'SUBTRACT': 109
    'MOUSE_LEFT': 'MOUSE_LEFT'
    'MOUSE_MIDDLE' : 'MOUSE_MIDDLE'
    'MOUSE_RIGHT' : 'MOUSE_RIGHT'
  
  @_pre_pressed: []
  @_pre_released: []
  @_pressed: []
  @_released: []
  @_hold: []

# Listen for keys being presses and being released. As this happens
  # add and remove them from the key store.
  @init: ->
    $("body").keydown (e) =>
      Keyboard.key_pressed(e.keyCode)
    $("body").keyup (e) =>
      Keyboard.key_released(e.keyCode)
    $("#game").mousemove(Keyboard.mouse_move)
    $("#game").mousedown(Keyboard.mouse_down)
    $("#game").mouseup(Keyboard.mouse_up)
    $("#game").bind "contextmenu", (e) -> return false # remove contextmenu

  @key_released: (c) ->
    Keyboard._pre_released.push c

  @key_pressed: (c) ->
    Keyboard._pre_pressed.push c

  @mouse_down: (e) ->
    switch e.button
      when 0 then Keyboard._pre_pressed.push 'MOUSE_LEFT'
      when 1 then Keyboard._pre_pressed.push 'MOUSE_MIDDLE'
      when 2 then Keyboard._pre_pressed.push 'MOUSE_RIGHT'
    return false #to disable default drag in canvas

  @mouse_up: (e) ->
    switch e.button
      when 0 then Keyboard._pre_released.push 'MOUSE_LEFT'
      when 1 then Keyboard._pre_released.push 'MOUSE_MIDDLE'
      when 2 then Keyboard._pre_released.push 'MOUSE_RIGHT'
    return false #to disable default drag in canvas

  @mouse_move: (e) ->
    Keyboard.MOUSE_XC = e.offsetX / Art.get_scale()
    Keyboard.MOUSE_YC = e.offsetY / Art.get_scale()
    Keyboard.MOUSE_X = (Keyboard.MOUSE_XC - Art.offset_x)
    Keyboard.MOUSE_Y = (Keyboard.MOUSE_YC - Art.offset_y)

  @hold: (keyName) ->
    return Keyboard._hold.indexOf(Keyboard._keyCodes[keyName]) != -1

  @press: (keyName) ->
    return Keyboard._pressed.indexOf(Keyboard._keyCodes[keyName]) != -1
    
  @release: (keyName) ->
    return Keyboard._released.indexOf(Keyboard._keyCodes[keyName]) != -1
    
  @step: ->
    Keyboard._pressed = Keyboard._pre_pressed.splice(0)
    Keyboard._released = Keyboard._pre_released.splice(0)
    Keyboard._hold = Keyboard._hold.concat(Keyboard._pressed)
    Keyboard._hold = Keyboard._hold.diff(Keyboard._released)
    Keyboard._pre_pressed = []
    Keyboard._pre_released = []



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


# Menu
class Menu extends Entity
  
  active: true
  _buttons: []
  space_between_buttons: 2
  selected_button: null
  type: "radio" #radio, checkbox
  valign: 'up' #down

  constructor: ->
    @_buttons = []

  add_button: (button) ->
    button.add_listener(this)
    @_buttons.push(button)

  clear_buttons: ->
    @_buttons = []

  step: ->
    if not @active then return
    @h = 0
    for button in @_buttons
      button.sy = @y+@h
      h_jump = button.h+(@space_between_buttons / Art.get_scale())
      if @valign == 'up'
        button.sy-= @_buttons.length*h_jump
        button.sx = @x
      @h+=h_jump
      button.step()

  button_press: (button_clicked) ->
    @selected_button = button_clicked
    #deselect others if radiobuttons
    if @type == "radio"
      for button in @_buttons
        if button != button_clicked
          button.deselect()

  draw: ->
    if @active == false then return
    for button in @_buttons
      button.draw()



# Button
class Button extends Entity
  text: ""
  font_size: 20
  font: null
  font_style: ""
  _listeners: []
  _selected: false
  _char_width: 0
  _char_height: 0
  x: -100 # fixes weird blinking, might need a check
  y: -100

  constructor: ->
    @_listeners = [] #TODO: Dont understand why I need to do this?
    @_set_font_style()
    @_cal_width()

  _cal_width: ->
    @_char_width = Art.text_width 'M'
    @_char_height = Art.text_height 'M'
    @w = @_char_width + Art.text_width @text
    @h = @_char_height/2 + @_char_height

  add_listener: (listener) ->
    @_listeners.push(listener)

  # Setting the font style for button. Must be done before drawing and calculating width 
  _set_font_style: ->
    Art.font_size @font_size / Art.get_scale()
    if @font
      Art.font @font
    Art.font_style @font_style

  step: ->
    @x = -Art.offset_x + @sx
    @y = -Art.offset_y + @sy

    if @mouse_hits() == true and @visible == true
      if Keyboard.press('MOUSE_LEFT')
        @button_pressed()
      if Keyboard.release('MOUSE_LEFT')
        @button_released()

  button_pressed: ->
    @_selected = true
    for listener in @_listeners
      listener.button_press(this)

  button_released: ->
    for listener in @_listeners
      listener.button_release(this)

  deselect: ->
    @_selected = false

  draw: ->
    if @_selected
      Art.fill_color 'DarkGray'
    else
      Art.fill_color 'LightGray'

    @_set_font_style()
    @_cal_width()
    Art.rectangle @x,@y,@w,@h,true
    Art.fill_color 'Black'
    Art.text(@text,@x+@_char_width/2,@y+@_char_height/4)


class Board extends Entity

  grid= [['Hero','Skull'],['Hero','Skull'],['Skull','Skull']]
  cell_width = 32
  cell_height = 32
  
  create: ->
    for subgrid,x in grid
      for element,y in subgrid
        World.spawn(element,x*cell_width,y*cell_height)

  step: ->
    if Keyboard.press('SPACE')
      @create()

  draw: ->
    super
    Art.fill_color 'Black'
    x = 0
    for subgrid,x in grid
      for element,y in subgrid
        Art.text(element,x*70,y*10)



class Explosion extends Entity

  time: 0

  step: ->
    @time +=1
    @index = 1 + @time
    
    if @time > 3
      @destroy()


class Fireball extends Entity
  time: 0

  step: ->
      @time += 1
      @x += Math.cos(@direction/180*Math.PI)*5
      @y -= Math.sin(@direction/180*Math.PI)*5

      if @time > 15
        World.spawn('Explosion',@x,@y)
        @destroy()

  draw: ->
      @index = 1 + @direction/45
      super





class GameMenu extends Menu

  main_menu:
    title: 'MAIN MENU'
    buttons:
      play:
        title: 'PLAY'
        buttons:
          back:
            title: '<BACK'
            action: (x) -> x.load(x.main_menu)
      options:
        title: 'OPTIONS'
        buttons:
          back:
            title: '<BACK'
            action: (x) -> x.load(x.main_menu)
          sound:
            title: 'SOUND'
            action: (x) -> this
          music:
            title: 'MUSIC'
            actoin: (x) -> this

  current: null
  font: 'Dosis'
  
  constructor:->
    super
    space_between_buttons = 2 #TODO overwrite variables?
    @load(@main_menu)

  load: (tree) ->
    @clear_buttons()
    @current = tree
    for key, value of @current.buttons
      b = new Button
      b.text = value.title
      b.font = @font
      @add_button(b)

  button_release: (button_clicked) ->
    for key, value of @current.buttons
      if value.title == button_clicked.text
        if value.hasOwnProperty('buttons')
          @load(value)
        else
          value.action(this)


class Hero extends Entity

  direction: 0
  move: 'WALKING' #STANDING JUMPING ETC
  animation: 0
  fireball_sound: null

  init: ->
    console.log 'hero created'
    @fireball_sound = new Audio('sfx/dao.wav')

  step: ->
    face_x = 0
    face_y = 0
    if Keyboard.hold('RIGHT')
      face_x +=1
    if Keyboard.hold('LEFT')
      face_x -=1
    if Keyboard.hold('UP')
      face_y -=1
    if Keyboard.hold('DOWN')
      face_y +=1

    @move = 'WALKING'

    if face_x == -1
      if face_y == -1
        @direction = 90+45
      if face_y == 0
        @direction = 180
      if face_y == 1
        @direction = 180+45
    
    if face_x == 0
      if face_y == -1
        @direction = 90
      if face_y == 0
        @move = 'STANDING'
      if face_y == 1
        @direction = 270

    if face_x == 1
      if face_y == -1
        @direction = 45
      if face_y == 0
        @direction = 0
      if face_y == 1
        @direction = 270+45

    @scale_x = 1

    if @direction == 0
      @index = 5

    if @direction == 45
      @index = 7

    if @direction == 90
      @index = 9

    if @direction == 90+45
      @index = 7
      @scale_x = -1

    if @direction == 180
      @index = 5
      @scale_x = -1

    if @direction == 180+45
      @index = 3
      @scale_x = -1

    if @direction == 270
      @index = 1

    if @direction == 270+45
      @index = 3

    if @animation > 20
      @animation = 0

    if @animation > 10
      @index +=1

    if @move == 'WALKING'
      @animation += 1
      #@x += Math.cos(@direction/180*Math.PI)
      #@y -= Math.sin(@direction/180*Math.PI)

    if Keyboard.press('M')
      Audio.loud = tgl(Audio.loud)
    
    #@fireball_sound.muted = tgl(@fireball_sound.muted)

    if Keyboard.press('X')
      @fireball_sound.say()
      f = World.spawn('Fireball',@x,@y)
      f.direction = @direction




class Skull extends Entity

  direction: 0

  speed: 2

  step: ->
      @x += Math.cos(@direction/180*Math.PI)*@speed
      @y -= Math.sin(@direction/180*Math.PI)*@speed

      if @x < 0
        @direction = 0

      if @y < 0
        @direction = 270

      if @x > 320
        @direction = 180

      if @y > 240
        @direction = 90



# Grid
class Grid
  sx: 0
  sy: 0
  visible: false
  offset_x: 0
  offset_y: 0
  cell_width: 0
  cell_height: 0

  step: ->
    return null

  constructor: ->
    @offset_x= Settings.grid.offset_x
    @offset_y= Settings.grid.offset_y
    @cell_width= Settings.grid.cell_width
    @cell_height= Settings.grid.cell_height

  offset: (x,y) ->
    @offset_x = x % @cell_width
    @offset_y = y % @cell_height

  draw: ->
    rx = @offset_x-@cell_width*2+Art.offset_x % @cell_width
    ry = @offset_y-@cell_height*2+Art.offset_y % @cell_height
    cell_width_number = Math.floor(Settings.width / @cell_width / Art.get_scale()) + 3
    cell_height_number = Math.floor(Settings.height / @cell_height / Art.get_scale()) + 3
    horizontal_lines_length = (Settings.width+3*@cell_width) / Art.get_scale() + 60 #+60 is there to fix deep zoom level bug.. 
    vertical_lines_length = (Settings.height+3*@cell_height) / Art.get_scale() + 60
    Art.stroke_color('Gray')
    Art.alpha 0.5
    for x in [0...cell_width_number]
      Art.lineC(rx+x*@cell_width,ry,rx+x*@cell_width,ry+vertical_lines_length)
    for y in [0...cell_height_number]
      Art.lineC(rx,ry+y*@cell_height,rx+horizontal_lines_length,ry+y*@cell_height)
    Art.alpha 1
    


# Menu
class ParentEntityMenu extends Entity
  
  active: true
  _buttons: []
  space_between_buttons: 2
  selected_button: null
  type: "radio" #radio, checkbox

  add_button: (button) ->
    button.add_listener(this)
    @_buttons.push(button)

  step: ->
    if not @active then return
    @h = 0
    for button in @_buttons
      button.sy = @y+@h
      @h+=button.h+(@space_between_buttons / Art.get_scale())
      button.step()

  button_press: (button_clicked) ->
    @selected_button = button_clicked
    #deselect others if radiobuttons
    if @type == "radio"
      for button in @_buttons
        if button != button_clicked
          button.deselect()

  draw: ->
    if @active == false then return
    for button in @_buttons
      button.draw()



class EntityMenu extends ParentEntityMenu
  
  constructor:->
    super
    space_between_buttons = 2 #TODO overwrite variables?
    for key, value of AppData.entities
      b = new EntityButton
      b.text = key
      b = @add_button(b)


class Toolbox
  @tools_menu: []
  @tools_editor: []
  @tools_always: []
  @levelEditor: null
  @grid: null
  @cameraMan: null
  @_active: false
  @_menu: false

  @init: ->
    Toolbox.add_tools()
    Toolbox.deactivate()

  @add_tools: ->
    grid = new Grid
    Toolbox.tools_always.push(grid)
    Toolbox.tools_always.push(new CameraMan)
    entityMenu = new EntityMenu
    Toolbox.tools_menu.push(entityMenu)
    leveleditor = new LevelEditor(entityMenu)
    leveleditor.grid = grid
    Toolbox.tools_editor.push(leveleditor)

  @deactivate: ->
    Toolbox._active = false
    for tool in Toolbox.tools_always
      tool.active = false
    for tool in Toolbox.tools_editor
      tool.active = false
    Toolbox.menuOff()
    World.frozen = false

  @activate: ->
    Toolbox._active = true
    for tool in Toolbox.tools_always
      tool.active = true
    Toolbox.menuOn()
    World.frozen = true
    World.reset()

  @menuOn: ->
    Toolbox._menu = true
    for tool in Toolbox.tools_menu
      tool.active = true
    for tool in Toolbox.tools_editor
      tool.active = false

  @menuOff: ->
    Toolbox._menu = false
    for tool in Toolbox.tools_menu
      tool.active = false
    for tool in Toolbox.tools_editor
      tool.active = true

  @step: ->
    if Keyboard.press('L') then Toolbox._active = toggle(Toolbox._active,Toolbox.activate,Toolbox.deactivate)

    if Toolbox._active == false then return

    if Keyboard.press('SPACE') then Toolbox._menu = toggle(Toolbox._menu,Toolbox.menuOn,Toolbox.menuOff)

    for tool in Toolbox.tools_always
      tool.step()
    for tool in Toolbox.tools_menu
      tool.step()
    for tool in Toolbox.tools_editor
      tool.step()

  @draw: ->
    if Toolbox._active == false then return
    
    for tool in Toolbox.tools_always
      tool.draw()
    for tool in Toolbox.tools_menu
      tool.draw()
    for tool in Toolbox.tools_editor
      tool.draw()





# Level Editor
class LevelEditor
  _visible: false
  hold: null
  active: false
  menu: null
  grid: null

  #The constructor takes the menu that determins the leveleditors choices
  constructor: (menu) ->
    @menu = menu

  step: ->
    if not @active then return
    
    # Create objects
    if Keyboard.press('MOUSE_LEFT')
      @hold = World.spawn(@menu.selected_button.text,Keyboard.MOUSE_X,Keyboard.MOUSE_Y)
    if @hold
      @hold.x = Keyboard.MOUSE_X
      @hold.y = Keyboard.MOUSE_Y
      if Keyboard.hold('SHIFT') and @grid
        @hold.x -= (Keyboard.MOUSE_X - @grid.offset_x) % @grid.cell_width
        @hold.y -= (Keyboard.MOUSE_Y - @grid.offset_y) % @grid.cell_height
      @hold.sx = @hold.x
      @hold.sy = @hold.y

    if Keyboard.release('MOUSE_LEFT')
      LevelPrinter.print()
      @hold = null

    # Destroy objects
    if Keyboard.hold('MOUSE_RIGHT')
      temp_all_entities = World.all_entities().slice(0)
      for e in temp_all_entities when e.mouse_hits()
        e.destroy()
      LevelPrinter.print()

  draw: -> #TODO perhaps make a tool class to extend from with a filler draw method.


# This should be replaced with DOM elements, and should therefore be obsolete.
class EntityButton extends Entity
  text: ""
  font_size: 20
  font: "Times New Roman"
  font_style: ""
  _listeners: []
  _selected: false
  _char_width: 0
  _char_height: 0

  # A button is initaliced with the its text
  constructor: ->
    @_listeners = [] #TODO: Dont understand why I need to do this?
    @_set_font_style()
    @_cal_width()

  _cal_width: ->
    @_char_width = Art.text_width 'M'
    @_char_height = Art.text_height 'M'
    @w = @_char_width + Art.text_width @text
    @h = @_char_height/2 + @_char_height

  add_listener: (listener) ->
    @_listeners.push(listener)

  # Setting the font style for button. Must be done before drawing and calculating width 
  _set_font_style: ->
    Art.font_size @font_size / Art.get_scale()
    Art.font @font
    Art.font_style @font_style

  step: ->
    @x = -Art.offset_x + @sx
    @y = -Art.offset_y + @sy

    if @mouse_hits() == true
      if Keyboard.press('MOUSE_LEFT') and @visible == true
        @select()

  select: ->
    @_selected = true
    for listener in @_listeners
      listener.button_press(this)

  deselect: ->
    @_selected = false

  draw: ->
    if @_selected
      Art.fill_color 'DarkGray'
    else
      Art.fill_color 'LightGray'

    @_set_font_style()
    @_cal_width()
    Art.rectangle @x,@y,@w,@h,true
    Art.fill_color 'Black'
    Art.text(@text,@x+@_char_width/2,@y+@_char_height/4)


class LevelPrinter

  @get_board: ->
    cell_width= Settings.grid.cell_width
    cell_height= Settings.grid.cell_height
    board = []
    
    for e in World.all_entities()
      if e.sx % cell_width == 0 and e.sy % cell_height == 0
        subboard = board[e.sx/cell_width]
        if not subboard
          subboard = []
        subboard[e.sy/cell_height] = e.name
        board[e.sx/cell_width] = subboard
    return board

  @print: ->
    i = 1
    txt = ''
    newline = "&#10;"
    
    LevelData.level = new Object()

    # If these lines are uncommented, all entites that alignes with the grid
    # will get printed as a board variable.
    #board = LevelPrinter.get_board()
    #LevelData.level[0] = board
    #txt += '    board: ' + board.deepToString() + newline

    for e in World.all_entities()
      txt += "    " + i + ":" + newline
      txt += "      name: '" + e.name + "'" + newline
      txt += '      x: ' + e.sx + newline
      txt += '      y: ' + e.sy + newline

      o = new Object()
      o.name = e.name
      o.x = e.sx
      o.y = e.sy
      LevelData.level[i] = o
      i += 1

    $('#output').html(txt)


class EntityMenu extends ParentEntityMenu
  
  constructor:->
    super
    space_between_buttons = 2 #TODO overwrite variables?
    for key, value of AppData.entities
      b = new EntityButton
      b.text = key
      b = @add_button(b)


class CameraMan

    step: ->
      if Keyboard.hold('UP')
        Art.offset_y += 8
      if Keyboard.hold('DOWN')
        Art.offset_y -= 8
      if Keyboard.hold('LEFT')
        Art.offset_x += 8
      if Keyboard.hold('RIGHT')
        Art.offset_x -= 8
      
      if Keyboard.press('0')
        Art.offset_x = 0
        Art.offset_y = 0
        Art.scale Settings.scale 

      if Keyboard.hold('1')
        Art.scale (Math.min(10,Art.get_scale()+0.1))

      if Keyboard.hold('2')
        Art.scale (Math.max(0.01,Art.get_scale()-0.1))

    draw: -> #TODO perhaps make a tool class to extend from with a filler draw method.




class AppData
  @game_name = "fighter"
  @entities:
   'Board': Board
   'Explosion': Explosion
   'Fireball': Fireball
   'GameMenu': GameMenu
   'Hero': Hero
   'Skull': Skull
  @sprites:
   'Board': 'Board.png'
   'Explosion': 'Explosion.png'
   'Explosion2': 'Explosion2.png'
   'Explosion3': 'Explosion3.png'
   'Explosion4': 'Explosion4.png'
   'Fireball': 'Fireball.png'
   'Fireball2': 'Fireball2.png'
   'Fireball3': 'Fireball3.png'
   'Fireball4': 'Fireball4.png'
   'Fireball5': 'Fireball5.png'
   'Fireball6': 'Fireball6.png'
   'Fireball7': 'Fireball7.png'
   'Fireball8': 'Fireball8.png'
   'Hero': 'Hero.png'
   'Hero10': 'Hero10.png'
   'Hero2': 'Hero2.png'
   'Hero3': 'Hero3.png'
   'Hero4': 'Hero4.png'
   'Hero5': 'Hero5.png'
   'Hero6': 'Hero6.png'
   'Hero7': 'Hero7.png'
   'Hero8': 'Hero8.png'
   'Hero9': 'Hero9.png'
   'Skull': 'Skull.png'


# SpriteImage
# Wraps sprite loading.
class SpriteImage

  # Create a new image based on the sprite file and set
  # ready to true when loaded.
  constructor: (url) ->
    image = new Image
    image.src = url
    image.onload = => @loaded()
    @image = image

  loaded: ->
    Art.image_loaded()
    @h = @image.height
    @w = @image.width


# Start the game. This must be loaded after everything else

$ = Zepto

$ -> 
  game = new Game
  game.run()



class Settings
  @mode: 'Development'
  @width: 640
  @height: 480
  @scale: 2
  @background: 'Background'
  @grid:
    offset_x: 0
    offset_y: 0
    cell_width: 32
    cell_height: 32


# LevelData
# Store levels here. 'level' will be loaded as default
class LevelData
  @level:
    1:
      name: 'Hero'
      x: 138
      y: 103
    2:
      name: 'GameMenu'
      x: 20
      y: 220


class EditorData
  @data:
    Item:
      1:
        cake: 'Block'
      2:
        cake: 'Goal'
