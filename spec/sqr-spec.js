'use babel';

const {packages, grammars} = atom;

describe('SQR grammar', () => {
  let grammar;

  beforeEach(() => {
    waitsForPromise(() => packages.activatePackage('language-sqr'));

    runs(() => {
      grammar = grammars.grammarForScopeName('source.sqr');
    });
  });

  it('parses the grammar', () => {
    expect(grammar).toBeTruthy();
    expect(grammar.scopeName).toBe('source.sqr');
  });

  it('tokenizes comments', () => {
    const {tokens} = grammar.tokenizeLine('! foo');
    const scopes = ['source.sqr', 'comment.line.bang.sqr'];

    expect(tokens[0].value).toBe('!');
    expect(tokens[0].scopes).toEqual([...scopes, 'punctuation.definition.comment.sqr']);

    expect(tokens[1].value).toBe(' foo');
    expect(tokens[1].scopes).toEqual(scopes);
  });

  it('tokenizes variables', () => {
    const glyphs = ['#', '$', '&', '%', '@'];
    const scopes = ['source.sqr', 'variable.other.sqr'];

    glyphs.forEach(glyph => {
      const {tokens} = grammar.tokenizeLine(`${glyph}foo`);

      expect(tokens[0].value).toBe(glyph);
      expect(tokens[0].scopes).toEqual([...scopes, 'punctuation.definition.variable.sqr']);

      expect(tokens[1].value).toBe('foo');
      expect(tokens[1].scopes).toEqual(scopes);
    });
  });

  it('tokenizes constants', () => {
    const {tokens} = grammar.tokenizeLine('{foo}');
    const scopes = ['source.sqr', 'constant.other.sqr'];

    expect(tokens[0].value).toBe('{');
    expect(tokens[0].scopes).toEqual([...scopes, 'punctuation.definition.constant.begin.sqr']);

    expect(tokens[1].value).toBe('foo');
    expect(tokens[1].scopes).toEqual(scopes);

    expect(tokens[2].value).toBe('}');
    expect(tokens[2].scopes).toEqual([...scopes, 'punctuation.definition.constant.end.sqr']);
  });

  it('tokenizes control keywords', () => {
    const keywords = [
      'if',
      'else',
      'end-if',

      'evaluate',
      'when',
      'when-other',
      'break',
      'end-evaluate',

      'while',
      'end-while',

      '#if',
      '#ifdef',
      '#ifndef',
      '#else',
      '#endif',
      '#end-if',

      'begin-heading',
      'end-heading',
      'begin-procedure',
      'end-procedure',
      'begin-select',
      'end-select',
      'begin-sql',
      'end-sql',

      'do',
      'call',
      'goto',
      'let',
      'print',
      'using',
    ];

    const scopes = ['source.sqr', 'keyword.control.sqr'];

    keywords.forEach(keyword => {
      const {tokens} = grammar.tokenizeLine(keyword);
      expect(tokens[0].value).toBe(keyword);
      expect(tokens[0].scopes).toEqual(scopes);
    });
  });

  it('tokenizes deprecated keywords', () => {
    const keywords = [
      'begin-report',
      'end-report',
    ];

    const scopes = ['source.sqr', 'invalid.deprecated.sqr'];

    keywords.forEach(keyword => {
      const {tokens} = grammar.tokenizeLine(keyword);
      expect(tokens[0].value).toBe(keyword);
      expect(tokens[0].scopes).toEqual(scopes);
    });
  });

  it('tokenizes \\#include', () => {
    const {tokens} = grammar.tokenizeLine('#include');
    const scopes = ['source.sqr', 'meta.preprocessor.sqr.include'];
    expect(tokens[0].value).toBe('#include');
    expect(tokens[0].scopes).toEqual(scopes);
  });

  it('tokenizes strings', () => {
    const {tokens} = grammar.tokenizeLine('\'foo\'\'bar\'');
    const scopes = ['source.sqr', 'string.quoted.single.sqr'];

    expect(tokens[0].value).toBe('\'');
    expect(tokens[0].scopes).toEqual([...scopes, 'punctuation.definition.string.begin.sqr']);

    expect(tokens[1].value).toBe('foo');
    expect(tokens[1].scopes).toEqual(scopes);

    expect(tokens[2].value).toBe('\'\'');
    expect(tokens[2].scopes).toEqual([...scopes, 'constant.character.escape.sqr']);

    expect(tokens[3].value).toBe('bar');
    expect(tokens[3].scopes).toEqual(scopes);

    expect(tokens[4].value).toBe('\'');
    expect(tokens[4].scopes).toEqual([...scopes, 'punctuation.definition.string.end.sqr']);
  });

  it('tokenizes numbers', () => {
    const numbers = [
      '12',
      '.12',
      '12.',
      '12.3',
      '+12',
      '-12',
      '12e34',
      '12e+34',
      '12e-34',
    ];

    const scopes = ['source.sqr', 'constant.numeric.sqr'];

    numbers.forEach(number => {
      const {tokens} = grammar.tokenizeLine(number);
      expect(tokens[0].value).toBe(number);
      expect(tokens[0].scopes).toEqual(scopes);
    });
  });
});
