#lang racket/base

(require racket/set
         redex/reduction-semantics
         redex/gui)

(provide function-traces
         function-traces/tag
         hash-traces
         hash-traces/tag
         make-int-tagger)

(define (function-traces f e) (traces (function->reduction f) e))
(define (hash-traces     h e) (traces (hash->reduction h)     e))
(define (function-traces/tag f e val->tag tag->val)
  (define (f* tag)
    (for/seteq ([val (in-set (f (tag->val tag)))])
      (val->tag val)))
  (function-traces f* (val->tag e)))
(define (hash-traces/tag h e val->tag tag->val)
  (define h*
    (for/hasheq ([(k vs) (in-hash h)])
      (values (val->tag k) (for/seteq ([v (in-set vs)]) (val->tag v)))))
  (hash-traces h* (val->tag e)))

(define-language MT)

(define (function->reduction f)
  (let ([idx 0])
    (reduction-relation MT
     [--> any any_1
          (computed-name (term any_name))
          (where any_name ,(begin (set! idx (+ 1 idx)) idx))
          (where {_ ... any_1 _ ...} ,(set->list (f (term any))))])))

(define (hash->reduction h) (function->reduction (λ (x) (hash-ref h x seteq))))

(define (make-int-tagger #:start [start 0] #:on-new-tag [on-new-tag! (λ (i x) (void))])
  (define cache:val->int (make-hash))
  (define cache:int->val (make-hasheq))
  (define (val->int val)
    (hash-ref! cache:val->int val
               (λ ()
                 (define n (+ start (hash-count cache:val->int)))
                 (hash-set! cache:int->val n val)
                 (on-new-tag! n val)
                 n)))
  (define (int->val i) (hash-ref cache:int->val i (λ () (error 'int->val "nothing for ~a" i))))
  (values val->int int->val))
