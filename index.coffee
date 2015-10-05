
class MetaEngine

  optionMap: null

  constuctor: (optionMap)->

    @optionMap = @__processOptionMap optionMap
  

  __processOptionMap: (optionMap)->

    if not optionMap or not (typeof optionMap is 'object')
      optionMap = {}

    if not ('encoding' of optionMap) or not (typeof optionMap.encoding is 'string')
      optionMap.encoding = 'utf8'

    if not ('prefix' of optionMap) or not (typeof optionMap.prefix is 'string')
      optionMap.prefix = '@'

    if not ('postfix' of optionMap) or not (typeof optionMap.postfix is 'string')
      optionMap.postfix = ''

    return optionMap


@MetaEngine = MetaEngine

  
