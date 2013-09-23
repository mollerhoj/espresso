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
