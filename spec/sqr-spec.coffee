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
    expect(tokens[0]).toEqual value: '! foo', scopes: ['source.sqr', 'comment.line.double-slash.sqr']

  it 'tokenizes variables', ->
    glyphs = ['#', '$']

    for glyph in glyphs
      {tokens} = grammar.tokenizeLine "#{glyph}foo"
      expect(tokens[0]).toEqual value: "#{glyph}foo", scopes: ['source.sqr', 'variable.language.sqr']

  it 'tokenizes keywords', ->
    keywords = [
      'end-if'
      'let'
      'begin-procedure'
      'end-procedure'
      'do'
      'else'
      'call'
      'using'
      'print'
      'goto'
      'begin-report'
      'end-report'
      'begin-heading'
      'end-heading'
      'end-select'
      'end-sql'
      'begin-select'
      'begin-sql'
      '#ifdef'
      '#end-if'
      'if'
    ]

    for keyword in keywords
      {tokens} = grammar.tokenizeLine keyword
      expect(tokens[0]).toEqual value: keyword, scopes: ['source.sqr', 'keyword.control.sqr']

  it 'tokenizes \\#include', ->
    {tokens} = grammar.tokenizeLine '#include'
    expect(tokens[0]).toEqual value: '#include', scopes: ['source.sqr', 'meta.preprocessor.sqr.include']

  it 'tokenizes strings', ->
    {tokens} = grammar.tokenizeLine "'foo'"
    expect(tokens[0]).toEqual value: "'", scopes: ['source.sqr', 'string.quoted.single.sqr']
    expect(tokens[1]).toEqual value: 'foo', scopes: ['source.sqr', 'string.quoted.single.sqr']
    expect(tokens[2]).toEqual value: "'", scopes: ['source.sqr', 'string.quoted.single.sqr']
