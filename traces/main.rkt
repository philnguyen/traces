#lang racket/base

(require racket/set
         redex/reduction-semantics
         redex/gui)

(provide function-traces
         hash-traces)

(define (function-traces f e) (traces (function->reduction f) e))
(define (hash-traces     h e) (traces (hash->reduction h)     e))

(define-language MT)

(define (function->reduction f)
  (reduction-relation MT
   [--> any any_1
        (where {_ ... any_1 _ ...} ,(set->list (f (term any))))]))

(define (hash->reduction h)
  (reduction-relation MT
   [--> any any_1
        (where {_ ... any_1 _ ...} ,(set->list (hash-ref h (term any) seteq)))]))
