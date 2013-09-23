# Keyboard
# Responsible for dealing with keyboard and mouse input
class Keyboard
  @_keyCodes:
    'BACKSPACE': 8
    'TAB': 9
    'ENTER': 13
    'SHIFT': 16
    'CTRL': 17
    'ALT': 18
    'CAPSLOCK': 20
    'ESCAPE': 27
    'SPACE' : 32
    'END': 35
    'HOME': 36
    'LEFT': 37
    'UP': 38
    'RIGHT': 39
    'DOWN':	40
    'INSERT': 45
    'DELETE': 46
    '0': 48
    '1': 49
    '2': 50
    '3': 51
    '4': 52
    '5': 53
    '6': 54
    '7': 55
    '8': 56
    '9': 57
    'A': 65
    'B': 66
    'C': 67
    'D': 68
    'E': 69
    'F': 70
    'G': 71
    'H': 72
    'I': 73
    'J': 74
    'K': 75
    'L': 76
    'M': 77
    'N': 78
    'O': 79
    'P': 80
    'Q': 81
    'R': 82
    'S': 83
    'T': 84
    'U': 85
    'V': 86
    'W': 87
    'X': 88
    'Y': 89
    'Z': 90
    'MULTIPLY': 106
    'ADD': 107
    'SUBTRACT': 109
    'MOUSE_LEFT': 'MOUSE_LEFT'
    'MOUSE_MIDDLE' : 'MOUSE_MIDDLE'
    'MOUSE_RIGHT' : 'MOUSE_RIGHT'
  
  @_pre_pressed: []
  @_pre_released: []
  @_pressed: []
  @_released: []
  @_hold: []

# Listen for keys being presses and being released. As this happens
  # add and remove them from the key store.
  @init: ->
    $("body").keydown (e) =>
      Keyboard.key_pressed(e.keyCode)
    $("body").keyup (e) =>
      Keyboard.key_released(e.keyCode)
    $("#game").mousemove(Keyboard.mouse_move)
    $("#game").mousedown(Keyboard.mouse_down)
    $("#game").mouseup(Keyboard.mouse_up)
    $("#game").bind "contextmenu", (e) -> return false # remove contextmenu

  @key_released: (c) ->
    Keyboard._pre_released.push c

  @key_pressed: (c) ->
    Keyboard._pre_pressed.push c

  @mouse_down: (e) ->
    switch e.button
      when 0 then Keyboard._pre_pressed.push 'MOUSE_LEFT'
      when 1 then Keyboard._pre_pressed.push 'MOUSE_MIDDLE'
      when 2 then Keyboard._pre_pressed.push 'MOUSE_RIGHT'
    return false #to disable default drag in canvas

  @mouse_up: (e) ->
    switch e.button
      when 0 then Keyboard._pre_released.push 'MOUSE_LEFT'
      when 1 then Keyboard._pre_released.push 'MOUSE_MIDDLE'
      when 2 then Keyboard._pre_released.push 'MOUSE_RIGHT'
    return false #to disable default drag in canvas

  @mouse_move: (e) ->
    Keyboard.MOUSE_XC = e.offsetX / Art.get_scale()
    Keyboard.MOUSE_YC = e.offsetY / Art.get_scale()
    Keyboard.MOUSE_X = (Keyboard.MOUSE_XC - Art.offset_x)
    Keyboard.MOUSE_Y = (Keyboard.MOUSE_YC - Art.offset_y)

  @hold: (keyName) ->
    return Keyboard._hold.indexOf(Keyboard._keyCodes[keyName]) != -1

  @press: (keyName) ->
    return Keyboard._pressed.indexOf(Keyboard._keyCodes[keyName]) != -1
    
  @release: (keyName) ->
    return Keyboard._released.indexOf(Keyboard._keyCodes[keyName]) != -1
    
  @step: ->
    Keyboard._pressed = Keyboard._pre_pressed.splice(0)
    Keyboard._released = Keyboard._pre_released.splice(0)
    Keyboard._hold = Keyboard._hold.concat(Keyboard._pressed)
    Keyboard._hold = Keyboard._hold.diff(Keyboard._released)
    Keyboard._pre_pressed = []
    Keyboard._pre_released = []

