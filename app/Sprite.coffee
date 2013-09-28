class Sprite

  constructor: (url,onload) ->
    image = new Image
    image.src = url
    image.onload = => @loaded(onload)
    @image = image

  loaded:(onload) ->
    @h = @image.height
    @w = @image.width
    onload()

