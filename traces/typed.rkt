#lang typed/racket/base

(require typed/racket/unsafe)

(define-type (Bij α β) (Pairof (α → β) (β → α)))

;; Not sure if I want parametric contracts anyways,
;; as they would mess with equality in hashtables.
(unsafe-require/typed/provide "main.rkt"
  [function-traces (∀ (α) (α → (Setof α)) α → Void)]
  [function-traces/tag (∀ (α τ) ([(α → (Setof α)) α]
                                 [(Bij α τ) #:display (α → Any)]
                                 . ->* . Void))]
  [hash-traces (∀ (α) (HashTable α (Setof α)) α → Void)]
  [hash-traces/tag (∀ (α τ) ([(HashTable α (Setof α)) α]
                             [(Bij α τ) #:display (α → Any)]
                             . ->* . Void))]
  [make-int-tagger (∀ (α) → (Values (α → Integer) (Integer → α)))])
