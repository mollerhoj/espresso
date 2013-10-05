class AppData
  @game_name = "snake"
  @width = 320
  @height = 240
  @scale = 2
  @grid_on = false
  @entities:
   'Apple': Apple
   'GameController': GameController
   'Snake': Snake
   'SnakeBody': SnakeBody
   'SnakeBodyShadow': SnakeBodyShadow
  @sprites:
   'PlaceHolder': 'PlaceHolder.png'
   'Snake': 'Snake.png'
   'SnakeBody': 'SnakeBody.png'
   'SnakeBodyShadow': 'SnakeBodyShadow.png'
  @levels:
   'Level': Level

