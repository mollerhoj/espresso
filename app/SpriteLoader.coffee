class SpriteLoader
  sprites_loaded = 0
  sprites_n = 0
  onload = null
  @images = {}

  constructor: (onload) ->
    @onload = onload
    sprites_n = Object.keys(AppData.sprites).length

  load_sprites: ->
    for name,file of AppData.sprites
      sprite = @load_sprite("sprites/" + file,@sprite_loaded)
      SpriteLoader.images[name] = sprite 

  load_sprite: (url,onload) ->
    image = new Image
    image.src = url
    image.onload = => @sprite_loaded()
    onload()
    return image
    
  sprite_loaded: =>
    sprites_loaded +=1
    if sprites_loaded == sprites_n 
      @onload()


