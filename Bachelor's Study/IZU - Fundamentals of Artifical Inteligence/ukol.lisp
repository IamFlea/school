(defun iner(a) (+ a 1))

(defun trol(d) 
	(car 
    (cdr d)
  )

)

(defun faktorial(d)
  (if (= d 0) 1
    (* 
	  	d 
      (faktorial (- d 1))
    )
  )
)

; fibonacci
; fib(0) = 0
; fib(1) = 1
; fib(n) = fib(n - 1) + fib(n - 2)
(defun fib (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        ((< n 0) NIL)
        (T (+ (fib (- n 1)) (fib (- n 2)))))
)

; ackrman
; m >= 0, n >= 0
; ack(0, n) = n+1
; ack(m, 0) = ack(m-1, 1)
; ack(m, n) = ack(m-1, ack(m, n-1))

(defun ack (m n)
  (cond ((> 0 n) NIL)
        ((> 0 m) NIL)
        ((= 0 m) (+ n 1))
        ((= 0 n) (ack (- m 1) 1))
        (T       (ack (- m 1) (ack m (- n 1))))
  )
)




; spojeni seznamu
(defun spoj(L1 L2)
  (cond ((NULL L1) L2)
        (T (cons (car L1) (spoj (cdr L1) L2)))
  )
)

; Obraceni obecneho seznamu
; obratOb(list)
(defun obratOb(LIST)
  T
)

; test zda je prvek obsazen v obecnem seznamu jePrvekOb(seznam, prvek)
;jePrvekOb
(defun jePrvekOb(LIST ITEM)
  (cond ((NULL L) nil)
        ((atom L) (= L A))
        (T (or (jePrvekOb (car L) A) (jePrvekOb(cdr L) A)))
  )
)
;prumer prvku obecneho seznamu prumerPrvkuOb(seznam)
;prumerPrvkuOb

(defun prunik(L1 L2)
	(cond
    ((null L1) nil)
    ((member (car L1) L2) (cons (car L1) (prunik (cdr L1) L2)))
    (T (prunik (cdr L1) L2))
  )
)

(defun prunikTri(L1 L2 L3)
  (prunik (prunik L1 L2) L3)
)

;soucet prvku obecneho seznamu soucetPrvkuOb(seznam)
;soucetPrvkuOb

;overeni monotonnosit linearniho seznamu
;monotnnostLin
