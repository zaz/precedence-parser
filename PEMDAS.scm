#!/usr/bin/guile \
-e main -s
!#
; A simple parser for PEMDAS arithmetic

(use-modules (ice-9 readline))
; Use SRFI-64 testing framework.
(use-modules (srfi srfi-64))

; First, implement an EMDAS parser.
; We will first split by ` - `, then ` + `, ` / `, and finally ` * `.
; XXX! Splitting by ` - ` first does not seem to make sense.
; Maybe EMDSA is more appropriate.

; our tokens, in order of precedence, and the commands they map to
(define precedence '(#\+ #\- #\* #\/ #\^))
(define commands   '(  +   -   *   / expt))

; helper functions
(define (remove-spaces str)
  (string-filter (lambda (char) (not (eqv? char #\space))) str))

; this is where the magic happens
(define (parse-by-precedence precedence commands str)
  (if (null? precedence)
      (string->number str)
      (let ((subtree
             (map
              (lambda (substr)
                (parse-by-precedence (cdr precedence) (cdr commands) substr))
              (string-split str (car precedence)))))
        (if (null? (cdr subtree))
            (car subtree)
            (cons (car commands) subtree)))))

(define (eval-by-precedence precedence commands str)
  (eval (parse-by-precedence precedence commands str) (interaction-environment)))

(define (display-parse-and-eval-by-precedence precedence commands str)
  (let ((parsed (parse-by-precedence precedence commands str)))
    (display parsed)
    (display " = ")
    (display (eval parsed (interaction-environment)))
    (newline)))

(define (test)
  (test-begin "parse-by-precedence")
  (display (parse-by-precedence precedence commands "1+2*3-4/5^6"))
  (display " = ")
  (display (eval-by-precedence precedence commands "1+2*3-4/5^6"))
  (newline)
  (test-equal (parse-by-precedence precedence commands "1+2*3-4/5^6")
             '(+ 1 (- (* 2 3) (/ 4 (expt 5 6)))))
  (test-equal (eval-by-precedence precedence commands "1+2*3-4/5^6")
              109371/15625)
  (test-equal (parse-by-precedence precedence commands "7^8/9*2-4+3")
             '(+ (- (* (/ (expt 7 8) 9) 2) 4) 3))
  ; using EMDAS instead of EDMSA
  (test-equal (parse-by-precedence '(#\- #\+ #\/ #\* #\^) '(- + / * expt) "4-3+2*1/5^6")
             '(- 4 (+ 3 (/ (* 2 1) (expt 5 6)))))
  (test-end "parse-by-precedence"))

(define (main args)
  (if (and (not (null? (cdr args))) (equal? (car (cdr args)) "-t"))
      (test)
      (begin
        (display "Enter an arithmetic expression: ")
        (display-parse-and-eval-by-precedence precedence commands (remove-spaces (readline)))
        (main args))))
