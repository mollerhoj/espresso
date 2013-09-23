class Danger extends Entity

  step: ->
    @index = @index % 3 +1 
