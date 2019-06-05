;;;; approximation.lisp

(in-package #:math)

(defun make-2d-list-by-func (func &key (x-from 0) (x-to 1) (step 100))
    (loop :for i :from x-from :to x-to :by (/ (- x-to x-from) step) :collect
	 (list (coerce i 'float) (coerce (funcall func i) 'float))))

(defun spline-1d (x dx arr-Nx2 &key (w-func #'gauss-smoothing))
"Пример использования:
 (spline-1d 1.0 0.6 (make-array '(5 2) :initial-contents '((0.0 0.0) (1.0 1.0) (2.0 2.0) (3.0 3.0) (4.0 4.0)))) 1.0000265 1.0000265
 (spline-1d 1.0 0.4 (make-array '(5 2) :initial-contents '((0.0 0.0) (1.0 1.0) (2.0 2.0) (3.0 3.0) (4.0 4.0)))) 1.0 1.0
 (spline-1d 1.0 0.8 (make-array '(5 2) :initial-contents '((0.0 0.0) (1.0 1.0) (2.0 2.0) (3.0 3.0) (4.0 4.0)))) 1.0027183 1.0027183
 (spline-1d 1.0 1.0 (make-array '(5 2) :initial-contents '((0.0 0.0) (1.0 1.0) (2.0 2.0) (3.0 3.0) (4.0 4.0)))) 1.0210931 1.0210931
 (spline-1d 1.0 1.5 (make-array '(5 2) :initial-contents '((0.0 0.0) (1.0 1.0) (2.0 2.0) (3.0 3.0) (4.0 4.0)))) 1.1591185 1.1591185
"
  (let ((w-summ 0.0)
	(w-z-summ 0.0)
	(w 0.0)
	(z 0.0))
    (loop :for i :from 0 :below  (array-dimension arr-Nx2 0) :do
	 (progn
	   (setf w (funcall w-func (distance-relative x (aref arr-Nx2 i 0 ) dx))
		 w-summ (+ w-summ w)
		 z (aref arr-Nx2 i 1)
		 w-z-summ (+ w-z-summ (* w z )))))
    (/ w-z-summ w-summ)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric approx-by-points (x dx points values &key w-func)
  (:documentation "COOOOOOOOOOL"))

(defmethod approx-by-points ((x number) (dx number) (points vector) (values vector) &key (w-func #'gauss-smoothing))
  "Пример использования:
 (approx-by-points 1.0 0.6 (vector 0.0 1.0 2.0 3.0 4.0) (vector 0.0 1.0 2.0 3.0 4.0)) 1.0000265
 (approx-by-points 1.0 0.4 (vector 0.0 1.0 2.0 3.0 4.0) (vector 0.0 1.0 2.0 3.0 4.0)) 1.0
 (approx-by-points 1.0 0.8 (vector 0.0 1.0 2.0 3.0 4.0) (vector 0.0 1.0 2.0 3.0 4.0)) 1.0027183
 (approx-by-points 1.0 1.0 (vector 0.0 1.0 2.0 3.0 4.0) (vector 0.0 1.0 2.0 3.0 4.0)) 1.0210931
 (approx-by-points 1.0 1.5 (vector 0.0 1.0 2.0 3.0 4.0) (vector 0.0 1.0 2.0 3.0 4.0)) 1.1591185
"
  (assert (= (length points) (length values)))
  (let ((w-summ 0.0)
	(w-z-summ 0.0)
	(w 0.0)
	(z 0.0))
    (loop :for i :from 0 :below  (array-dimension points 0) :do
	 (progn
	   (setf w (funcall w-func (distance-relative x (aref points i) dx))
		 w-summ (+ w-summ w)
		 z (aref values i)
		 w-z-summ (+ w-z-summ (* w z )))))
    (/ w-z-summ w-summ)))



(defmethod approx-by-points ((x vector) (dx vector) (points array) (values vector) &key (w-func #'gauss-smoothing))
  "Пример использования:
 
 (approx-by-points (vector 0.0 0.0) (vector 1.0 1.0) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 0.53788286
 (approx-by-points (vector 0.0 0.0) (vector 0.6 0.6) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 0.117073804
 (approx-by-points (vector 0.0 0.0) (vector 0.4 0.4) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 0.0038534694

 (approx-by-points (vector 1.0 0.0) (vector 1.0 1.0) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
 (approx-by-points (vector 1.0 0.0) (vector 0.6 0.6) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 0.9999999
 (approx-by-points (vector 1.0 0.0) (vector 0.4 0.4) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0

 (approx-by-points (vector 0.0 1.0) (vector 1.0 1.0) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
 (approx-by-points (vector 0.0 1.0) (vector 0.6 0.6) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
 (approx-by-points (vector 0.0 1.0) (vector 0.4 0.4) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0

 (approx-by-points (vector 1.0 1.0) (vector 1.0 1.0) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.4621171
 (approx-by-points (vector 1.0 1.0) (vector 0.6 0.6) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.8829262
 (approx-by-points (vector 1.0 1.0) (vector 0.4 0.4) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.9961466

 (approx-by-points (vector 0.5 0.5) (vector 1.0 1.0) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
 (approx-by-points (vector 0.5 0.5) (vector 0.6 0.6) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
 (approx-by-points (vector 0.5 0.5) (vector 0.4 0.4) (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0)) 1.0
"
  (assert (= (array-rank points) 2))
  (assert (= (array-dimension points 0) (length values)))
  (assert (= (array-dimension points 1) (length x) (length dx)))
  (let ((w-summ 0.0)
	(w-z-summ 0.0)
	(w 0.0)
	(z 0.0))
    (loop :for i :from 0 :below  (array-dimension points 0) :do
	 (progn
	   (setf w (funcall w-func (distance-relative x (row i points) dx))
		 w-summ (+ w-summ w)
		 z (aref values i)
		 w-z-summ (+ w-z-summ (* w z )))))
    (/ w-z-summ w-summ)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun gauss-1-approximation-array (a-const &key (dx0 1.0) (delta 0.001) (iterations 10000))
  "Вычисляет такой массив, что при сглаживании его по формуле Гаусса
с характерным размером dx0, сумма расстояний до 2d точек заданных массивом a-const не превысит
delta
"
  (labels
      ((summ-distance (a1 a2)
	 "Возвращает сумму расстояний между 2d-точками, содержащимися в массивах a1 и a2"
	 (let ((summ 0.0))
	   (loop :for i :from 0 :below (array-dimension a1 0) :do
		(setf summ
		      (+ summ
			 (sqrt (apply #'+
				      (mapcar
				       #'(lambda (x) (* x x))
				       (list (- (aref a1 i 0) (aref a2 i 0))
					     (- (aref a1 i 1) (aref a2 i 1)))))))))
	   summ))
       (start-V1 (a-rez a-iter a-const &key (dx0 0.8))
	 (loop :for i :from 0 :below (array-dimension a-const 0) :do
	      (setf (aref a-rez i 1) (spline-1d (aref a-iter i 0) dx0 a-iter)))
	 (summ-distance a-rez a-const))
       (iterate (a-rez a-iter a-const)
	 (loop :for i :from 0 :below (array-dimension a-const 0) :do
	      (setf (aref a-iter i 1)
		    (+ (aref a-iter i 1) (* 1 (- (aref a-const i 1) (aref a-rez i 1)) )))))
       )
    (let ((a-iter (copy-array a-const))
	  (a-rez  (copy-array a-const)))
      (do* ((i    0 (1+ i))
	    (dist (start-V1 a-rez a-iter a-const :dx0 dx0 ) (start-V1 a-rez a-iter a-const :dx0 dx0)))
	   ((or (> i iterations) (< dist delta))
	    (if (< i iterations)
		(values a-iter t)
		(values a-iter nil)))
	(iterate a-rez a-iter a-const)
	;(format t "I=~D; DIST=~F; AITER~S;~%" i dist a-iter )
	))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;;; ;;;
(defgeneric gauss-2-approximation-array (points values dx0 &key delta iterations)
  (:documentation "COOOOOOOOOOOOOL"))

(defmethod gauss-2-approximation-array ((points array) (values vector) (dx0 vector) &key (delta 0.001) (iterations 10000))
  "Вычисляет такой массив, что при сглаживании его по формуле Гаусса
с характерным размером dx0, сумма расстояний до 2d точек заданных массивом points не превысит
delta
Тестирование:
 (gauss-2-approximation-array (make-array '(5 2) :initial-element 0.0) (vector 1.0 2.0 3.0 4.0 5.0) (vector 1.0 1.0))

  Пример использования:

 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 1.0 1.0))
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.6 0.6))
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.4 0.4))

 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 1.0 1.0)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.6 0.6)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.4 0.4)) 

 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 1.0 1.0)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.6 0.6)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.4 0.4)) 

 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 1.0 1.0)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.6 0.6)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.4 0.4)) 

 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 1.0 1.0)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.6 0.6)) 
 (gauss-2-approximation-array (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0))) (vector 0.0 1.0 1.0 2.0) (vector 0.4 0.4)) 
"

  (assert (= (array-rank points) 2))
  (assert (= (array-dimension points 0) (length values)))
  (assert (= (array-dimension points 1) (length dx0)))
  (let ((v-iter (copy-array values))
	(v-rez  (copy-array values)))
    (labels ((start-V1 (v-rez v-iter)
	       (loop :for i :from 0 :below (array-dimension points 0) :do
		    (setf (svref v-rez i) (approx-by-points (row i points) dx0 points v-iter )))
	       (summ-distance v-rez values))
	     (iterate (v-rez v-iter)
	       (loop :for i :from 0 :below (array-dimension points 0) :do
		    (setf (svref v-iter i)
			  (+ (svref v-iter i) (* 1 (- (svref values i) (svref v-rez i))))))))
      (do ((i    0 (1+ i))
	   (dist (start-V1 v-rez v-iter ) (start-V1 v-rez v-iter)))
	  ((or (> i iterations) (< dist delta))
	   (if (< i iterations)
	       (values v-iter t)
	       (values v-iter nil)))
	(iterate v-rez v-iter)
	(format t "I=~D; DIST=~F; V-ITER~S;~%" i dist v-iter )
	))))

(gauss-2-approximation-array
 (make-array '(4 2) :initial-contents '((0.0 0.0) (1.0 0.0) (0.0 1.0) (1.0 1.0)))
 (vector 0.0 1.0 1.0 2.0)
 (vector 0.8 0.8) :delta 0.00001 :iterations 10) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;(require :temperature-fild)
(defparameter *h-r*
  (apply #'vector
   (reverse
    (temperature-fild:t-fild-termopara-hight-relative
     temperature-fild:*dn80*))))

(defparameter *x-r*
  (apply #'vector (list -2 -1  0  1  2)))

(defparameter *a* (make-array '(5 5) :initial-contents
			      '((117.0 120.5 118.5 112.5 115.0)
				(115.0 125.5 119.5 122.5 112.0)
				(113.0 135.5 129.5 132.5 117.0)
				(112.0 122.5 123.5 122.5 112.0)
				(111.0 115.5 119.5 102.5 102.0))))


+++++++++++++++++++++++++++++++++++++++++++++++++
(defmethod make-tmpr ((t-fild array) (r-hight vector) (r-length vector))
  (assert (= (array-rank t-fild) 2))
  (assert (= (array-dimension t-fild 0) (length r-hight)))
  (assert (= (array-dimension t-fild 1) (length r-length)))
  (let ((pts (make-array (* ))
  (loo
  "ZBS"
  )
+++++++++++++++++++++++++++++++++++++++++++++++++
(make-tmpr *a* *h-r* *x-r*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *arr-2xN* (make-array '(5 2) :initial-contents '((-2.0 0.91553) (-1.0 1.15765) (0.0 1.68105) (1.0 1.15759) (2.0 0.9213))))

(defparameter *a-rez* (gauss-1-approximation-array *arr-2xN* :dx0 1.0 :delta 0.000001 :iterations 100))

(defun g-1-0 (x) (spline-1d x 1.0 *a-rez*))

(gnuplot-data-to-file (make-2d-list-by-func 'g-1-0 :x-from -25/10 :x-to 25/10 :step 100) "~/apr.data")

(defmethod gnuplot-data-to-file ((ar array) f-name)
  (with-open-file (os f-name :direction :output :if-exists :supersede )
    (loop :for i :from 0 :below (array-dimension ar 0) :do
	 (loop :for j :from 0 :below (array-dimension ar 1) :do
	      (format os "~F " (aref ar i j)))
	 (format os "~%" ))))

(gnuplot-data-to-file *arr-2xn* "~/pts.data")
	 
(make-2d-list-by-func 'g-1-0 :x-from -25/10 :x-to 25/10 :step 100)

(defun g-1-0 (x) (spline-1d x 1.0 *arr-2xN*))
(defun g-0-8 (x) (spline-1d x 0.8 *arr-2xN*))
(defun g-0-6 (x) (spline-1d x 0.6 *arr-2xN*))
(defun g-0-4 (x) (spline-1d x 0.4 *arr-2xN*))

(defun h-1-0 (x) (spline-1d x 1.0 *arr-2xN* :W-FUNC 'hann-smoothing)) 
(defun h-0-8 (x) (spline-1d x 0.8 *arr-2xN* :W-FUNC 'hann-smoothing))
(defun h-0-6 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'hann-smoothing))
(defun h-0-4 (x) (spline-1d x 0.4 *arr-2xN* :W-FUNC 'hann-smoothing))

(defun m-1-0 (x) (spline-1d x 1.0 *arr-2xN* :W-FUNC 'mann-w-1d)) 
(defun m-0-8 (x) (spline-1d x 0.8 *arr-2xN* :W-FUNC 'mann-w-1d))
(defun m-0-6 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'mann-w-1d))
(defun m-0-4 (x) (spline-1d x 0.4 *arr-2xN* :W-FUNC 'mann-w-1d))


(defun c-1-0 (x) (spline-1d x 1.0 *arr-2xN* :W-FUNC 'cauchy-smoothing)) 
(defun c-0-8 (x) (spline-1d x 0.8 *arr-2xN* :W-FUNC 'cauchy-smoothing))
(defun c-0-6 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'cauchy-smoothing))
(defun c-0-4 (x) (spline-1d x 0.4 *arr-2xN* :W-FUNC 'cauchy-smoothing))


(defun e-1-0 (x) (spline-1d x 1.0 *arr-2xN* :W-FUNC 'exp-smoothing )) 
(defun e-0-8 (x) (spline-1d x 0.8 *arr-2xN* :W-FUNC 'exp-smoothing ))
(defun e-0-6 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'exp-smoothing ))
(defun e-0-4 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'exp-smoothing ))

(defun e3-1-0 (x) (spline-1d x 1.0 *arr-2xN* :W-FUNC 'exp-3-w-1d )) 
(defun e3-0-8 (x) (spline-1d x 0.8 *arr-2xN* :W-FUNC 'exp-3-w-1d ))
(defun e3-0-6 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'exp-3-w-1d ))
(defun e3-0-4 (x) (spline-1d x 0.6 *arr-2xN* :W-FUNC 'exp-3-w-1d ))



(gnuplot-list-to-file (make-2d-list-by-func 'g-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/gauss-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'g-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/gauss-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'g-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/gauss-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'g-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/gauss-0.4.data")

(gnuplot-list-to-file (make-2d-list-by-func 'e-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp-0.4.data")

(gnuplot-list-to-file (make-2d-list-by-func 'e3-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp3-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e3-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp3-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e3-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp3-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'e3-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/exp3-0.4.data")

(gnuplot-list-to-file (make-2d-list-by-func 'h-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/hann-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'h-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/hann-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'h-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/hann-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'h-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/hann-0.4.data")

(gnuplot-list-to-file (make-2d-list-by-func 'm-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/mann-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'm-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/mann-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'm-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/mann-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'm-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/mann-0.4.data")


(gnuplot-list-to-file (make-2d-list-by-func 'c-1-0 :x-from -25/10 :x-to 25/10 :step 100)  "~/cauchy-1.0.data")
(gnuplot-list-to-file (make-2d-list-by-func 'c-0-8 :x-from -25/10 :x-to 25/10 :step 100)  "~/cauchy-0.8.data")
(gnuplot-list-to-file (make-2d-list-by-func 'c-0-6 :x-from -25/10 :x-to 25/10 :step 100)  "~/cauchy-0.6.data")
(gnuplot-list-to-file (make-2d-list-by-func 'c-0-4 :x-from -25/10 :x-to 25/10 :step 100)  "~/cauchy-0.4.data")

(let ((dx 1.5))
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN*)))
			"d:/PRG/msys/home/namatv/test.data")
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'exp-smoothing)))
			"d:/PRG/msys/home/namatv/test1.data")

  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'cauchy-smoothing)))
			"d:/PRG/msys/home/namatv/test2.data")

  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'hann-smoothing)))
			"d:/PRG/msys/home/namatv/test3.data")
  
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'mann-w-1d)))
			"d:/PRG/msys/home/namatv/test4.data")

  )


gnuplot
plot "test.data" with lines, "test1.data" with lines, "test2.data" with lines, "test3.data" with lines, "test4.data" with lines;


(/ 1 0.61805)
