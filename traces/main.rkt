#lang racket/base

(require racket/set
         redex/reduction-semantics
         redex/gui)

(provide function-traces
         function-traces/tag
         hash-traces
         hash-traces/tag)

(define (function-traces f e) (traces (function->reduction f) e))
(define (hash-traces     h e) (traces (hash->reduction h)     e))
(define (function-traces/tag f e) (traces/tag f e tag-function function->reduction))
(define (hash-traces/tag     h e) (traces/tag h e tag-hash     hash->reduction    ))

(define-language MT)

(define (function->reduction f)
  (let ([idx 0])
    (reduction-relation MT
     [--> any any_1
          (computed-name (term any_name))
          (where any_name ,(begin (set! idx (+ 1 idx)) idx))
          (where {_ ... any_1 _ ...} ,(set->list (f (term any))))])))

(define (hash->reduction h) (function->reduction (λ (x) (hash-ref h x seteq))))

(define (traces/tag rel val tagger rel->reduction)
  (define-values (rel* tag-val tag->val) (tagger rel))
  (traces (rel->reduction rel*) (tag-val val))
  tag->val)

(define (tag-function f)
  (define val->tag (make-hash))
  (define tag->val (make-hash))
  (define (tag-val x)
    (define i (hash-ref! val->tag x (λ () (hash-count val->tag))))
    (hash-set! tag->val i x)
    i)

  ;; Compute corresponding function
  (define ((tag-function f) tag)
    (for/seteq ([val (in-set (f (hash-ref tag->val tag)))])
      (tag-val val)))

  (values (tag-function f) tag-val tag->val))

(define (tag-hash h)
  (define val->tag (make-hash))
  (define (tag-val x) (hash-ref! val->tag x (λ () (hash-count val->tag))))

  ;; Compute corresponding map
  (define h*
    (for/hasheq ([(k vs) (in-hash h)])
      (values (tag-val k)
              (for/seteq ([v (in-set vs)])
                (tag-val v)))))

  ;; Vector mapping tags to original values
  (define tag->val (make-vector (hash-count val->tag)))
  (for ([(v i) (in-hash val->tag)])
    (vector-set! tag->val i v))
  
  (values h* tag-val tag->val))
