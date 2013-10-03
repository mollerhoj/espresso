class Sprite
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

  draw: ->
    image = @_get_image()
    x = @x - image.width/2 + Art.offset_x
    y = @y - image.height/2 + Art.offset_y
    if @rotation == 0 and @scale_x == 1 and @scale_y == 1
      Game.context.drawImage(image,0,0,image.width,image.height,x,y,image.width,image.height)
    else
      Game.context.save()
      Game.context.translate(x+image.width/2,y+image.height/2)
      Game.context.scale(@scale_x,@scale_y)
      Game.context.rotate(Math.PI/180*@rotation)
      Game.context.drawImage(image,0,0,image.width,image.height,-image.width/2,-image.height/2,image.width,image.height)
      Game.context.restore()


  _get_image: ->
    if @index != 1
      result = Game.images[@name+@index]
    else
      result = Game.images[@name]

    if not result
      console.log "#{name} not found."
      result = Game.images['PlaceHolder']
    return result
