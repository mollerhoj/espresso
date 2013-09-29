# Grid
class Grid
  sx: 0
  sy: 0
  visible: false
  x: 0
  y: 0
  width: 0
  height: 0
  world_x: 0
  world_y: 0

  constructor: ->
    @x= 0
    @y= 0
    @width= 16
    @height= 16

  offset: (x,y) ->
    @x = x % @width
    @y = y % @height

  draw: ->
    if @visible and @height > 1 and @width > 1
      rx = @x-@width*2+@world_x % @width
      ry = @y-@height*2+@world_y % @height
      width_number = Math.floor(AppData.width*AppData.scale/ @width / Game.zoom_level) + 3
      height_number = Math.floor(AppData.height*AppData.scale / @height / Game.zoom_level) + 3
      vertical_lines_length = (AppData.height*AppData.scale+3*@height) / Game.zoom_level + 60
      horizontal_lines_length = (AppData.width*AppData.scale+3*@width) / Game.zoom_level + 60 #+60 is there to fix deep zoom level bug.. 
      console.log Game.zoom_level
      Art.stroke_color('Gray')
      Art.alpha 0.5
      for x in [0...width_number]
        Art.lineC(rx+x*@width,ry,rx+x*@width,ry+vertical_lines_length)
      for y in [0...height_number]
        Art.lineC(rx,ry+y*@height,rx+horizontal_lines_length,ry+y*@height)
      Art.alpha 1
    
