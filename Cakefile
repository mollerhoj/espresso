{spawn, exec} = require 'child_process'

fs     = require 'fs'
{exec} = require 'child_process'
path = require 'path'

before_files  = [
  'Utils'
	'Entity'
  'Art'
  'Collision'
	'Game'
	'Keyboard'
	'World'
]

after_files = [
  'AppData'
	'SpriteImage'
  'start'
]

development_files = [
  'Grid'
  'ParentEntityMenu'
  'EntityMenu'
  'Toolbox'
  'LevelEditor'
  'EntityButton'
  'LevelPrinter'
  'EntityMenu'
  'CameraMan'
]

development_sprites = [
  'gfx/icon_hide.svg'
  'gfx/icon_show.svg'
]

game_name = ->
  x = fs.readFileSync '.name','utf8', (err) ->
    throw err if err
  x = x.replace /(\r\n|\n|\r)/, ""
  return x

newline = "\n"

# EXTENDING JAVASCRIPT ARRAYS WITH A REMOVE METHOD
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
# Remove all regexp matches from array
remove_from_array = (arr,reg) ->
  temp_arr = arr.slice(0)
  for i in temp_arr
    if reg.test i
      arr.remove i
  return arr

# Return a list of all images 
images =  ->
  dir = fs.readdirSync("./app/" + game_name() + "/gfx/")

  dir = remove_from_array(dir,/^\..*/)

  #return
  return dir

# Return a list of all entities in the game
entities = (workmode) ->
  dir = fs.readdirSync("./app/" + game_name() + "/ent/")

  dir = remove_from_array(dir,/^\..*/)

  dir = (f.replace(/.coffee/,'') for f in dir) # remove .coffee ending

  return dir

# Generate the AppData class
generate_AppData = ->
  output = "./app/AppData.coffee"

  # clear file? (trying to remove random bug)
  fs.writeFileSync output, '','utf8', (err) -> throw err if err

  # add class name 
  list = entities()

  fs.appendFileSync output, 'class AppData' + newline,'utf8', (err) ->
    throw err if err
 
  # add game name
  fs.appendFileSync output, '  @game_name = "' + game_name() + '"' + newline,'utf8', (err) ->
    throw err if err

  # add entities
  fs.appendFileSync output, '  @entities:'+ newline,'utf8', (err) ->
    throw err if err

  for f in list
    f = "   '" + f + "': " + f + newline
    fs.appendFileSync output,f,'utf8',(err) ->
      throw err if err
  
  # add sprites
  list = images()

  fs.appendFileSync output,'  @sprites:' + newline,'utf8',(err) ->
    throw err if err
    
  for f in list
    f = "   '" + f.replace(/(.png|.svg|.bmp|.gif|.jpg)/,'') + "': '" + f + "'" + newline
    fs.appendFileSync output,f,'utf8',(err) ->
      throw err if err

# Returns the list of classes in the right order
classlist = (workmode) ->
  dir = entities(workmode)                   # get all entities
  dir = ((f=game_name()+"/ent/"+f) for f in dir)  # unshift ent

  files = before_files.concat()       # files = beforefiles
  files.push game_name() + "/Menu"    # + menu
  files.push game_name() + "/Button"  # + button

  files = files.concat(dir)   # + ent

  if workmode == 'Development'
    dir = ((f="/dev/"+f) for f in development_files)  # unshift dev 
    files = files.concat(dir)
  files = files.concat(after_files)  # insert after files
  files.push game_name() + "/Settings" # should this be before the previous line for some reason? I have moved it down. If there are no problems, I can Set Setting, LevelData and EditorData by themselves somewhere.
  files.push game_name() + "/LevelData"
  files.push game_name() + "/EditorData"
  return files

# BUILD
task 'build', 'Build single application file from source files', ->
  exec 'cp -r app/'+game_name()+'/fonts public' # copy fonts
  exec 'cp -r app/'+game_name()+'/sfx public' # copy sounds/music
  generate_AppData()
  files = classlist('Development')
  appContents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile "app/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'public/game.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile public/game.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'public/game.coffee', (err) ->
          throw err if err
          console.log 'Done.'

option '-n','--game_name [GAME_NAME]', 'set the name of the game', ->
  console.log 'test'

task 'switch', 'Switch to work on the game specified in by -n', (options) ->
  gm = options.game_name or 'none'
  fs.writeFileSync '.name', gm,'utf8', (err) -> throw err if err
  console.log 'now working on ' + gm

task 'new', 'Make a new game folder to start the game', (options) ->
  gm = options.game_name
  fs.writeFileSync '.name', gm,'utf8', (err) -> throw err if err
  fs.mkdirSync 'app/' + gm
  fs.mkdirSync 'app/' + gm + "/ent"
  fs.mkdirSync 'app/' + gm + "/sfx"
  fs.mkdirSync 'app/' + gm + "/gfx"

  settings_text =
    "class Settings" + newline +
     "  # In development mode we have a level editor." + newline +
     "  @mode: 'Development'" + newline +
     "  # The size of the canvas" + newline +
     "  @width: 640" + newline +
     "  @height: 480" + newline +
     "  # The global zoom level" + newline +
     "  @scale: 1" + newline +
     "  # The default background image" + newline +
     "  @background: 'Background'" + newline +
     "  # The grid for the level editor. TODO: This should be moved to EditorData" + newline +
     "  @grid:" + newline +
     "    offset_x: 0" + newline +
     "    offset_y: 0" + newline +
     "    cell_width: 32" + newline +
     "    cell_height: 32"

  levelData_text =
    "# LevelData" + newline +
    "# Store levels here. 'level' will be loaded as default" + newline +
    "class LevelData" + newline +
    "  @level:"

  button_text =
    "# Button" + newline +
    "# A default UI button to be used in game menus" + newline +
    "class Button"

  menu_text =
    "# Button" + newline +
    "# A default UI menu to be used as the game menu" + newline +
    "class Menu"
  
  fs.writeFileSync 'app/' + gm + '/Settings.coffee',settings_text,'utf8', (err) ->
    throw err if err

  fs.writeFileSync 'app/' + gm + '/LevelData.coffee',levelData_text,'utf8', (err) ->
    throw err if err

  fs.writeFileSync 'app/' + gm + '/Button.coffee',button_text,'utf8', (err) ->
    throw err if err

  fs.writeFileSync 'app/' + gm + '/Menu.coffee',menu_text,'utf8', (err) ->
    throw err if err

