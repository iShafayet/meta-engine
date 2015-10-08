
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

      fn = ->
        me.processSync 'index.html'

      expect(fn).to.throw('Duplicate Region "common-footer" in "index.html"')



  describe 'Scenario 3', ->

    it 'test', ->

      class TestContentProvider extends StockContentProvider

        getContentSync: (relativePath)->
          super ('/input/'+relativePath)

        setContentSync: (relativePath, content)->
          super ('/output/'+relativePath), content

      cp = new TestContentProvider './test/scenario-3', 'utf8'

      me = new MetaEngine { 
        contentProvider: cp, 
        encoding: 'utf8' 
      }

      me.processSync 'index.html'      

      output = fs.readFileSync './test/scenario-3/output/index.html', {encoding:'utf8'}

      expected = fs.readFileSync './test/scenario-3/expected-output/index.html', {encoding:'utf8'}

      expect(output).to.equal(expected)



  describe 'scenario-4-comment-insertion', ->

    it 'test', ->

      class TestContentProvider extends StockContentProvider

        getContentSync: (relativePath)->
          super ('/input/'+relativePath)

        setContentSync: (relativePath, content)->
          super ('/output/'+relativePath), content

      cp = new TestContentProvider './test/scenario-4-comment-insertion', 'utf8'

      me = new MetaEngine { 
        contentProvider: cp, 
        encoding: 'utf8' 
        insertComments: true
      }

      me.processSync 'index.html'      

      output = fs.readFileSync './test/scenario-4-comment-insertion/output/index.html', {encoding:'utf8'}

      expected = fs.readFileSync './test/scenario-4-comment-insertion/expected-output/index.html', {encoding:'utf8'}

      expect(output).to.equal(expected)









