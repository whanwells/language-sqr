describe 'SQR grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-sqr')
    runs ->
      grammar = atom.grammars.grammarForScopeName('source.sqr')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.sqr'

  it 'tokenizes comments', ->
    {tokens} = grammar.tokenizeLine '! foo'
    expect(tokens[0]).toEqual value: '!', scopes: ['source.sqr', 'comment.line.bang.sqr', 'punctuation.definition.comment.sqr']
    expect(tokens[1]).toEqual value: ' foo', scopes: ['source.sqr', 'comment.line.bang.sqr']

  it 'tokenizes variables', ->
    glyphs = ['#', '$', '&', '%', '@']

    for glyph in glyphs
      {tokens} = grammar.tokenizeLine "#{glyph}foo"
      expect(tokens[0]).toEqual value: glyph, scopes: ['source.sqr', 'variable.other.sqr', 'punctuation.definition.variable.sqr']
      expect(tokens[1]).toEqual value: 'foo', scopes: ['source.sqr', 'variable.other.sqr']

  it 'tokenizes constants', ->
    {tokens} = grammar.tokenizeLine '{foo}'
    expect(tokens[0]).toEqual value: '{', scopes: ['source.sqr', 'constant.other.sqr', 'punctuation.definition.constant.begin.sqr']
    expect(tokens[1]).toEqual value: 'foo', scopes: ['source.sqr', 'constant.other.sqr']
    expect(tokens[2]).toEqual value: '}', scopes: ['source.sqr', 'constant.other.sqr', 'punctuation.definition.constant.end.sqr']

  it 'tokenizes control keywords', ->
    keywords = [
      'if'
      'else'
      'end-if'

      'evaluate'
      'when'
      'when-other'
      'break'
      'end-evaluate'

      'while'
      'end-while'

      '#if'
      '#ifdef'
      '#ifndef'
      '#else'
      '#endif'
      '#end-if'

      'begin-heading'
      'end-heading'
      'begin-program'
      'end-program'
      'begin-procedure'
      'end-procedure'
      'begin-select'
      'end-select'
      'begin-sql'
      'end-sql'

      'do'
      'call'
      'goto'
      'let'
      'stop'
      'stop-quiet'
      'print'
      'using'
    ]

    for keyword in keywords
      {tokens} = grammar.tokenizeLine keyword
      expect(tokens[0]).toEqual value: keyword, scopes: ['source.sqr', 'keyword.control.sqr']

  it 'tokenizes deprecated keywords', ->
    keywords = [
      'begin-report'
      'end-report'
    ]

    for keyword in keywords
      {tokens} = grammar.tokenizeLine keyword
      expect(tokens[0]).toEqual value: keyword, scopes: ['source.sqr', 'invalid.deprecated.sqr']

  it 'tokenizes \\#include', ->
    {tokens} = grammar.tokenizeLine '#include'
    expect(tokens[0]).toEqual value: '#include', scopes: ['source.sqr', 'meta.preprocessor.sqr.include']

  it 'tokenizes strings', ->
    {tokens} = grammar.tokenizeLine "'foo''bar'"
    expect(tokens[0]).toEqual value: "'", scopes: ['source.sqr', 'string.quoted.single.sqr', 'punctuation.definition.string.begin.sqr']
    expect(tokens[1]).toEqual value: 'foo', scopes: ['source.sqr', 'string.quoted.single.sqr']
    expect(tokens[2]).toEqual value: "''", scopes: ['source.sqr', 'string.quoted.single.sqr', 'constant.character.escape.sqr']
    expect(tokens[3]).toEqual value: 'bar', scopes: ['source.sqr', 'string.quoted.single.sqr']
    expect(tokens[4]).toEqual value: "'", scopes: ['source.sqr', 'string.quoted.single.sqr', 'punctuation.definition.string.end.sqr']

  it 'tokenizes numbers', ->
    numbers = [
      '12',
      '.12'
      '12.'
      '12.3'
      '+12'
      '-12'
      '12e34'
      '12e+34'
      '12e-34'
    ]

    for number in numbers
      {tokens} = grammar.tokenizeLine number
      expect(tokens[0]).toEqual value: number, scopes: ['source.sqr', 'constant.numeric.sqr']
