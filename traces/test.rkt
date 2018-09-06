#lang racket/base
(require racket/set
         "main.rkt")

(define (on-new-tag! i x) (printf "~a ↔ ~a~n" i x))

(define f (λ (x) {set (+ 1 x) (+ 2 x)}))
(define h (hash 'a {set 'b 'c}
                'b {set 'a 'c}
                'c {set 'd}))
(function-traces f 1)
(hash-traces h 'a)
(let-values ([(tag untag) (make-int-tagger #:on-new-tag on-new-tag!)])
  (function-traces/tag f 1 tag untag))
(let-values ([(tag untag) (make-int-tagger #:on-new-tag on-new-tag!)])
  (hash-traces/tag h 'a tag untag))
