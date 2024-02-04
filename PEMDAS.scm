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

(define (parse-by-precedence-backend precedence str)
  (if (null? precedence)
      (string->number str)
      (map
       (lambda (substr)
         (parse-by-precedence-backend (cdr precedence) substr))
       (string-split str (car precedence)))))

(define (parse-by-precedence precedence str)
  (parse-by-precedence-backend
   (string->list precedence)
   (string-filter (lambda (char) (not (eqv? char #\space))) str)))

(define (main args)
  (test-begin "parse-by-precedence")
  (display (parse-by-precedence "+-/*^" "1+2*3-4/5^6"))
  (newline)
  (test-eqv (parse-by-precedence "+-/*^" "1+2*3-4/5^6") '(+ 1 (- (* 2 3) (/ 4 (expt 5 6)))))
  (test-eqv (parse-by-precedence "+-*/^" "7^8/9*2-4+3") '(+ (- (* (/ (expt 7 8) 9) 2) 4) 3))
  (test-eqv (parse-by-precedence "+-/*^" "4-3+2*1/5^6") '(+ (- 4 3) (/ (* 2 1) (expt 5 6))))
  (test-end "parse-by-precedence"))
