[![Build Status](https://travis-ci.org/philnguyen/traces.svg?branch=master)](https://travis-ci.org/philnguyen/traces) traces
=========================================

This package provides tracing utilities for functions and hash-tables.
It makes use of the `traces` function from `redex/gui` that plots reduction relations.

```racket
function-traces : (∀ (α) (α → (Setof α)) α → Void)
hash-traces     : (∀ (α) (HashTable α (Setof α)) α → Void)
```

### Install

```
raco pkg install traces
```

### Examples

```racket
#lang racket/base
(require racket/set
         traces)
         
(function-traces (λ (x) (set (+ 1 x) (+ 2 x))) 1)
;; A graph should show up

(hash-traces (hash 'a {set 'b 'c}
                   'b {set 'a 'c}
                   'c {set 'd})
             'a)
;; Another graph should show up
```
