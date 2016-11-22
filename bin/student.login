#student startup file for csh-type login shells
[ -e ~/cs571-16f ] || ln -f -s ~umrigar/cs571-16f ~/cs571-16f >& /dev/null
[ -e ~/.emacs ] || ln -s ~umrigar/cs571-16f/bin/student.emacs ~/.emacs >& /dev/null
~/cs571-16f/bin/login-changes.rb cs571-16f
setenv PATH "$HOME/cs571-16f/bin:/opt/local/bin:/opt/sfw/bin:$PATH"
#if ( ${?MANPATH} == 0 ) then
#  setenv MANPATH $HOME/cs571-16f/man
#else
#  setenv MANPATH $HOME/cs571-16f/man:$MANPATH
#endif
if ( ${?LD_LIBRARY_PATH} == 0 ) then
  setenv LD_LIBRARY_PATH .:$HOME/cs571-16f/lib
else
  setenv LD_LIBRARY_PATH .:$HOME/cs571-16f/lib:$LD_LIBRARY_PATH
endif
if ( ${?CLASSPATH} == 0 ) then
  setenv CLASSPATH .:$HOME/cs571-16f/lib
else
  setenv CLASSPATH .:$HOME/cs571-16f/lib:$CLASSPATH
endif

