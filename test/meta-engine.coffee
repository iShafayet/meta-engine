
merge = (obj1, obj2)->
  obj = {}
  obj[key] = value for own key, value of obj1
  obj[key] = value for own key, value of obj2
  return obj

expect = require('chai').expect

fs = require 'fs'

{ MetaEngine } = require './../index.coffee'

describe 'class MetaEngine', ->

  describe 'methods', ->

    metaEngine1 = new MetaEngine

    describe '#__processOptionMap()', ->

      fn = metaEngine1.__processOptionMap

      it 'existance', ->

        expect(metaEngine1).to.have.property('__processOptionMap').that.is.a('function')

      it 'input-output sets', ->

        defaultOutput = { 
          encoding: 'utf8', 
          prefix: '@', 
          postfix: '', 
          contentProvider:null, 
          indentCharacter: '  ', 
          linebreakCharacter: '\n' 
          commentPostfix: " -->"
          commentPrefix: "<!-- "
          insertComments: false

        }
        
        expect(fn()).to.deep.equal defaultOutput

        expect(fn(null)).to.deep.equal defaultOutput
        
        expect(fn({encoding:'utf8'})).to.deep.equal merge defaultOutput, { encoding: 'utf8' }

        expect(fn({encoding:'utf16'})).to.deep.equal merge defaultOutput, { encoding: 'utf16' }
      
        expect(fn({encoding:'unknown'})).to.deep.equal  merge defaultOutput, { encoding: 'unknown' }

        expect(fn({encoding:null})).to.deep.equal defaultOutput

        expect(fn({encoding:'unknown', somekey:'somevalue'})).to.deep.equal merge defaultOutput, { encoding: 'unknown', somekey:'somevalue' }


    describe '#__validateContentProvider()', ->

      fn = metaEngine1.__validateContentProvider

      it 'existance', ->

        expect(metaEngine1).to.have.property('__validateContentProvider').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }


    describe '#setContentProvider()', ->

      fn = metaEngine1.setContentProvider

      it 'existance', ->

        expect(metaEngine1).to.have.property('setContentProvider').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }




