
expect = require('chai').expect

fs = require 'fs'

{ StockContentProvider } = require './../index.coffee'

describe 'class StockContentProvider', ->

  describe 'methods', ->

    stockContentProvider1 = new StockContentProvider

    describe '#getContent()', ->

      fn = stockContentProvider1.getContent

      it 'existance', ->

        expect(stockContentProvider1).to.have.property('getContent').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }


    describe '#setContent()', ->

      fn = stockContentProvider1.setContent

      it 'existance', ->

        expect(stockContentProvider1).to.have.property('setContent').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }

    describe '#getContentSync()', ->

      fn = stockContentProvider1.getContentSync

      it 'existance', ->

        expect(stockContentProvider1).to.have.property('getContentSync').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }

    describe '#setContentSync()', ->

      fn = stockContentProvider1.setContentSync

      it 'existance', ->

        expect(stockContentProvider1).to.have.property('setContentSync').that.is.a('function')

      it.skip 'input-output sets', ->
        
        # expect(fn()).to.deep.equal { encoding: 'utf8', prefix: '@', postfix: '', contentProvider:null }
