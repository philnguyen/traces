#lang racket/base
(require racket/set
         "main.rkt")

(function-traces (λ (x) {set (+ 1 x) (+ 2 x)}) 1)
(hash-traces (hash 'a {set 'b 'c}
                   'b {set 'a 'c}
                   'c {set 'd})
             'a)
