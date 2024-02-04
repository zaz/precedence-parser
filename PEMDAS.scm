; A simple parser for PEMDAS arithmetic

; First, implement an EMDAS parser.
; We will first split by ` - `, then ` + `, ` / `, and finally ` * `.
; XXX! Splitting by ` - ` first does not seem to make sense.
; Maybe EMDSA is more appropriate.

(defun test-parse-by-precedence ()
  (assert (equal (parse-by-precedence "+-/*^" "1+2*3-4/5^6") '(+ 1 (- (* 2 3) (/ 4 (^ 5 6))))))
  (assert (equal (parse-by-precedence "+-*/^" "7^8/9*2-4+3") '(+ (- (* (/ (^ 7 8) 9) 2) 4) 3)))
  (assert (equal (parse-by-precedence "+-/*^" "4-3+2*1/5^6") '(+ (- 4 3) (/ (* 2 1) (^ 5 6))))))

(defun parse-by-precedence-backend (precedence str)
  (for-each
   (lambda (substr)
     (parse-by-precedence-backend (cdr precedence) substr))
   (split-string str (car precedence) t)))

(defun parse-by-precedence (precedence str)
  (parse-by-precedence-backend
   (string->list precedence)
   (replace-regexp-in-string " " "" str)))

(test-parse-by-precedence)
