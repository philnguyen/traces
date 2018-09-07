#lang racket/base
(require racket/set
         "main.rkt")

(define f (λ (x) {set (+ 1 x) (+ 2 x)}))
(define h (hash 'a {set 'b 'c}
                'b {set 'a 'c}
                'c {set 'd}))
(function-traces f 1)
(hash-traces h 'a)
(function-traces/tag f 1)
(hash-traces/tag h 'a)
