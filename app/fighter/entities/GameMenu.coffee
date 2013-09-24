class GameMenu extends Menu

  main_menu:
    title: 'MAIN MENU'
    buttons:
      play:
        title: 'PLAY'
        buttons:
          back:
            title: '<BACK'
            action: (x) -> x.load(x.main_menu)
          level1:
            title: 'LEVEL 1'
            action: (x) -> x.start_game(1)
          level2:
            title: 'LEVEL 2'
            action: (x) -> x.start_game(2)
          level3:
            title: 'LEVEL 3'
            action: (x) -> x.start_game(3)
      options:
        title: 'OPTIONS'
        buttons:
          back:
            title: '<BACK'
            action: (x) -> x.load(x.main_menu)
          sound:
            title: 'SOUND'
            data: (y) ->
                          Audio.muted = tgl(Audio.muted)
                          console.log Audio.muted
                          y.text = 'SOUND OFF'
          music:
            title: 'MUSIC'
            actoin: (x) -> this

  current: null
  font: 'Dosis'
  
  constructor:->
    super
    space_between_buttons = 2 #TODO overwrite variables?
    @load(@main_menu)

  load: (tree) ->
    @clear_buttons()
    @current = tree
    for key, value of @current.buttons
      b = new Button
      b.text = value.title
      #if value.hasOwnProperty('data')
      #  b.text += ' ON'
      b.font = @font
      @add_button(b)

  button_release: (button_clicked) ->
    for key, value of @current.buttons
      if value.title == button_clicked.text
        if value.hasOwnProperty('buttons')
          @load(value)
        else
          if value.hasOwnProperty('action')
            value.action(this)
          else
            value.data(button_clicked)

  start_game: (level) ->
    console.log 'starting ' + level
