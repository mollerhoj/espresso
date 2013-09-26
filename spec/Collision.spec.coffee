describe 'Collision', ->

    it 'can add two positive numbers', ->
      calc = require('../app/Collision').Collision
      c = new calc
      expect(c.add(2,2)).toEqual 3
