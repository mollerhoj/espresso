class Text
  x: 0
  y: 0
  visible: true
  scale_x: 1
  scale_y: 1
  alpha: 1
  rotation: 0
  index: 1
  z: 0
  name: null

  font: 'Dosis'
  font_size: 16 
  font_style: "" # "", bold, italic,
  string: ''

  constructor: (string='',x=0,y=0) ->
    @string = string
    @x = x
    @y = y

  draw: ->
    @_update()

    if @rotation != 0
      Game.context.save()
      Game.context.translate(@x+@get_width()/2,@y+@get_height()/2)
      Game.context.rotate(Math.PI/180*@rotation)
      Game.context.fillText(@string,-@get_width()/2,-@get_height()/2)
      Game.context.restore()
    else
      Game.context.fillText(@string, @x, @y)

  get_width: ->
    @_update()
    return Game.context.measureText(@string).width

  get_height: ->
    return @font_size

  _update: ->
    Game.context.font = @font_style + " " + @font_size + " " + @font

