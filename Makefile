# "run", test" and "clean" are not files
.PHONY: run test clean

# default action: run tests
test:
	guile -l precedence-parser.scm -c '(test)'

run:
	guile -l precedence-parser.scm

clean:
	rm -f EDMSA.log EMDAS.log AMN.log
