# Grid
class Grid
  sx: 0
  sy: 0
  visible: false
  x: 0
  y: 0
  width: 16
  height: 16
  world_x: 0
  world_y: 0

  constructor: ->
    @visible = AppData.grid_on

    #   rx = @x-@width*2+@world_x % @width
    #   ry = @y-@height*2+@world_y % @height
    #   width_number = Math.floor(AppData.width*AppData.scale/ @width / Game.zoom_level)
    #   height_number = Math.floor(AppData.height*AppData.scale / @height / Game.zoom_level)
    #   #+60 is there to fix deep zoom level bug.. 
    #   vertical_lines_length = (AppData.height*AppData.scale*@height) / Game.zoom_level
    #   horizontal_lines_length = (AppData.width*AppData.scale*@width) / Game.zoom_level
    #   Art.stroke_color('Gray')
    #   Art.alpha 0.5
    #   for x in [0...width_number]
    #     Art.lineC(rx+x*@width,ry,rx+x*@width,ry+vertical_lines_length)
    #   for y in [0...height_number]
    #     Art.lineC(rx,ry+y*@height,rx+horizontal_lines_length,ry+y*@height)
    #   Art.alpha 1

  draw: ->
    if @visible and @height > 1 and @width > 1
      Art.stroke_color('Gray')
      Art.alpha 0.5
      line_x_n = AppData.width/@width
      line_y_n = AppData.height/@height
      for i in [0...line_x_n]
        x = @x+i*@width
        Art.lineC(x,@y,x,@y+line_y_n*@height)
      for i in [0...line_y_n]
        y = @y+i*@height
        Art.lineC(@x,y,@x+line_x_n*@width,y)
      Art.alpha 1
