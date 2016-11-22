#Path definitions
PERL= 		/usr/bin/perl
UMT=		/home/zdu/projects/umt/umt
HTML2PS= 	html2ps
PS2PDF=		ps2pdf

TARGET =	grading-guidelines

$(TARGET):		$(TARGET).html $(TARGET).pdf

$(TARGET).html:		$(TARGET).umt
			$(UMT) $< >$@

$(TARGET).pdf:		$(TARGET).html
			$(HTML2PS) -N 0 -n $(TARGET).html > $(TARGET).ps
			$(PS2PDF) $(TARGET).ps 
			rm -f $(TARGET).ps


