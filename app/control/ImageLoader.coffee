class ImageLoader
  images_loaded = 0
  images_n = 0
  i = null

  constructor: ->
    images_n = Object.keys(AppData.sprites).length

  load_images: ->
    for name,file of AppData.sprites
      @load_image("sprites/" + file,name)

  load_image: (url,name,im) ->
    image = new Image
    image.src = url
    image.onload = => @image_loaded(name,image)
    return image
    
  image_loaded: (name,image) =>
    Game.images[name] = image 
    images_loaded +=1
    if images_loaded == images_n 
      @onload()


