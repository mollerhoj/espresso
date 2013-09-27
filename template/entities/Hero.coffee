class Hero extends Entity
  direction: 0
  move: 'WALKING' #STANDING JUMPING ETC
  animation: 0

  step: ->
    face_x = 0
    face_y = 0
    if Keyboard.hold('RIGHT')
      face_x +=1
    if Keyboard.hold('LEFT')
      face_x -=1
    if Keyboard.hold('UP')
      face_y -=1
    if Keyboard.hold('DOWN')
      face_y +=1

    @move = 'WALKING'

    if face_x == -1
      if face_y == -1
        @direction = 90+45
      if face_y == 0
        @direction = 180
      if face_y == 1
        @direction = 180+45
    
    if face_x == 0
      if face_y == -1
        @direction = 90
      if face_y == 0
        @move = 'STANDING'
      if face_y == 1
        @direction = 270

    if face_x == 1
      if face_y == -1
        @direction = 45
      if face_y == 0
        @direction = 0
      if face_y == 1
        @direction = 270+45

    @scale_x = 1

    if @direction == 0
      @index = 5

    if @direction == 45
      @index = 7

    if @direction == 90
      @index = 9

    if @direction == 90+45
      @index = 7
      @scale_x = -1

    if @direction == 180
      @index = 5
      @scale_x = -1

    if @direction == 180+45
      @index = 3
      @scale_x = -1

    if @direction == 270
      @index = 1

    if @direction == 270+45
      @index = 3

    if @animation > 20
      @animation = 0

    if @animation > 10
      @index +=1

    if @move == 'WALKING'
      @animation += 1
      @x += Math.cos(@direction/180*Math.PI)
      @y -= Math.sin(@direction/180*Math.PI)

  draw: ->
    super
    Art.font('Gochi Hand')
    Art.text('123',0,0)
    Art.font('Dosis')
    Art.text('Espresso running..',0,100)
    Art.font('Londrina Outline')
    Art.text('Espresso running..',0,160)

