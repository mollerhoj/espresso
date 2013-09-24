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

    #Load all sprites
    for key,value of AppData.sprites
      Art.load(key,"sprites/" + value)

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
      console.log name
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

