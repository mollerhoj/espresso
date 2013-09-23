# Button
class Button extends Entity
  _text: ""
  font_size: 20
  font: "Times New Roman"
  font_style: ""
  fonc = null
  selected: false
  _char_width: 0
  _char_height: 0

  # A button is initaliced with the its text
  init: (string) ->
    @_text = string
    @_set_font_style()
    @_char_width = Art.text_width 'M'
    @_char_height = Art.text_height 'M'
    @w = @_char_width + Art.text_width string
    @h = @_char_height/2 + @_char_height

  # Maybe this should be part of initilasation?
  # The function to call when the button is clicked
  clicked_call: (func)->
    @func = func

  # Setting the font style for button. Must be done before drawing and calculating width 
  _set_font_style: ->
    Art.font_size @font_size / Settings.scale
    Art.font @font
    Art.font_style @font_style

  step: ->
    @x = -Art.offset_x + @sx
    @y = -Art.offset_y + @sy

    if @mouse_hits() == true
      if Keyboard.press('MOUSE_LEFT') and @visible == true
        @clicked()

  clicked: ->
    @func(this)

  draw: ->
    if @selected
      Art.fill_color 'DarkGray'
    else
      Art.fill_color 'LightGray'

    Art.rectangle @x,@y,@w,@h,true
    @_set_font_style()
    Art.fill_color 'Black'
    Art.text(@_text,@x+@_char_width/2,@y+@_char_height/4)

