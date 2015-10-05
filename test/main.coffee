
expect = require('chai').expect

fs = require 'fs'

{ MetaEngine } = require './../index.coffee'

describe 'meta-engine', ->

  describe 'truth test', ->

    it 'true is true', ->

      expect(true).to.equal(true)

  describe 'methods', ->

    metaEngine1 = new MetaEngine

    describe '#__processOptionMap()', ->

      fn = metaEngine1.__processOptionMap

      it 'existance', ->

        expect(metaEngine1).to.have.property('__processOptionMap').that.is.a('function')

      it 'input-output sets', ->
        
        expect(fn()).to.deep.equal { encoding: 'utf8' }

        expect(fn(null)).to.deep.equal { encoding: 'utf8' }
        
        expect(fn({encoding:'utf8'})).to.deep.equal { encoding: 'utf8' }

        expect(fn({encoding:'utf16'})).to.deep.equal { encoding: 'utf16' }
      
        expect(fn({encoding:'unknown'})).to.deep.equal { encoding: 'unknown' }

        expect(fn({encoding:null})).to.deep.equal { encoding: 'utf8' }

        expect(fn({encoding:'unknown', somekey:'somevalue'})).to.deep.equal { encoding: 'unknown' , somekey:'somevalue'}


