# This should be replaced with DOM elements, and should therefore be obsolete.
class EntityButton extends Entity
  text: ""
  font_size: 20
  font: "Times New Roman"
  font_style: ""
  _listeners: []
  _selected: false
  _char_width: 0
  _char_height: 0

  # A button is initaliced with the its text
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
    Art.font @font
    Art.font_style @font_style

  step: ->
    @x = -Art.offset_x + @sx
    @y = -Art.offset_y + @sy

    if @mouse_hits() == true
      if Keyboard.press('MOUSE_LEFT') and @visible == true
        @select()

  select: ->
    @_selected = true
    for listener in @_listeners
      listener.button_press(this)

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
