class Toolbox
  @tools_menu: []
  @tools_editor: []
  @tools_always: []
  @levelEditor: null
  @grid: null
  @cameraMan: null
  @_active: false
  @_menu: false

  @init: ->
    Toolbox.add_tools()
    Toolbox.deactivate()

  @add_tools: ->
    grid = new Grid
    Toolbox.tools_always.push(grid)
    Toolbox.tools_always.push(new CameraMan)
    entityMenu = new EntityMenu
    Toolbox.tools_menu.push(entityMenu)
    leveleditor = new LevelEditor(entityMenu)
    leveleditor.grid = grid
    Toolbox.tools_editor.push(leveleditor)

  @deactivate: ->
    Toolbox._active = false
    for tool in Toolbox.tools_always
      tool.active = false
    for tool in Toolbox.tools_editor
      tool.active = false
    Toolbox.menuOff()
    World.frozen = false

  @activate: ->
    Toolbox._active = true
    for tool in Toolbox.tools_always
      tool.active = true
    Toolbox.menuOn()
    World.frozen = true
    World.reset()

  @menuOn: ->
    Toolbox._menu = true
    for tool in Toolbox.tools_menu
      tool.active = true
    for tool in Toolbox.tools_editor
      tool.active = false

  @menuOff: ->
    Toolbox._menu = false
    for tool in Toolbox.tools_menu
      tool.active = false
    for tool in Toolbox.tools_editor
      tool.active = true

  @step: ->
    if Keyboard.press('L') then Toolbox._active = toggle(Toolbox._active,Toolbox.activate,Toolbox.deactivate)

    if Toolbox._active == false then return

    if Keyboard.press('SPACE') then Toolbox._menu = toggle(Toolbox._menu,Toolbox.menuOn,Toolbox.menuOff)

    for tool in Toolbox.tools_always
      tool.step()
    for tool in Toolbox.tools_menu
      tool.step()
    for tool in Toolbox.tools_editor
      tool.step()

  @draw: ->
    if Toolbox._active == false then return
    
    for tool in Toolbox.tools_always
      tool.draw()
    for tool in Toolbox.tools_menu
      tool.draw()
    for tool in Toolbox.tools_editor
      tool.draw()



