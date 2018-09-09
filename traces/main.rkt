#lang racket/base

(require racket/set
         racket/match
         (only-in racket/pretty pretty-format)
         redex/reduction-semantics
         redex/gui
         racket/gui/base
         (only-in racket/class new send)
         (only-in racket/port with-input-from-string))

(provide function-traces
         function-traces/tag
         hash-traces
         hash-traces/tag
         make-int-tagger)

(define (function-traces f e) (traces (function->reduction f) e))
(define (hash-traces     h e) (function-traces (hash->function h) e))
(define (function-traces/tag f e [tagger (call-with-values make-int-tagger cons)])
  (match-define (cons val->tag tag->val) tagger)
  (define (f* tag) (for/seteq ([val (in-set (f (tag->val tag)))])
                     (val->tag val)))
  (function-traces f* (val->tag e))
  (thread (λ () (show-lookup-window tag->val))))
(define (hash-traces/tag h e [tagger (call-with-values make-int-tagger cons)])
  (function-traces/tag (hash->function h) e tagger))

(define-language MT)

(define ((hash->function h) x) (hash-ref h x seteq))

(define (function->reduction f)
  (let ([idx 0])
    (reduction-relation MT
     [--> any any_1
          (computed-name (term any_name))
          (where any_name ,(begin (set! idx (+ 1 idx)) idx))
          (where {_ ... any_1 _ ...} ,(set->list (f (term any))))])))

(define (make-int-tagger)
  (define cache:val->int (make-hash))
  (define cache:int->val (make-hasheq))
  (define (val->int val)
    (hash-ref! cache:val->int val
               (λ ()
                 (define n (hash-count cache:val->int))
                 (hash-set! cache:int->val n val)
                 n)))
  (define (int->val i) (hash-ref cache:int->val i (λ () (error 'int->val "nothing for ~a" i))))
  (values val->int int->val))

(define (show-lookup-window tag->val)
  (define max-width 100)
  (define frame (new frame%
                     [label "Tag Lookup"]
                     [width 640]
                     [height 480]))
  (define main-panel (new vertical-panel% [parent frame]))
  (define lookup-panel (new horizontal-panel%
                            [parent main-panel]
                            [stretchable-height #f]))
  (define input (new text-field%
                     [parent lookup-panel]
                     [label "Tag"]
                     [callback
                      (λ (_ e)
                        (case (send e get-event-type)
                          [(text-field-enter) (on-lookup)]))]))
  (define width-slider (new slider%
                            [parent lookup-panel]
                            [label "Column width"]
                            [min-value 40]
                            [max-value 200]
                            [init-value max-width]
                            [callback (λ _
                                        (set! max-width (send width-slider get-value))
                                        (on-lookup))]))
  (define content (new text-field%
                       [parent main-panel]
                       [label #f]
                       [style '(multiple)]))
  (define (on-lookup)
    (define tag (with-input-from-string (send input get-value) read))
    (match (with-handlers ([exn? (λ _ #f)])
             (list (tag->val tag)))
      [(list val)
       (send content set-value (pretty-format val max-width))]
      [#f (send content set-value (format "(nothing for ~a)" tag))]))
  (send frame show #t))
