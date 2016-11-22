#!/usr/bin/ruby1.9.1

class Extracter

  attr_reader :extracts, :text

  def initialize(filename, dir)
    @filename = filename
    @extracts = [ ]
    text = read_file(filename)
    @text = extract(text, dir)
  end

  private 

  def read_file(filename)
    File.open(filename) { |f| text = f.read }
  end
  
  def extract(text, dir)
    text1 = extract_inline(text, dir)
    extract_block(text1, dir)
  end

  INLINE_TEX_RE = /\.\$(([^\$]|\$\$)+)\$/
  def extract_inline(text, dir)
    text.gsub(INLINE_TEX_RE) do |s|
      @extracts << "\\(#{$1.gsub("$$", "$")}\\)"
      image_tag(dir)
    end
  end

  BLOCK_TEX_RE = /^((\s*?)\${4,})$(.+?)\1/m
  def extract_block(text, dir)
    text.gsub(BLOCK_TEX_RE) do |s|
      @extracts << $3
      %Q{\n#{$2}.<DIV ALIGN="CENTER">\n#{$2}  #{image_tag(dir)}\n#{$2}.</DIV>\n}
    end
  end

  def image_tag(dir)
    style = 'vertical-align: middle;'
    src = "#{dir}/#{@extracts.size - 1}.gif"
    %Q{.<IMG STYLE="#{style}" SRC="#{src}">}
  end

end

class TexDir
  attr_reader :dir

  def initialize(dir)
    @dir = dir
    File.directory?(dir) || Dir.mkdir(dir)
  end

  def process_extracts(extracts)
    add_extracts(extracts)
    make_images
  end


  private

  def add_extracts(extracts)
    extracts.each_with_index do |text, index|
      File.open("#{dir}/#{index}.tex", "w") do |f|
        f.write(tex_contents(text))
      end
    end
  end

  def make_images
    Dir.chdir(@dir) do
      Dir.glob('*.tex') { |name| system image_script(name) }
    end
  end

  def image_script(texname)
    base = File.basename(texname, '.tex')
    convert_opts = '-density 150x150'
    <<-END_SCRIPT
      latex #{texname}
      dvips -E #{base}.dvi
      convert #{convert_opts} #{base}.ps #{base}.gif
    END_SCRIPT
  end

  def tex_contents(text)
    <<-END_TEX
      \\documentclass{article}
      \\pagestyle{empty}
      \\begin{document}
      #{text}
      \\end{document}
    END_TEX
  end

end

abort "usage: $0 SRC_FILE DEST_FILE TEXDIR" unless ARGV.size == 3
src, dest, texdir = ARGV
extracter = Extracter.new(src, texdir)
File.open(dest, 'w') { |f| f.write(extracter.text) }
texdir = TexDir.new(texdir)
texdir.process_extracts(extracter.extracts)



