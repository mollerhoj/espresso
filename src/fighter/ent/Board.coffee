class Board extends Entity

  grid= [['Hero','Skull'],['Hero','Skull'],['Skull','Skull']]
  cell_width = 32
  cell_height = 32
  
  create: ->
    for subgrid,x in grid
      for element,y in subgrid
        World.spawn(element,x*cell_width,y*cell_height)

  step: ->
    if Keyboard.press('SPACE')
      @create()

  draw: ->
    super
    Art.fill_color 'Black'
    x = 0
    for subgrid,x in grid
      for element,y in subgrid
        Art.text(element,x*70,y*10)

