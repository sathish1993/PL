#!/usr/bin/env ruby

class UglyRegexpParser
  def initialize(scanner)
    #@tokens is an instance variable which iterates over all tokens on
    #successive calls to next().  Terminates with a StopIteration exception.
    @tokens = scanner.each
    
    @lookahead = next_token
  end

  # parse a sequence of lines containing ugly-regexp's; for each
  #  ugly regexp print out the corresponding standard regexp.
  #  If there is an error, print diagnostic and continue with
  #  next line.
  def parse() 
    while (@lookahead.kind != :EOF) do
      begin
        out = uglyRegexp(0)[0]
        STDOUT.puts(out) if (check(:NL))
        match(:NL)
      rescue ParseException => msg
        STDERR.puts(msg)
        while (@lookahead.kind != :NL && @lookahead.kind != :EOF) do
          @lookahead = next_token
        end
        @lookahead = next_Token
      end
    end
  end

  private

  #Return standard syntax regexp corresponding to ugly-regexp
  #read from _scanner with minimal parenthesization.
  #Return value of all parsing functions is a 2-element list
  #containing the translated string and the level.
  def uglyRegexp(level) 
    term_ret = term(level)
    return regexpRest(*term_ret)
  end

  def regexpRest(t, level)
    if check(:CHAR, ".") 
      match(:CHAR, ".")
      t1 = term(1)
      return regexpRest("#{paren(2, t, level)}#{paren(1, *t1)}", 2)
    else 
      return [t, level]
     end
  end

  def term(level)
    f = factor(level)
    return termRest(*f)
  end

  def termRest(f, level) 
    if check(:CHAR, "+")
      match(:CHAR, "+")
      f1 = factor(2)
      return termRest("#{paren(3, f, level)}|#{paren(2, *f1)}", 3)
    else 
      return [f, level]
    end
  end

  def factor(level)
    if check(:CHAR, "(") 
      match(:CHAR, "(")
      e = uglyRegexp(level)
      match(:CHAR, ")")
      return e
    elsif check(:CHAR, "*")
      match(:CHAR, "*")
      f = factor(1)
      return [f[0], 1]
    else 
      match(:CHARS)
      match(:CHAR, "(")
      s = @lookahead.lexeme
      match(:CHAR)
      chars = chars(quote(s))
      match(:CHAR, ")")
      return [ "[#{chars}]", 0]
    end
  end

  def chars(s) 
    if check(:CHAR, ",")
      match(:CHAR, ",")
      s1 = @lookahead.lexeme
      match(:CHAR)
      return chars("#{s}#{quote(s1)}")
    else 
      return s
    end
  end

  #return parenthesized exp iff exp_level > level.
  def paren(level, exp, exp_level)
    (exp_level > level) ? "(#{exp})" : exp
  end

  #Return s with first char escaped using a '\' if it is non-alphanumeric.
  def quote(s) 
    (s !~ /^[0-9a-zA-Z]/) ? "\\#{s}" : s
  end


  def check(kind, lexeme=nil)
    @lookahead.kind == kind && (!lexeme || @lookahead.lexeme == lexeme)
  end

  def match(kind, lexeme=nil)
    if check(kind, lexeme)
      @lookahead = next_token
    else
      msg = "syntax error: expecting #{lexeme||kind} at '#{@lookahead.lexeme}'"
      raise ParseException.new(msg)
    end                             
  end

  #wrapper around @tokens.next, transforming StopIteration exception to :EOF.
  def next_token
    begin
      token = @tokens.next
    rescue StopIteration
      token = Scanner::Token.new(:EOF, "", @lookahead.coord)
    end
    return token
  end

  class ParseException < Exception
  end

end

class Scanner

  Coord = Struct.new(:filename, :line_num, :col_index)
  Token = Struct.new(:kind, :lexeme, :coord)

  def initialize(filename)
    #@in initialized to iterator over all lines in input
    @in = ((filename == '-') ? STDIN : File.new(filename)).each
    @line = nil
    @coord = Coord.new(filename, 0, 0)
  end

  def each
    return enum_for(:each) unless block_given?
    #this loop will successively yield tokens to caller
    loop do
      c = @coord
      if @line == nil || @coord.col_index >= @line.size

        #if EOF then @in.next throws a StopIteration exception
        @line = @in.next
        
        c = Coord.new(c.filename, c.line_num + 1, 0)
      end

      #regexp uses capturing paren to extract tokens:
      #m[0] will contain entire match
      #m[1] will contain initial optional linear whitespace
      #m[2] will contain text of entire lexeme
      #the (?: ... ) construct groups like regular paren but no capture
      #m[3] will contain chars token if present
      #m[4] will contain any single char (including newline)
      #terminating /m flag allows . to match any char including newline
      m = @line[c.col_index..-1].match(/([ \t]*)((?:(chars)|(.)))/m)

      c = Coord.new(c.filename, c.line_num, c.col_index + m[1].size)
      lexeme = m[2]
      kind = (m[3]) ? :CHARS : m[4] == "\n" ? :NL : :CHAR
      @coord = Coord.new(c.filename, c.line_num, c.col_index + lexeme.size)

      #yield control back to caller; subsequent explicit or implicit call
      #to next() will resume control after yield (which goes back to loop).
      yield Token.new(kind, lexeme, c)
    end
  end
  
end

#main program
abort "usage #{$0} FILENAME|-" if ARGV.size != 1
UglyRegexpParser.new(Scanner.new(ARGV[0])).parse


