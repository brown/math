;;;; smoothing.lisp

(in-package #:math)

(export 'gauss-smoothing)
(defun gauss-smoothing (d)
  "@b(Описание:) функция @b(gauss-smoothing)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (loop :for d :from 0 :to 4 :by 1/10 :collect
     (list d (gauss-smoothing d)))
@end(code)
"
  (exp (* -1 d d)))

(export 'exp-smoothing)
(defun exp-smoothing (d)
  "@b(Описание:) функция @b(exp-smoothing)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (loop :for d :from 0 :to 4 :by 1/10 :collect
     (list d (exp-smoothing d)))
@end(code)
"
  (exp (* -1 d)))

(export 'cauchy-smoothing)
(defun cauchy-smoothing (d)
  "@b(Описание:) функция @b(cauchy-smoothing)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (loop :for d :from 0 :to 4 :by 1/10 :collect
     (list d (cauchy-smoothing d)))
@end(code)
"
  (/ 1 (+ 1 (* d d))))

(export 'hann-smoothing)
(defun hann-smoothing (d)
  "@b(Описание:) функция @b(hann-smoothing)

 @b(Пример использования:)
@begin[lang=lisp](code)
  (loop :for d :from 0 :to 4 :by 0.1 :do
     (format t \"~{~5F~^ ~}~%\" 
             (list d 
               (gauss-smoothing  d)
               (exp-smoothing    d)
               (cauchy-smoothing d)
               (hann-smoothing   d))))
@end(code)
"
  (if (< d 1) (* 1/2 ( + 1 ( cos (* pi d)))) 0))

