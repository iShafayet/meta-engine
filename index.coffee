
class MetaEngine

  optionMap: null

  constuctor: (optionMap)->

    @optionMap = @__processOptionMap optionMap

  __processOptionMap: (optionMap)->

    if not optionMap or not (typeof optionMap is 'object')
      optionMap = {}

    if not ('encoding' of optionMap) or not (typeof optionMap.encoding is 'string')
      optionMap.encoding = 'utf8'

    return optionMap


@MetaEngine = MetaEngine

  
