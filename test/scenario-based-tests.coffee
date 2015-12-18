
expect = require('chai').expect

fs = require 'fs'

{ MetaEngine, StockContentProvider } = require './../index.coffee'

describe 'Scenarios', ->

  describe 'Scenario 1: @include, @region (indented), @use', ->

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


  describe 'Scenario 2: @include, @region (overriding another @region), @use (match-indent)', ->

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



  describe 'Scenario 3: @include, @region (without indented), @use (match-indent)', ->

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



  describe 'Scenario 4: Comment Insertion', ->

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






  describe 'Scenario 4a: Comment Insertion (Async)', ->

    it 'test', (done)->

      class TestContentProvider extends StockContentProvider

        getContentSync: (relativePath)->
          super ('/input/'+relativePath)

        setContentSync: (relativePath, content)->
          super ('/output/'+relativePath), content

        getContent: (relativePath, cbfn)->
          try 
            return cbfn null, @getContentSync relativePath 
          catch ex
            return cbfn ex

        setContent: (relativePath, content, cbfn)->
          try 
            return cbfn null, @setContentSync relativePath, content
          catch ex
            return cbfn ex

      cp = new TestContentProvider './test/scenario-4-comment-insertion', 'utf8'

      me = new MetaEngine { 
        contentProvider: cp, 
        encoding: 'utf8' 
        insertComments: true
      }

      me.process 'index.html', (output)=>

        output = fs.readFileSync './test/scenario-4-comment-insertion/output/index.html', {encoding:'utf8'}

        expected = fs.readFileSync './test/scenario-4-comment-insertion/expected-output/index.html', {encoding:'utf8'}

        expect(output).to.equal(expected)

        done()









