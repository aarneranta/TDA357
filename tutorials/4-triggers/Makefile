all: slides.pdf handout.pdf

slides.pdf: slides.tex
	pdflatex $<

handout.pdf: handout.rst
	pandoc $< -o $@
