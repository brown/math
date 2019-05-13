;;;; approximation-test.lisp

(in-package #:math)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Тестирование
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(pcl:deftest test-approximation-appr_table ()
  "Пример использования: (test-approximation-appr_table)"
  (let ((points '((0.0 0.0) (1.0 1.0) (2.0 4.0) (4.0 0.0))))
    (pcl:check (= (appr_table -1.0 points) -1.0))
    (pcl:check (= (appr_table 0.0 points) 0.0))
    (pcl:check (= (appr_table 0.5 points) 0.5))
    (pcl:check (= (appr_table 1.0 points) 1.0))
    (pcl:check (= (appr_table 1.5 points) 2.5))
    (pcl:check (= (appr_table 2.0 points) 4.0))
    (pcl:check (= (appr_table 3.0 points) 2.0))
    (pcl:check (= (appr_table 4.0 points) 0.0))
    (pcl:check (= (appr_table 6.0 points) -4.0))))

(pcl:deftest test-approximation-make-linear-interpolation ()
  "Пример использования: (test-approximation-make-linear-interpolation)"
  (let* ((points-01 '((0.0 0.0) (1.0 1.0)))
	 (points-02 '((0.0 0.0) (1.0 1.0) (2.0 4.0)))
	 (func-1 (make-linear-interpolation points-01))
	 (func-2 (make-linear-interpolation points-02 :ff *apr-func-1-3*)))
    (pcl:check (= (funcall func-1 0.0) 0.0))
    (pcl:check (= (funcall func-1 1.0) 1.0))
    (pcl:check (= (funcall func-1 2.0) 2.0))
    (pcl:check (= (funcall func-1 3.0) 3.0))
    (pcl:check (= (funcall func-2 0.0) 0.0))
    (pcl:check (= (funcall func-2 0.5) 0.25))
    (pcl:check (= (funcall func-2 1.0) 1.0))))

(pcl:deftest test-approximation-make-linear-approximation-array ()
  "Пример использования: (test-approximation-make-linear-approximation-array)"
  (let* ((points '((0.0 0.0) (1.0 1.0) (2.0 4.0) (4.0 0.0)))
	 (xx-a1d (make-array 4 :initial-contents (mapcar #'first points)))
	 (yy-a1d (make-array 4 :initial-contents (mapcar #'second points)))
	 (fff (make-linear-approximation-array xx-a1d yy-a1d )))
    (pcl:check (= (funcall (aref  fff 0) 0.0) 0.0))
    (pcl:check (= (funcall (aref  fff 0) 1.0) 1.0))
    (pcl:check (= (funcall (aref  fff 1) 2.0) 4.0))
    (pcl:check (= (funcall (aref  fff 2) 3.0) 2.0))))

(pcl:deftest test-approximation-appr-linear ()
  "Пример использования: (test-approximation-appr-linear)"
  (let* ((points '((0.0 0.0) (1.0 1.0) (2.0 4.0) (4.0 0.0)))
	 (xx-a1d (make-array 4 :initial-contents (mapcar #'first points)))
	 (yy-a1d (make-array 4 :initial-contents (mapcar #'second points)))
	 (a-l (make-instance 'appr-linear :x1 xx-a1d :a1d yy-a1d)))
    (pcl:check (= (approximate 0.0 a-l) 0.0))
    (pcl:check (= (approximate 1.0 a-l) 1.0))
    (pcl:check (= (approximate 2.0 a-l) 4.0))
    (pcl:check (= (approximate 3.0 a-l) 2.0))))

(pcl:deftest test-approximation-appr-bilinear ()
  "Пример использования: (test-approximation-appr-bilinear)"
  (let* ((data-01
	  '((117.0 120.1 118.6 112.5 115.0)
	    (115.0 125.2 119.7 122.4 112.0)
	    (113.0 135.3 129.8 132.3 117.0)
	    (112.0 122.4 124.9 122.2 112.0)
	    (111.0 115.5 119.5 102.1 102.0)))
	 (arr-data-01
	  (make-array '(5 5) :initial-contents data-01))
	 (x1 (vector  -2  -1 0  1  2))
	 (x2 (vector -20 -10 0 10 20))
	 (apr-2 (make-instance 'appr-bilinear :a2d arr-data-01 :x1 x1 :x2 x2)))
    (loop :for xx1 :from -20 :to 20 :by 10 :collect
	 (loop :for xx2 :from -2 :to 2 :collect
	      (approximate (vector xx1 xx2) apr-2)))
    (pcl:check (= (approximate (vector -2 -20) apr-2) 117.0))
    ))
    
    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(pcl:deftest test-approximation ()
 "(test-approximation)"
  (pcl:combine-results
    (test-approximation-appr_table)
    (test-approximation-make-linear-interpolation )
    (test-approximation-make-linear-approximation-array)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;(test-approximation)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(defparameter *apr-1* (make-instance 'appr-linear :x1 (vector 0 1)  :a1d (vector 0 1 )))

(mapcar
 #'(lambda (el)
     (list (* (round el 0.1) 0.1) (* (round (approximate el *apr-1*) 0.01) 0.01)))
 (loop :for i :from -3 :to 3 :by 1/10 :collect i))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Тестирование
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(progn
  (defparameter *test-data-01*
    '((117.0 120.1 118.6 112.5 115.0)
      (115.0 125.2 119.7 122.4 112.0)
      (113.0 135.3 129.8 132.3 117.0)
      (112.0 122.4 124.9 122.2 112.0)
      (111.0 115.5 119.5 102.1 102.0)))
  (defparameter *test-arr-data-01*
    (make-array '(5 5) :initial-contents *test-data-01*)))

(defparameter *apr-2* (make-instance 'appr-bilinear :a2d *test-arr-data-01*  :x2 (vector -2 -1 0 1 2)))

(loop :for h :from -25 :to 25 :collect
     (loop :for x :from -25 :to 25 :collect
	  (approximate (vector (/ h 10.0) (/ x 10.0)) *apr-2*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun gnuplot-2dlist (apr-class s)
  (format s "# x y z")
  (loop :for h :from -25 :to 25 :do
       (progn
	 (loop :for x :from -25 :to 25 :do
	      (let ((x1 (/ h 10.0))
		    (x2  (/ x 10.0)))
		(format s "~% ~F ~F ~F" x1 x2 (approximate (vector x1 x2) apr-class))))
	 (format s "~%"))))

(with-open-file
    (os "d:/PRG/msys32/home/namatv/gp3.data" :direction :output :if-exists :supersede)
  (gnuplot-2dlist *apr-2* os))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun d-i (x xi &key (dx 1.0))
  (let* ((rez (/ (- x xi) dx)))
    (sqrt (* rez rez))))

(defun gauss-w-1d (d) (exp (* -1 d d)))

(defun exp-w-1d (d) (exp (* -1 d)))

(defun cauchy-w-1d (d) (/ 1 (+ 1 (* d d))))

(defun hann-w-1d (d)
  (if (< -1 d 1)
      (* 1/2 ( - 1 ( cos (* 2 pi d))))
      0))

(defun mann-w-1d (d)
  (if (< -1 d 1)
      ( cos (* 1/2 pi d))
      0))

(mann-w-1d 0.99)

(defun spline-1d(x dx arr-2xN &key (w-func #'gauss-w-1d)  )
  (let ((w-summ 0.0)
	(w-z-summ 0.0)
	(w 0.0)
	(z 0.0)
	)
    (loop :for i :from 0 :below  (array-dimension arr-2xN 0) :do
	 (progn
	   (setf w (funcall w-func (d-i x (aref arr-2xN i 0 ) :dx dx))
		 w-summ (+ w-summ w)
		 z (aref arr-2xN i 1)
		 w-z-summ (+ w-z-summ (* w z )))
;;	   (break "z=~A w=~A " z w w-z-summ w-summ )
	   ))
    (/ w-z-summ w-summ)))




(defparameter *arr-2xN* (make-array '(5 2) :initial-contents '((0 0)(1 1)(2 4)(3 9)(4 16))))

(defun gnuplot-list-to-file (lst f-name)
  (with-open-file (os f-name :direction :output :if-exists :supersede )
    (mapc #'(lambda (el) (format os "~{~F ~}~%" el)) lst)))

(let ((dx 1.5))
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN*)))
			"d:/PRG/msys/home/namatv/test.data")
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'exp-w-1d)))
			"d:/PRG/msys/home/namatv/test1.data")

  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'cauchy-w-1d)))
			"d:/PRG/msys/home/namatv/test2.data")

  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'hann-w-1d)))
			"d:/PRG/msys/home/namatv/test3.data")
  
  (gnuplot-list-to-file (loop :for x :from 0 :to 4 :by 1/50 :collect
			     (list x (spline-1d x dx *arr-2xN* :w-func #'mann-w-1d)))
			"d:/PRG/msys/home/namatv/test4.data")

  )


gnuplot
plot "test.data" with lines, "test1.data" with lines, "test2.data" with lines, "test3.data" with lines, "test4.data" with lines;


(/ 1 0.61805)
