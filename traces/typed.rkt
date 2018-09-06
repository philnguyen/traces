#lang typed/racket/base

(require typed/racket/unsafe)

;; TR currently can't generate the required contract.
;; Not sure if I want parametric contracts anyways,
;; as they would mess with equality in hashtables.
(unsafe-require/typed/provide "main.rkt"
  [function-traces (∀ (α) (α → (Setof α)) α → Void)]
  [function-traces/tag (∀ (α) (α → (Setof α)) α (α → Integer) (Integer → α) → Void)]
  [hash-traces (∀ (α) (HashTable α (Setof α)) α → Void)]
  [hash-traces/tag (∀ (α) (HashTable α (Setof α)) α (α → Integer) (Integer → α) → Void)]
  [make-int-tagger (∀ (α) ([] [#:start Integer #:on-new-tag (Integer α → Any)]
                              . ->* . (Values (α → Integer) (Integer → α))))])
