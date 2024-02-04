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

(define precedence '(#\+ #\- #\/ #\* #\^))
(define execute    '(  +   -   /   * expt))

(define (parse-by-precedence-backend precedence execute str)
  (if (null? precedence)
      (string->number str)
      (let ((subtree
             (map
              (lambda (substr)
                (parse-by-precedence-backend (cdr precedence) (cdr execute) substr))
              (string-split str (car precedence)))))
        (if (null? (cdr subtree))
            (car subtree)
            (cons (car execute) subtree)))))

(define (parse-by-precedence precedence execute str)
  (parse-by-precedence-backend
   precedence
   execute
   (string-filter (lambda (char) (not (eqv? char #\space))) str)))

(define (main args)
  (test-begin "parse-by-precedence")
  (display (parse-by-precedence precedence execute "1+2*3-4/5^6"))
  (newline)
  (test-equal (parse-by-precedence precedence execute "1+2*3-4/5^6")
           '(+ 1 (- (* 2 3) (/ 4 (expt 5 6)))))
  (test-equal (parse-by-precedence '(#\+ #\- #\* #\/ #\^) '(+ - * / expt) "7^8/9*2-4+3")
           '(+ (- (* (/ (expt 7 8) 9) 2) 4) 3))
  (test-equal (parse-by-precedence precedence execute "4-3+2*1/5^6")
           '(+ (- 4 3) (/ (* 2 1) (expt 5 6))))
  (test-end "parse-by-precedence"))
