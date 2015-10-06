
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
        
        expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }

        expect(fn(null)).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }
        
        expect(fn({encoding:'utf8'})).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }

        expect(fn({encoding:'utf16'})).to.deep.equal { encoding: 'utf16', prefix: '@', postfix: '', contentProvider:null }
      
        expect(fn({encoding:'unknown'})).to.deep.equal { encoding: 'unknown', prefix: '@', postfix: '', contentProvider:null }

        expect(fn({encoding:null})).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }

        expect(fn({encoding:'unknown', somekey:'somevalue'})).to.deep.equal { encoding: 'unknown' , somekey:'somevalue', prefix: '@', postfix: '', contentProvider:null }


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




