#Most of this class was copied from the Coffeescript Cakefile:
#https://github.com/jashkenas/coffee-script/blob/master/Cakefile

#Terminal colors.
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

# Log a message with a color.
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

#Test of test framework
startTime   = Date.now()
currentFile = null
passedTests = 0
failures    = []

global[name] = func for name, func of require 'assert'

# Our test helper function for delimiting different test cases.
global.test = (description, fn) ->
  try
    fn.test = {description, currentFile}
    fn.call(fn)
    ++passedTests
  catch e
    failures.push
      filename: currentFile
      error: e
      description: description if description?
      source: fn.toString() if fn.toString?

# See http://wiki.ecmascript.org/doku.php?id=harmony:egal
egal = (a, b) ->
  if a is b
    a isnt 0 or 1/a is 1/b
  else
    a isnt a and b isnt b

# A recursive functional equivalence helper; uses egal for testing equivalence.
arrayEgal = (a, b) ->
  if egal a, b then yes
  else if a instanceof Array and b instanceof Array
    return no unless a.length is b.length
    return no for el, idx in a when not arrayEgal el, b[idx]
    yes

#Public methods to use by tests
global.eq      = (a, b, msg) -> ok egal(a, b), msg ? "Expected #{a} to equal #{b}"
global.arrayEq = (a, b, msg) -> ok arrayEgal(a,b), msg ? "Expected #{a} to deep equal #{b}"

# When all the tests have run, collect and print errors.
# If a stacktrace is available, output the compiled function source.
test_message = ->
  time = ((Date.now() - startTime) / 1000).toFixed(2)
  message = "passed #{passedTests} tests in #{time} seconds#{reset}"
  return log(message, green) unless failures.length
  n = 1
  for fail in failures
    {error, filename, description, source}  = fail
    log "#{n} \"#{description}\" failed.", red if description
    log "  #{error.stack}", bold 
    #console.log "  #{source}" if source
    n+=1
