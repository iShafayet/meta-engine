
expect = require('chai').expect

fs = require 'fs'

{ MetaEngine, StockContentProvider } = require './../index.coffee'

describe 'Scenarios', ->

  describe 'Scenario 1', ->

    it 'test', ->

      class TestContentProvider extends StockContentProvider

        getContentSync: (relativePath)->
          super ('/input/'+relativePath)

        setContentSync: (relativePath, content)->
          super ('/output/'+relativePath), content

      cp = new TestContentProvider './test/scenario-1', 'utf8'

      me = new MetaEngine { 
        contentProvider: cp, 
        encoding: 'utf8' 
      }

      me.processSync 'index.html'      

      output = fs.readFileSync './test/scenario-1/output/index.html', {encoding:'utf8'}

      expected = fs.readFileSync './test/scenario-1/expected-output/index.html', {encoding:'utf8'}

      expect(output).to.equal(expected)


  describe 'Scenario 2', ->

    it 'test', ->

      class TestContentProvider extends StockContentProvider

        getContentSync: (relativePath)->
          super ('/input/'+relativePath)

        setContentSync: (relativePath, content)->
          super ('/output/'+relativePath), content

      cp = new TestContentProvider './test/scenario-2', 'utf8'

      me = new MetaEngine { 
        contentProvider: cp, 
        encoding: 'utf8' 
      }

      me.processSync 'index.html'      

      output = fs.readFileSync './test/scenario-2/output/index.html', {encoding:'utf8'}

      expected = fs.readFileSync './test/scenario-2/expected-output/index.html', {encoding:'utf8'}

      expect(output).to.equal(expected)





