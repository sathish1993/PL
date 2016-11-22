TARGET =   	quiz2


%.pdf:		%.tex
		pdflatex  -file-line-error -interaction=nonstopmode $<


$(TARGET):	$(TARGET).pdf 

clean:
		rm -rf *.log *.aux *~ *.out *.pdf $(TARGET)
