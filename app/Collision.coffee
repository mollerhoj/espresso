class Collision extends Entity
  
    # Check for collision between two objects
    @check: (type1,type2,x,y) ->

      objects1 = []
      objects2 = []

      if typeof type1 == 'object'
        objects1.push type1
      if typeof type2 == 'object'
        objects2.push type2
      
      for e in World.all_entities()
        if e.name == type1 or e.types.indexOf(type1) != -1
          objects1.push e
        if e.name == type2 or e.types.indexOf(type2) != -1
          objects2.push e

      # check for collision (between two squares)
      for o1 in objects1
        for o2 in objects2
          if ((o1.x+x <= o2.x and o1.x+x + o1.w > o2.x) or
             (o1.x+x >= o2.x and o1.x+x < o2.x + o2.w)) and
             ((o1.y+y <= o2.y and o1.y+y + o1.h > o2.y) or
             (o1.y+y >= o2.y and o1.y+y < o2.y + o2.h))
              return [o1,o2]
      return false
