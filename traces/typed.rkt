#lang typed/racket/base

(require typed/racket/unsafe)

;; TR currently can't generate the required contract.
;; Not sure if I want parametric contracts anyways,
;; as they would mess with equality in hashtables.
(unsafe-require/typed/provide "main.rkt"
  [function-traces (∀ (α) (α → (Setof α)) α → Void)]
  [hash-traces (∀ (α) (HashTable α (Setof α)) α → Void)])