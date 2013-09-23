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
    
