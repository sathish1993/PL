package edu.binghamton.cs571;

public class UglyRegexpParser {

  Token _lookahead;
  Scanner _scanner;

  UglyRegexpParser(Scanner scanner) {
    _scanner = scanner;
    _lookahead = _scanner.nextToken();
  }


  /** parse a sequence of lines containing ugly-regexp's; for each
   *  ugly regexp print out the corresponding standard regexp.
   *  If there is an error, print diagnostic and continue with
   *  next line.
   */
  public void parse() {
    while (_lookahead.kind != Token.Kind.EOF) {
      try {
        String out = uglyRegexp();
        if (check(Token.Kind.NL)) System.out.println(out);
        match(Token.Kind.NL);
      }
      catch (ParseException e) {
        System.err.println(e.getMessage());
        while (_lookahead.kind != Token.Kind.NL) {
          _lookahead = _scanner.nextToken();
        }
        _lookahead = _scanner.nextToken();
      }
    }
  }

  /** Return standard syntax regexp corresponding to ugly-regexp
   *  read from _scanner.
   */
  private String uglyRegexp() {
    String t = term();
    return regexpRest(t);
  }

  private String regexpRest(String t) {
    if (check(Token.Kind.CHAR, ".")) {
      match(Token.Kind.CHAR, ".");
      String t1 = term();
      return regexpRest("(" + t + t1 + ")");
    }
    else {
      return t;
    }
  }

  private String term() {
    String f = factor();
    return termRest(f);
  }

  private String termRest(String f) {
    if (check(Token.Kind.CHAR, "+")) {
      match(Token.Kind.CHAR, "+");
      String f1 = factor();
      return termRest("(" + f + "|" + f1 + ")");
    }
    else {
      return f;
    }
  }

  private String factor() {
    if (check(Token.Kind.CHAR, "(")) {
      match(Token.Kind.CHAR, "(");
      String e = uglyRegexp();
      match(Token.Kind.CHAR, ")");
      return "(" + e + ")";
    }
    else if (check(Token.Kind.CHAR, "*")) {
      match(Token.Kind.CHAR, "*");
      String f = factor();
      return f + "*";
    }
    else {
      match(Token.Kind.CHARS);
      match(Token.Kind.CHAR, "(");
      String s = _lookahead.lexeme;
      match(Token.Kind.CHAR);
      String chars = chars(quote(s));
      match(Token.Kind.CHAR, ")");
      return "[" + chars + "]";
    }
  }

  private String chars(String s) {
    if (check(Token.Kind.CHAR, ",")) {
      match(Token.Kind.CHAR, ",");
      String s1 = _lookahead.lexeme;
      match(Token.Kind.CHAR);
      return chars(s + quote(s1));
    }
    else {
      return s;
    }
  }

  /** Return s with first char escaped using a '\' if it is
   * non-alphanumeric.
   */
  private String quote(String s) {
    return (Character.isLetterOrDigit(s.charAt(0))) ? s : "\\" + s;
  }

  /** Return true iff _lookahead.kind is equal to kind. */
  private boolean check(Token.Kind kind) {
    return check(kind, null);
  }

  /** Return true iff lookahead kind and lexeme are equal to
   *  corresponding args.  Note that if lexeme is null, then it is not
   *  used in the match.
   */
  private boolean check(Token.Kind kind, String lexeme) {
    return (_lookahead.kind == kind &&
            (lexeme == null || _lookahead.lexeme.equals(lexeme)));
  }

  /** If lookahead kind is equal to kind, then set lookahead to next
   *  token; else throw a ParseException.
   */
  private void match(Token.Kind kind) {
    match(kind, null);
  }

  /** If lookahead kind and lexeme are not equal to corresponding
   *  args, then set lookahead to next token; else throw a
   *  ParseException.  Note that if lexeme is null, then it is
   *  not used in the match.
   */
  private void match(Token.Kind kind, String lexeme) {
    if (check(kind, lexeme)) {
      _lookahead = _scanner.nextToken();
    }
    else {
      String expected = (lexeme == null) ? kind.toString() : lexeme;
      String message = String.format("%s: syntax error at '%s', expecting '%s'",
                                     _lookahead.coords, _lookahead.lexeme,
                                     expected);
      throw new ParseException(message);
    }
  }

  private static class ParseException extends RuntimeException {
    ParseException(String message) {
      super(message);
    }
  }



  public static void main(String[] args) {
    if (args.length != 1) {
      System.err.format("usage: java %s FILENAME\n",
                        UglyRegexpParser.class.getName());
      System.exit(1);
    }
    Scanner scanner =
      ("-".equals(args[0])) ? new Scanner() : new Scanner(args[0]);
    (new UglyRegexpParser(scanner)).parse();
  }


}
