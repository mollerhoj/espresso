# A Utils file
# Below is baseclass extensions
# Might also have a class with helpful methods (sign?)
Array::remove = (e) ->
  @[t..t] = [] if (t = @indexOf(e)) > -1

Array::diff = (a) ->
  @filter (i) ->
    not (a.indexOf(i) > -1)

# Return a copy of the array
Array::copy = ->
  this.slice(0)

Math.sign = (n) ->
  return (if n > 0 then 1 else (if n < 0 then -1 else 0))

Array::unique = ->
  @sort().filter (v, i, o) ->
    (if i and v isnt o[i - 1] then v else 0)


Array::deepToString = ->
  result = "["
  for i in [0...this.length]
    if Object::toString.call(this[i]) is "[object Array]"
      result += this[i].deepToString()
    else if this[i]
      result += this[i]
    if i != this.length-1
      result += ","
  return result + "]"

# Audio.muted = false
# 
# Audio::go = () ->
#   if Audio.muted == false
#     this.play()
# 
# window.tgl = (p) ->
#   if p
#     return false
#   else
#     return true
# 
# window.toggle = (p,t,f) ->
#   if p
#     f()
#     return false
#   else
#     t()
#     return true
