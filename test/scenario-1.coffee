
expect = require('chai').expect

fs = require 'fs'

{ MetaEngine, StockContentProvider } = require './../index.coffee'

describe 'Scenario 1', ->

  describe 'Test 1', ->

    it.only 'test', ->

      cp = new StockContentProvider './test/scenario-1', 'utf8'

      me = new MetaEngine { contentProvider: cp, encoding: 'utf8' }

      console.log '|'+(me.processSync 'index.html')+'|'





