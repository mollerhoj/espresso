# Art
# The object that draws on the canvas
# methods that ends with C draws relative to canvas. //Are they useful?
class Art
  @offset_x = 0
  @offset_y = 0
  @_scale = 1
  @_alpha = 1
  
  @get_scale: ->
    return @_scale

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


  @rectangleC: (x,y,w,h,filled = false) ->
    if filled == true
      Game.context.fillRect(x,y,w,h)
    else
      Game.context.strokeRect(x,y,w,h)

  @rectangle: (x,y,w,h,filled = false) ->
    Art.rectangleC(x+Art.offset_x,y+Art.offset_y,w,h,filled)

