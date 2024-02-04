#!/usr/bin/guile \
-e main -s
!#
; A simple parser for PEMDAS arithmetic

; Use SRFI-64 testing framework.
(use-modules (srfi srfi-64))

; First, implement an EMDAS parser.
; We will first split by ` - `, then ` + `, ` / `, and finally ` * `.
; XXX! Splitting by ` - ` first does not seem to make sense.
; Maybe EMDSA is more appropriate.

; our tokens, in order of precedence, and the commands they map to
(define precedence '(#\+ #\- #\/ #\* #\^))
(define commands   '(  +   -   /   * expt))

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

(define (main args)
  (test-begin "parse-by-precedence")
  (display (parse-by-precedence precedence commands "1+2*3-4/5^6"))
  (newline)
  (test-equal (parse-by-precedence precedence commands "1+2*3-4/5^6")
           '(+ 1 (- (* 2 3) (/ 4 (expt 5 6)))))
  (test-equal (parse-by-precedence '(#\+ #\- #\* #\/ #\^) '(+ - * / expt) "7^8/9*2-4+3")
           '(+ (- (* (/ (expt 7 8) 9) 2) 4) 3))
  (test-equal (parse-by-precedence precedence commands "4-3+2*1/5^6")
           '(+ (- 4 3) (/ (* 2 1) (expt 5 6))))
  (test-end "parse-by-precedence"))
