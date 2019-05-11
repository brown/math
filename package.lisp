;;;; package.lisp

(defpackage #:math)

(defpackage #:math 
  (:use #:cl #:cl-utilities)
;;;; approximation.lisp
  (:intern math::appr_table)
  (:export 
   math::appr-linear
   math::appr-bilinear
   math::approximate
   )
;;;; matr.lisp     
  (:export math::matr-name
	   math::matr-rows
	   math::matr-cols
	   ;; matr-elements
	   math::matr-ij    
	   math::matr-set_ij  
	   math::matr-set-row 
	   math::matr-get-row 
	   math::matr-set-col 
	   math::matr-get-col 
	   math::matr-new     
	   ;; matr-eval
	   math::matr-mult
	   math::matr->2d-list
	   math::2d-list->matr
	   math::matr-to-point
	   math::point-to-matr
	   math::matr-copy
	   math::matr-to-string
	   math::matr-print
	   math::matr-mnk
	   math::matr-triang
	   math::matr-las-gauss
	   math::matr-osr-func
;;;; statistics.lisp
	   math::square
	   ;; averange
	   math::averange
	   math::averange-value
	   math::averange-not-nil-value
	   ;; exclude
	   math::exclude-nil-from-list
	   math::max-value
	   math::min-value
	   math::dispersion
	   math::standard-deviation
	   math::variation-coefficient
	   math::clean-flagrant-error 
	   math::make-random-value-list
	   math::clean-min-flagrant-error
	   math::clean-max-flagrant-error
;;;; las-rotation.lisp
	   math::matr-rotation
;;;; list-matr.lisp
	   math::list-matr-transpose
	   math::list-matr-union
	   math::list-matr-make
	   math::list-matr-rows
	   math::list-matr-cols
	   math::list-matr-row
	   math::list-matr-col
	   math::list-matr-averange-value
	   math::list-matr-averange-not-nil-value
	   math::list-matr-averange-row-value
	   math::list-matr-averange-row-not-nil-value
	   math::list-matr-max-row-not-nil-value 
	   math::list-matr-averange-col-value
	   math::list-matr-averange-col-not-nil-value
	   math::list-matr-max-col-not-nil-value 
	   math::list-matr-print
	   math::list-vector-print
	   math::list-matr-append-row
	   math::list-matr-append-col
	   math::list-matr-prepend-row
	   math::list-matr-prepend-col
	   )
;;;; matr-class.lisp
  (:export math::matrix
	   math::matrix-data
	   math::matr-name-*
	   math::matr-new*
	   math::copy
	   math::mref
	   math::rows
	   math::cols
	   math::row
	   math::col
	   math::main-diagonal
	   math::anti-diagonal
	   math::matr-eval-*
	   math::matr-mnk*
	   math::matr-equal*
   )
;;;; x-o.lisp
  (:export
   math::play
   math::depth-sphere-along-cone
   )
  )

;;;;(declaim (optimize (space 0) (compilation-speed 0)  (speed 0) (safety 3) (debug 3)))
