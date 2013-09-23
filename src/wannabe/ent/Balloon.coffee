class Balloon extends Entity

  step: ->
    @destroy()
    i = World.spawn('Item',@x,@y)
    i.sprite = 'Balloon'

