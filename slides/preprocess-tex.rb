#!/usr/bin/ruby

require 'strscan'

class TeXPreprocessor
  
  def initialize(filename, outstream)
    @filename, @outstream, @lineno = filename, outstream, -1
  end
  
  
  ILOC_RE = 
    %r{^\s*             #optional starting whitespace
     (:(\w+)\s*:)?\s* #optional label
     (\w+)\s*         #opcode
     (.+?)\s*         #src operands
     (=>)?\s*         #arrow
     ([^;=]+?)\s*      #dest
     (;.*?)?\s*$      #comment
    }x

  def do_iloc_sched(lines, startlineno)
    @outstream.print("\\[\n\\begin{array}{rrllllll}\n")
    @outstream.print("\\mbox{\\textbf{Start}} & \\mbox{\\textbf{End}}\\\\\n")
    lines.each_with_index do |line, index|
      line.match(/^\s*(\d+)\s+(\d+)/) do |m|
        start, stop = m.captures
        @outstream.print("#{start} & #{stop} & ")
        do_iloc_line(line[m.end(0)..-1])
        @outstream.print("\\\\") if index != lines.size - 1
        @outstream.print("\n")
      end
    end
    @outstream.print("\\end{array}\n\\]\n")
  end

  def do_iloc(lines, startlineno)
    @outstream.print("\\[\n\\begin{array}{llllll}\n")
    lines.each_with_index do |line, index|
      do_iloc_line(line)
      @outstream.print("\\\\") if index != lines.size - 1
      @outstream.print("\n")
    end
    @outstream.print("\\end{array}\n\\]\n")
  end

  def do_iloc_line(line)
    s = StringScanner.new(line)
    s.scan(/\s*/)
    label = (s.scan(/[\w\\]+\s*:/) || '')[0..-2]
    s.scan(/\s*/)
    op = s.scan(/[\w\\]+/); 
    abort "bad iloc line #{line}" if !op
    s.scan(/\s*/)
    src = (s.scan(%r![^\/\=]+!) || '').strip
    arrow = s.scan(/=>/)
    s.scan(/\s*/)
    dest = s.scan(%r![^\/]+!) || ''
    s.scan(/\s*/)
    comment = (s.scan(%r!//.+!) || '//')[2..-1]
    @outstream.print(label.size > 0 ? "\\mathtt{#{label}:} & " : " & ")
    [op, src].each { |x| @outstream.print("\\mathtt{#{x}} & ") }
    @outstream.print(arrow ? "\\Rightarrow & " : "& ")
    @outstream.print("\\mathtt{#{dest}} &")
    @outstream.print("\\mathtt{//#{comment}}") if comment
  end

  class Tree 

    attr_reader :node, :kids, :id

    def initialize(node)
      @node = node; @kids = [];
    end
    
    def add_kid(kid) 
      @kids << kid
    end

    def label
      (@node[0] == '"') ? @node : "\"#{@node}\""
    end

    def set_ids(n)
      @id = "n#{n}"
      n += 1
      @kids.each { |kid| n = kid.set_ids(n) }
      n
    end

    INDENT = ' ' * 10

    def out_nodes(s)
      s << "#{INDENT}#{@id} [label=#{label}];\n"
      @kids.each { |kid| kid.out_nodes(s) }
      s
    end

    def out_edges(s)
      kids.each do |kid|
        s << "#{INDENT}#{@id} -- #{kid.id};\n"
        kid.out_edges(s)
      end
    end

    def self.to_dot(tree)
      s = <<-DOT_START
        graph AST {
          node [shape=none];
          bgcolor=transparent;
          ordering=out;
      DOT_START
      if tree.kids.size == 0
        s << tree.label
      else
       tree.set_ids(0)
       tree.out_nodes(s)
       tree.out_edges(s)
      end
      s << "#{INDENT[2..-1]}}\n"
      s
    end

    def self.to_png(tree, filename)
      File.open("#{filename}.dot", "w") { |f| f.write(to_dot(tree)) }
      dot = "dot -T png #{filename}.dot -o #{filename}.png\n"
      warn $? if !system dot
    end
    
  end

  class TreeBuilder

    def initialize(lineno, treespec)
      @lineno, @treespec, @scan = lineno, treespec, treespec
    end

    EOF_TOK = -1
    ID_TOK = -2

    def next_token()
      @scan = @scan.sub(/^\s+/, '')
      return [EOF_TOK, '<EOF>'] if @scan.size == 0
      case @scan
        when /\A\(/
          tok = ['(', '(']
        when /\A\)/
          tok = [')', ')']
        when /\A(\"([^\"\\]|\\.)*\")/
          tok = [ID_TOK, $1]
        when /\A(\'([^\'\\]|\\.)*\')/
          tok = [ID_TOK, $1]
        when /\A([^\(\)\s]+)/
          tok = [ID_TOK, $1]
      end
      @scan = @scan[tok[1].size..-1] 
      return tok
    end

    def parse
      if @tok[0] == ID_TOK
        id = @tok[1]
        @tok = next_token
        return Tree.new(id)
      elsif @tok[0] == '('
        @tok = next_token
        if @tok[0] != ID_TOK
          warn "#{@lineno}: expecting ID after (\n"
          return nil
        end
        id = @tok[1]
        tree = Tree.new(id)
        @tok = next_token
        while (@tok[0] != ')' && @tok[0] != EOF_TOK)
          kid = parse
          return kid if !kid
          tree.add_kid(kid)
        end
        if @tok[0] == ')'
          @tok = next_token
          return tree
        end
        warn "@{lineno}: missing closing )\n"
        return nil
      end
    end
       
    def build
      @tok = next_token
      parse
    end

  end

  DIR_SEPARATOR = ':'
  def do_include_path(lines, startlineno)
    @include_dirs = []
    lines.each do |line|
      line.strip.split(DIR_SEPARATOR).each { |d| @include_dirs.push(d) }
    end
  end

  def find_include_file(filename)
    @include_dirs.each do |d| 
      p = "#{d}/#{filename}"
      return p if File.exist?(p)
    end
    return nil
  end

  def include_file(directive, filepath, begintag, endtag, deletetag)
    including = false
    File.open(filepath) do |f|
      f.each do |line|
        if !including
          if line =~ /#{begintag}/
            cleaned = line.sub("#{begintag}", "")
            do_out = (cleaned =~ /\w/)
            startN = (do_out) ? f.lineno : f.lineno + 1
            @outstream.print "\\begin{#{directive}*}{firstnumber=#{startN}}\n"
            @outstream.print cleaned if do_out
            including = true
          end
        elsif line =~ /#{endtag}/
          break
        else
          @outstream.print line if line !~ /#{deletetag}/
        end
      end #f.each
      abort "could not find begintag #{begintag} in #{filepath}\n" if !including
      @outstream.print("\\end{#{directive}*}\n")
    end
  end

  IMPOSSIBLE = '!@#$%'

  def do_include(startline, startlineno, directive)
    restline = startline.sub(/\s*@\w+\{\w+\}/, '')
    filename = restline[/\{([^\}]+)\}/, 1]
    filepath = find_include_file(filename) or
      abort "#{@filename}:#{startlineno}: cannot include file #{filename}"
    begintag = restline[/begintag\s*=\s*([^\s\,\]\}]+)/, 1]
    endtag = restline[/endtag\s*=\s*([^\s\,\]\}]+)/, 1]
    deletetag = restline[/deletetag\s*=\s*([^\s\,\]\}]+)/, 1]
    langcode = directive.sub('file', 'code')
    include_file(langcode, filepath, begintag || '', endtag || IMPOSSIBLE,
                 deletetag || IMPOSSIBLE)
  end

  def do_tree(lines, startlineno, startline)
    restline = startline.sub(/\s*@\w+\{\w+\}/, '')
    filename = restline[/\{([^\}]+)\}/, 1]
    builder = TreeBuilder.new(startlineno, lines.join(''))
    Tree::to_png(builder.build, filename)
  end

  def do_tag(tag, lines, startlineno, startline)
    case tag
    when 'iloc'
      do_iloc(lines, startlineno)
    when 'iloc_sched'
      do_iloc_sched(lines, startlineno)
    when 'cfile'
      do_include(startline, startlineno, 'cfile')
    when 'javafile'
      do_include(startline, startlineno, 'javafile')
    when 'jsfile'
      do_include(startline, startlineno, 'jsfile')
    when 'perlfile'
      do_include(startline, startlineno, 'perlfile')
    when 'rubyfile'
      do_include(startline, startlineno, 'rubyfile')
    when 'prologfile'
      do_include(startline, startlineno, 'prologfile')
    when 'haskellfile'
      do_include(startline, startlineno, 'haskellfile')
    when 'scmfile'
      do_include(startline, startlineno, 'scmfile')
    when 'include_path'
      do_include_path(lines, startlineno)
    when 'tree'
      do_tree(lines, startlineno, startline)
    else
      abort "unknown tag #{tag}\n"
    end
  end

  def preprocess()
    File.open(@filename) do |f|
      tag, lineno, lines, startline = nil, -1, [], nil
      f.each_line do |line|
        @lineno = f.lineno
        case line
        when %r!^\s*@end{(\w+)}!
          abort "unexpected @end{#{$1}}\n" if !tag
          abort "expected @end{#{tag}} but got @end{#{$1}}\n" if $1 != tag
          do_tag(tag, lines, lineno, startline)
          tag, lineno, lines = nil, -1, [], nil
        when %r!^\s*@begin{(\w+)}!
          abort "found tag #{$1} inside tag #{tag}\n" if tag
          tag, lineno, lines, startline = $1, f.lineno, [], line
        when %r!^\s*@pre{(\w+)}!
          do_tag($1, lines, f.lineno, line)
        else
          if tag
            lines.push line 
          else
            @outstream.print line
          end
        end #case
      end #f.each
    end #File open
  end

end


abort "usage: #{$0} PRETEX_FILE\n" if ARGV.size != 1 or !File.exist? ARGV[0]
TeXPreprocessor.new(ARGV[0], STDOUT).preprocess()
