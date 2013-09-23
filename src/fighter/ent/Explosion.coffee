class Explosion extends Entity

  time: 0

  step: ->
    @time +=1
    @index = 1 + @time
    
    if @time > 3
      @destroy()
