class CameraMan

    step: ->
      if Keyboard.hold('UP')
        Art.offset_y += 8
      if Keyboard.hold('DOWN')
        Art.offset_y -= 8
      if Keyboard.hold('LEFT')
        Art.offset_x += 8
      if Keyboard.hold('RIGHT')
        Art.offset_x -= 8
      
      if Keyboard.press('0')
        Art.offset_x = 0
        Art.offset_y = 0
        Art.scale Settings.scale 

      if Keyboard.hold('1')
        Art.scale (Math.min(10,Art.get_scale()+0.1))

      if Keyboard.hold('2')
        Art.scale (Math.max(0.01,Art.get_scale()-0.1))

    draw: -> #TODO perhaps make a tool class to extend from with a filler draw method.


