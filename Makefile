# "run", test" and "clean" are not files
.PHONY: run test clean

# default action: run tests
test:
	guile -l PEMDAS.scm -c '(test)'

run:
	guile -l PEMDAS.scm

clean:
	rm -f EDMSA.log EMDAS.log AMN.log
