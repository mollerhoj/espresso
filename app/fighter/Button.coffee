# Button
class Button extends Entity
  text: ""
  font_size: 20
  font: null
  font_style: ""
  _listeners: []
  _selected: false
  _char_width: 0
  _char_height: 0
  x: -100 # fixes weird blinking, might need a check
  y: -100

  constructor: ->
    @_listeners = [] #TODO: Dont understand why I need to do this?
    @_set_font_style()
    @_cal_width()

  _cal_width: ->
    @_char_width = Art.text_width 'M'
    @_char_height = Art.text_height 'M'
    @w = @_char_width + Art.text_width @text
    @h = @_char_height/2 + @_char_height

  add_listener: (listener) ->
    @_listeners.push(listener)

  # Setting the font style for button. Must be done before drawing and calculating width 
  _set_font_style: ->
    Art.font_size @font_size / Art.get_scale()
    if @font
      Art.font @font
    Art.font_style @font_style

  step: ->
    @x = -Art.offset_x + @sx
    @y = -Art.offset_y + @sy

    if @mouse_hits() == true and @visible == true
      if Keyboard.press('MOUSE_LEFT')
        @button_pressed()
      if Keyboard.release('MOUSE_LEFT')
        @button_released()

  button_pressed: ->
    @_selected = true
    for listener in @_listeners
      listener.button_press(this)

  button_released: ->
    for listener in @_listeners
      listener.button_release(this)

  deselect: ->
    @_selected = false

  draw: ->
    if @_selected
      Art.fill_color 'DarkGray'
    else
      Art.fill_color 'LightGray'

    @_set_font_style()
    @_cal_width()
    Art.rectangle @x,@y,@w,@h,true
    Art.fill_color 'Black'
    Art.text(@text,@x+@_char_width/2,@y+@_char_height/4)
