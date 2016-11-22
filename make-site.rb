#!/usr/bin/ruby

require 'set'

INDEX = 'index.html'

PAGES = [
  {
    'desc' => 'Home',
    'dir' => '',
    'doIndex' => true,
    'courseNameInHead' => true,
  },
  {
    'desc' => 'Announcements',
    'dir' => '',
    'name' => 'announce.html',
  },
  {
    'desc' => 'Documentation',
    'dir' => 'docs',
    'doIndex' => true
  },
  {
    'desc' => 'Exams & Quizzes',
    'dir' => 'exams-quizzes',
    'doIndex' => true
  },
  {
    'desc' => 'Homeworks',
    'dir' => 'hws',
    'doIndex' => true
  },
#  {
#    'desc' => 'Interludes',
#    'dir' => 'interludes',
#    'doIndex' => true
#  },
#  {
#    'desc' => 'Labs',
#    'dir' => 'labs',
#    'doIndex' => true
#  },
  {
    'desc' => 'Miscellaneous',
    'dir' => 'misc',
    'doIndex' => true
  },
  {
    'desc' => 'Programs',
    'dir' => 'programs',
    'doIndex' => true
  },
  {
    'desc' => 'Projects',
    'dir' => 'projects',
    'doIndex' => true
  },
  {
    'desc' => 'Slides',
    'dir' => 'slides',
    'doIndex' => true
  },
]

DIRS = {}
PAGES.map { |page| DIRS[page['dir']] = page['desc'] if page['doIndex'] }


PAGE = <<END_PAGE_TEMPLATE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<link href="$base/style.css" rel="stylesheet" type="text/css" />
<title>$title</title>
</head>
<body>
<div id="page">
<div id="header">
<h1>$head</h1>
<h2>$subHead</h2>
</div> <!-- #header -->
<div id="main">
<div id="content">
</div> <!-- #content -->
</div> <!-- #main -->
<div id="nav">
<ul>
$nav
</ul>
</div> <!-- #nav -->
<div id="footer">&nbsp;</div>
</div> <!-- #page -->
</body>
</html>
END_PAGE_TEMPLATE

#Return navigation list with specified path base to the base directory for
#the index page for dir.
def mkNav(base, dir) 
  nav = '';
  for d in DIRS.keys.sort
    desc = DIRS[d]
    if (desc) 
      if (d == dir) 
        nav += "<li>#{desc}</li>\n";
      else 
        url = 
          (d.length > 0) ? base + '/' + d + '/' + INDEX \
                         : base + '/' + INDEX
        nav += "<li><a href=\"#{url}\">#{desc}</a></li>\n"
      end
    end
  end 
  return nav
end

def go(courseNumber, courseName, semester)
  for page in PAGES
    d = page['dir']
    isHome = (d.length == 0)
    Dir.mkdir d if (!isHome && !FileTest.exist?(d))
    base = (isHome) ? '.' : '..';
    nav = mkNav(base, d)
    head = "#{courseNumber} #{semester}"
    subHead = (page['courseNameInHead']) ? courseName : page['desc'];
    title = "#{courseNumber}: #{subHead}"
    content = String.new PAGE
    for w in %w(base nav head subHead title)
      content.gsub!("$#{w}", "#{eval(w)}")
    end
    baseName = page['name'] || INDEX
    fileName = (d.length > 0) ? d + '/' + baseName : baseName
    File.open(fileName, "w") do |f| f.print(content) end
  end
end

if (ARGV.length != 3) 
  print "usage: #$0 COURSE_NUMBER COURSE_NAME SEMESTER\n"
else 
  go(*ARGV)
end


