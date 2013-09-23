# Menu
class Menu extends Entity
  
  active: true
  _buttons: []
  space_between_buttons: 2
  selected_button: null
  type: "radio" #radio, checkbox
  valign: 'up' #down

  constructor: ->
    @_buttons = []

  add_button: (button) ->
    button.add_listener(this)
    @_buttons.push(button)

    button.button_pressed()

  clear_buttons: ->
    @_buttons = []

  step: ->
    if not @active then return
    @h = 0
    for button in @_buttons
      button.sy = @y+@h
      h_jump = button.h+(@space_between_buttons / Art.get_scale())
      if @valign == 'up'
        button.sy-= @_buttons.length*h_jump
        button.sx = @x
      @h+=h_jump
      button.step()

  button_press: (button_clicked) ->
    @selected_button = button_clicked
    #deselect others if radiobuttons
    if @type == "radio"
      for button in @_buttons
        if button != button_clicked
          button.deselect()

  draw: ->
    if @active == false then return
    for button in @_buttons
      button.draw()

