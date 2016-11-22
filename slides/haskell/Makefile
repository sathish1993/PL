#Makefile for maintaining slide files.

TOPIC=		haskell

#Path definitions
PREPROCESS_TEX = ../preprocess-tex.rb

%.tex:			%.pretex
			$(PREPROCESS_TEX) $< > $@

%.pdf:			%.tex
			pdflatex -shell-escape $< 

all:			$(TOPIC).pdf


clean:
			rm -f $(TOPIC).aux $(TOPIC).tex $(TOPIC).nav \
			      $(TOPIC).out $(TOPIC).pdf $(TOPIC).snm
