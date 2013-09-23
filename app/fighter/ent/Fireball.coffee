class Fireball extends Entity
  time: 0

  step: ->
      @time += 1
      @x += Math.cos(@direction/180*Math.PI)*5
      @y -= Math.sin(@direction/180*Math.PI)*5

      if @time > 15
        World.spawn('Explosion',@x,@y)
        @destroy()

  draw: ->
      @index = 1 + @direction/45
      super



