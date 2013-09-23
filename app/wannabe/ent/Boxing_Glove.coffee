class Boxing_Glove extends Entity

  step: ->
    @destroy()
    i = World.spawn('Item',@x,@y)
    i.sprite = @name 

