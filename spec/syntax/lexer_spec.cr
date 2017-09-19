require "../spec_helper"

private def assert_token_type(source, token_type)
  token = tokenize(source).first
  token.type.should eq(token_type)
end

# This spec only tests simple token types. Types whose value is not static
# (strings, identifiers, numerics, symbols, etc.) each have their own, more
# comprehensive specs.
describe "Lexer" do
  it "lexes all operators properly" do
    assert_token_type "+",  Token::Type::PLUS
    assert_token_type "-",  Token::Type::MINUS
    assert_token_type "*",  Token::Type::STAR
    assert_token_type "/",  Token::Type::SLASH
    assert_token_type "=",  Token::Type::EQUAL
    assert_token_type "!",  Token::Type::NOT
    assert_token_type "=:", Token::Type::MATCH
    assert_token_type "<",  Token::Type::LESS
    assert_token_type "<=", Token::Type::LESSEQUAL
    assert_token_type "==", Token::Type::EQUALEQUAL
    assert_token_type "!=", Token::Type::NOTEQUAL
    assert_token_type ">=", Token::Type::GREATEREQUAL
    assert_token_type ">",  Token::Type::GREATER
    assert_token_type "&&", Token::Type::ANDAND
    assert_token_type "||", Token::Type::OROR
  end

  it "lexes all opassign tokens properly" do
    assert_token_type "&&=", Token::Type::ANDOP
    assert_token_type "||=", Token::Type::OROP
    assert_token_type  "+=", Token::Type::PLUSOP
    assert_token_type  "-=", Token::Type::MINUSOP
    assert_token_type  "*=", Token::Type::STAROP
    assert_token_type  "/=", Token::Type::SLASHOP
    assert_token_type  "%=", Token::Type::MODOP
  end

  it "lexes all punctuation characters properly" do
    assert_token_type ",",  Token::Type::COMMA
    assert_token_type ".",  Token::Type::POINT
    assert_token_type ": ", Token::Type::COLON
    assert_token_type "; ", Token::Type::SEMI
    assert_token_type "&",  Token::Type::AMPERSAND
    assert_token_type "|",  Token::Type::PIPE
  end

  it "lexes all bracing characters properly" do
    assert_token_type "(",  Token::Type::LPAREN
    assert_token_type ")",  Token::Type::RPAREN
    assert_token_type "[",  Token::Type::LBRACE
    assert_token_type "]",  Token::Type::RBRACE
    assert_token_type "{",  Token::Type::LCURLY
    assert_token_type "}",  Token::Type::RCURLY
  end

  it "lexes comments properly" do
    assert_token_type "# some comment\n", Token::Type::COMMENT
  end

  it "lexes delimiters properly" do
    assert_token_type "\0", Token::Type::EOF
    assert_token_type "\n", Token::Type::NEWLINE
    assert_token_type " ",  Token::Type::WHITESPACE
    assert_token_type "\t", Token::Type::WHITESPACE
  end

  it "lexes multiple whitespace delimiters together" do
    tokens = tokenize(" \t\t ")
    tokens.size.should eq(2) # One whitespace token, followed by the EOF.
    tokens.first.type.should eq(Token::Type::WHITESPACE)
  end

  it "lexes newlines characters separately from whitespace" do
    tokens = tokenize(" \t\n ")
    tokens.size.should eq(4) # whitespace, newline, whitespace, EOF.
    tokens[0].type.should eq(Token::Type::WHITESPACE)
    tokens[1].type.should eq(Token::Type::NEWLINE)
    tokens[2].type.should eq(Token::Type::WHITESPACE)
  end

  it "stops lexing after reaching EOF" do
    tokens = tokenize("thing\0 more things")
    tokens.size.should eq(2)
    tokens.last.type.should eq(Token::Type::EOF)
  end
end
