class ImageLoader
  images_loaded = 0
  images_n = 0
  onload = null

  constructor: ->
    images_n = Object.keys(AppData.sprites).length

  load_images: ->
    for name,file of AppData.sprites
      image = @load_image("sprites/" + file,@image_loaded)
      Game.images[name] = image 

  load_image: (url,onload) ->
    image = new Image
    image.src = url
    image.onload = => @image_loaded()
    onload()
    return image
    
  image_loaded: =>
    images_loaded +=1
    if images_loaded == images_n 
      @onload()


