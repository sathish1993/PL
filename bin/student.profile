#student startup file for login sh-type shells
[ -e ~/cs571-16f ] || ln -f -s ~umrigar/cs571-16f ~/cs571-16f >& /dev/null
[ -e ~/.emacs ] || ln -s ~umrigar/cs571-16f/bin/student.emacs ~/.emacs >& /dev/null
~/cs571-16f/bin/login-changes.rb cs571-16f
PATH="$HOME/cs571-16f/bin:$PATH"
export PATH
#if [ -z "$MANPATH" ]; then
#  MANPATH=$HOME/cs571-16f/man
#else
#  MANPATH=$HOME/cs571-16f/man:$MANPATH
#fi
#export MANPATH
if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=.:$HOME/cs571-16f/lib
else
  LD_LIBRARY_PATH=.:$HOME/cs571-16f/lib:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH
if [ -z "$CLASSPATH" ]; then
  CLASSPATH=.:$HOME/cs571-16f/lib
else
  CLASSPATH=.:$HOME/cs571-16f/lib:$CLASSPATH
fi
export CLASSPATH
