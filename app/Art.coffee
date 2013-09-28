# Art
# The object that draws on the canvas
# methods that ends with C draws relative to canvas. //Are they useful?
class Art
  @offset_x = 0
  @offset_y = 0
  @_font: 'Dosis'
  @_font_size: 16 
  @_font_style: "" # "", bold, italic,
  @_scale = 1
  @_alpha = 1
  
  # initalize the class
  @init: ->
    Game.context.textBaseline = 'top'
    Art.font_update()
    Art.remove_anti_alias()
    Art.scale AppData.scale

  #Make zooming look pretty
  @remove_anti_alias: ->
    Game.context.imageSmoothingEnabled = false # Spec
    Game.context.mozImageSmoothingEnabled = false # Mozilla
    Game.context.webkitImageSmoothingEnabled = false # Chrome / Safari

  @get_scale: ->
    return @_scale

  @scale: (rate) ->
    Game.context.scale(rate/Art._scale,rate/Art._scale)
    Art._scale = rate

  @image_exists: (name) ->
    return Game.images[name] != null

  @_image: (name,index = 1) ->
    if index != 1
      name = name + index
    result = Game.images[name]
    if not result
      console.log name
      result = Game.images['PlaceHolder']
    return result

  @entity: (e) ->
    Art.entityC(e,Art.offset_x,Art.offset_y)

  @entityC: (e,offset_x = 0,offset_y = 0) ->
    x = e.x + offset_x - e.offset_x
    y = e.y + offset_y - e.offset_y
    i = Art._image(e.sprite,e.index)
    if e.rotation == 0 and e.scale_x == 1 and e.scale_y == 1
      Game.context.drawImage(i,0,0,i.width,i.height,x,y,i.width,i.height)
    else
      Game.context.save()
      Game.context.translate(x+i.width/2,y+i.height/2)
      Game.context.scale(e.scale_x,e.scale_y)
      Game.context.rotate(Math.PI/180*e.rotation)
      Game.context.drawImage(i,0,0,i.width,i.height,-i.width/2,-i.height/2,i.width,i.height)
      Game.context.restore()

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
    Game.context.globalAlpha = alpha

  @lineC: (x,y,x2,y2) ->
    Game.context.beginPath()
    Game.context.moveTo(x+0.5,y+0.5)
    Game.context.lineTo(x2+0.5,y2+0.5)
    Game.context.stroke()

  @color: (color) ->
    Game.context.fillStyle = color
    Game.context.strokeStyle = color

  @fill_color: (color) ->
    Game.context.fillStyle = color

  @stroke_color: (color) ->
    Game.context.strokeStyle = color

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
    Game.context.font = Art._font_style + " " + Art._font_size + " " + Art._font

  @text: (string,x,y,rotation = 0) ->
    Art.textC(string,x+Art.offset_x,y+Art.offset_y,rotation)

  @textC: (string,x,y,rotation = 0) ->
    if rotation != 0
        Game.context.save()
        Game.context.translate(x+Art.text_width(string)/2,y+Art.font_size/2)
        Game.context.rotate(Math.PI/180*rotation)
        Game.context.fillText(string,-Art.text_width(string)/2,-Art.font_size/2)
        Game.context.restore()
    else
        Game.context.fillText(string, x, y)

  @text_width: (string) ->
    Art.font_update()
    return Game.context.measureText(string).width

  @text_height: (string) ->
    Art.font_update()
    return @_font_size

  @rectangleC: (x,y,w,h,filled = false) ->
    if filled == true
      Game.context.fillRect(x,y,w,h)
    else
      Game.context.strokeRect(x,y,w,h)

  @rectangle: (x,y,w,h,filled = false) ->
    Art.rectangleC(x+Art.offset_x,y+Art.offset_y,w,h,filled)

