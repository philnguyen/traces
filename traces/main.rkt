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
  (let ([idx 1])
    (reduction-relation MT
     [--> any any_1
          (computed-name (term any_name))
          (where any_name ,(begin0 idx (set! idx (+ 1 idx))))
          (where {_ ... any_1 _ ...} ,(set->list (f (term any))))])))

(define (hash->reduction h) (function->reduction (λ (x) (hash-ref h x seteq))))
