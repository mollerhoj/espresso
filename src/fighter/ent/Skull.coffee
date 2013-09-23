class Skull extends Entity

  direction: 0

  speed: 2

  step: ->
      @x += Math.cos(@direction/180*Math.PI)*@speed
      @y -= Math.sin(@direction/180*Math.PI)*@speed

      if @x < 0
        @direction = 0

      if @y < 0
        @direction = 270

      if @x > 320
        @direction = 180

      if @y > 240
        @direction = 90

