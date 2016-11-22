package edu.binghamton.cs571;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/** Evaluates arithmetic expressions for following grammar:

  program
    :  EOF
    |  expr '\n' program
    ;
  expr
    :  expr '+' term
    |  expr '-' term
    |  term
    ;
  term
    :  term '*' factor
    |  term '/' factor
    |  factor
    ;
  factor
    :  simple '**' factor
    |  simple
    ;
  simple
    : '-' simple
    |  INTEGER
    |  '(' expr ')'
    ;

Specifically, allows typing in an expression on a single line; evaluates
expression and prints result if everything ok, else it prints a error message.
 */
/* Transform above grammar to make it suitable for recursive-descent parsing
  program
    :  EOF
    |  expr '\n' program
    ;
  expr
    :  term exprRest
    ;
  exprRest
    :  '+' term exprRest
    |  '-' term exprRest
    |  //EMPTY
    ;
  term
    :  factor termRest
    ;
  termRest
    :  '*' factor termRest
    |  '/' factor termRest
    |  //EMPTY
    ;
  factor
    :  simple '**' factor
    |  simple
    ;
  simple
    : '-' simple
    |  INTEGER
    |  '(' expr ')'
    ;
 */
public class ArithParser { //@arithParser@

  private Scanner _scanner;
  private Token _lookahead;

  ArithParser() {
    _scanner = new Scanner(PATTERNS_MAP);
    nextToken(); //prime lookahead
  }

  /** Parser for program: //@program@
   *  program
   *    :  EOF
   *    |  expr '\n' program
   *    ;
   */
  public void program() {
    if (_lookahead.kind == TokenKind.EOF) {
      match(TokenKind.EOF);
    }
    else {
      try {
        int value = expr();
        System.out.println(value);
        match(TokenKind.NL);
      } //@program1@
      catch (ArithParseException e) {
        System.err.println(e.getMessage());
        match(TokenKind.NL);
      }
      program();
    }
  }

  /** Parse expr: //@expr@
   *  expr
   *   :  term exprRest
   *   ;
   */
  private int expr() {
    int t = term();
    return exprRest(t);
  }

  /** Parse exprRest: //@exprRest@
   *  exprRest
   *   :  ADD_OP term exprRest
   *   |  SUB_OP term exprRest
   *   |  //EMPTY
   *   ;
   */
  private int exprRest(int valueSoFar) {
    if (_lookahead.kind == TokenKind.ADD_OP) {
      match(TokenKind.ADD_OP);
      int t = term();
      return exprRest(valueSoFar + t);
    }
    else if (_lookahead.kind == TokenKind.SUB_OP) { //@exprRest1@
      match(TokenKind.SUB_OP);
      int t = term();
      return exprRest(valueSoFar - t);
    }
    else { //EMPTY
      return valueSoFar;
    }
  }

  /** Parse term: //@term@
   *  term
   *   :  factor termRest
   *   ;
   */
  private int term() {
    int f = factor();
    return termRest(f);
  }

  /** Parse termRest: //@termRest@
   *  termRest
   *   :  MUL_OP factor termRest
   *   |  DIV_OP factor termRest
   *   |  EMPTY
   *   ;
   */
  private int termRest(int valueSoFar) {
    if (_lookahead.kind == TokenKind.MUL_OP) {
      match(TokenKind.MUL_OP);
      int f = factor();
      return termRest(valueSoFar * f);
    }
    else if (_lookahead.kind == TokenKind.DIV_OP) { //@termRest1@
      match(TokenKind.DIV_OP);
      int f = factor();
      return termRest(valueSoFar / f);
    }
    else { //EMPTY
      return valueSoFar;
    }
  }

  /** Parse factor: //@factor@
   *  factor
   *    :  simple '**' factor
   *    |  simple
   *    ;
   */
  private int factor() {
    int s = simple();
    if (_lookahead.kind == TokenKind.EXP_OP) {
      match(TokenKind.EXP_OP);
      s = (int)Math.pow(s, factor());
    } //@factor1@
    return s;
  }

  /** Parse simple: //@simple@
   *  simple
   *    |  SUB_OP simple
   *    |  INTEGER
   *    |  LPAREN expr RPAREN
   *    ;
   */
  private int simple() {
    int value = 0;
    if (_lookahead.kind == TokenKind.SUB_OP) {
      match(TokenKind.SUB_OP);
      value = - simple();
    }
    else if (_lookahead.kind == TokenKind.INTEGER) { //@simple1@
      value = Integer.parseInt(_lookahead.lexeme);
      match(TokenKind.INTEGER);
    }
    else if (_lookahead.kind == TokenKind.LPAREN) {
      match(TokenKind.LPAREN);
      value = expr();
      match(TokenKind.RPAREN);
    }
    else {  //@simple2@
      syntaxError();
    }
    return value;
  }

  //We extend RuntimeException since Java's checked exceptions are //@exception@
  //very cumbersome
  static class ArithParseException extends RuntimeException {
    ArithParseException(String message) {
      super(message);
    }
  }

  private void match(TokenKind kind) { //@match@
    if (kind != _lookahead.kind) {
      syntaxError();
    }
    if (kind != TokenKind.EOF) {
      nextToken();
    }
  }

  /** Skip to end of current line and then throw exception */ //@syntaxError@
  private void syntaxError() {
    String message =
      String.format("%s: syntax error at '%s'",
                    _lookahead.coords,
                    _lookahead.lexeme);
    while (_lookahead.kind != TokenKind.NL &&
           _lookahead.kind != TokenKind.EOF) {
      nextToken();
    }
    throw new ArithParseException(message);
  }

  private static final boolean DO_TOKEN_TRACE = false; //@nextToken@

  private void nextToken() {
    _lookahead = _scanner.nextToken();
    if (DO_TOKEN_TRACE) System.err.println("token: " + _lookahead);
  }



  /** token kinds for arith tokens*/ //@tokenKind@
  private static enum TokenKind {
    EOF,
    NL,
    EXP_OP,
    ADD_OP,
    SUB_OP,
    MUL_OP,
    DIV_OP,
    INTEGER,  //@tokenKind1@
    LPAREN,
    RPAREN,
    ERROR,
  }

  /** Map from regex to token-kind */ //@tokenMap@
  private static final LinkedHashMap<String, Enum> PATTERNS_MAP =
    new LinkedHashMap<String, Enum>() {{
      put("", TokenKind.EOF);
      put("[ \\t]+", null);  //ignore linear whitespace.
      put("\n", TokenKind.NL);
      put("\\*\\*", TokenKind.EXP_OP);
      put("\\+", TokenKind.ADD_OP);
      put("\\-", TokenKind.SUB_OP);
      put("\\*", TokenKind.MUL_OP);
      put("\\/", TokenKind.DIV_OP);
      put("\\d+", TokenKind.INTEGER); //@tokenMap1@
      put("\\(", TokenKind.LPAREN);
      put("\\)", TokenKind.RPAREN);
      put(".", TokenKind.ERROR);  //catch lexical error in parser
    }};
  //@main@
  /** Main program for testing */
  public static void main(String[] args) {
    ArithParser arith = new ArithParser();
    arith.program();
  }

}
