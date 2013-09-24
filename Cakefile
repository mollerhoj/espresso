#requirements
{spawn, exec} = require 'child_process'
fs     = require 'fs'

#Global vars
espresso_path = '/Users/mem/work/coffee/espresso'
newline = "\n"

#Global settings
#width,height,zoom

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

#Get name of the game
game_name = ->
  x = fs.readFileSync '.name','utf8', (err) ->
    throw err if err
  x = x.replace /(\r\n|\n|\r)/, ""
  return x

# EXTENDING JAVASCRIPT ARRAYS WITH A REMOVE METHOD
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
# Remove all regexp matches from array
remove_from_array = (arr,reg) ->
  temp_arr = arr.slice(0)
  for i in temp_arr
    if reg.test i
      arr.remove i
  return arr

#Get all sprites
sprites =  ->
  dir = fs.readdirSync("./app/" + game_name() + "/sprites/")
  dir = remove_from_array(dir,/^\..*/)
  return dir

#Get all entities
entities = ->
  dir = fs.readdirSync("./app/" + game_name() + "/entities/")
  dir = remove_from_array(dir,/^\..*/)
  dir = (f.replace(/.coffee/,'') for f in dir) # remove .coffee ending
  return dir

#Clear a file
clear_file = (file) ->
  fs.writeFileSync file, '','utf8', (err) -> throw err if err

#Put to a file
put_to_file = (file,put) ->
  fs.appendFileSync file, put + newline,'utf8', (err) ->
    throw err if err

# Generate the AppData class
generate_AppData = ->
  file = "./app/AppData.coffee"
  clear_file(file)
  put_to_file(file,'class AppData')
  put_to_file(file,'  @game_name = "' + game_name() + '"')
  put_to_file(file,'  @entities:')

  # add entities
  list = entities()
  for f in list
    f = "   '" + f + "': " + f + newline
    fs.appendFileSync file,f,'utf8',(err) ->
      throw err if err
  
  # add sprites
  list = sprites()

  put_to_file(file,'  @sprites:')
    
  for f in list
    f = "   '" + f.replace(/(.png|.svg|.bmp|.gif|.jpg)/,'') + "': '" + f + "'" + newline
    fs.appendFileSync file,f,'utf8',(err) ->
      throw err if err

# Returns the list of classes in the right order
classlist = ->
  dir = entities()                   # get all entities
  dir = ((f=game_name()+"/entities/"+f) for f in dir)  # unshift ent

  files = before_files.concat()       # files = beforefiles

  files = files.concat(dir)   # + ent

  files = files.concat(after_files)  # insert after files
  files.push game_name() + "/Settings" # should this be before the previous line for some reason? I have moved it down. If there are no problems, I can Set Setting, LevelData and EditorData by themselves somewhere.
  files.push game_name() + "/LevelData"
  files.push game_name() + "/EditorData"
  return files

task 'tmp', 'Temp', ->
  console.log espresso_path

# Copy resources
copy_resources = ->
  exec 'cp -r app/'+game_name()+'/fonts app/' + game_name() + '/output' # copy fonts
  exec 'cp -r app/'+game_name()+'/sounds app/' + game_name() + '/output' # copy sounds
  exec 'cp -r app/'+game_name()+'/sprites app/' + game_name() + '/output' # copy sprites

# Load Classes
load_classes = (files) ->
  appContents = new Array remaining = files.length
  for file, index in files then do (file, index) ->
    fs.readFile "app/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'app/'+game_name()+'/output/game.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile app/'+game_name()+'/output/game.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'app/'+game_name()+'/output/game.coffee', (err) ->
          throw err if err
          console.log 'Done.'

# BUILD TASK
task 'build', 'Build single application file from source files', ->
  copy_resources()
  generate_AppData()
  load_classes(classlist())
