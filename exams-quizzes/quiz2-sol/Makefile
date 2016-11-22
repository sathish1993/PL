TARGET =   	quiz2-sol


%.pdf:		%.tex
		pdflatex  -file-line-error -interaction=nonstopmode $<


$(TARGET):	$(TARGET).pdf 

clean:
		rm -rf *.log *.aux *~ *.out *.pdf $(TARGET)
