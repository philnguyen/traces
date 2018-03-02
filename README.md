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
#lang typed/racket/base
(require racket/set
         traces)
(function-traces (λ ([x : Integer]) (set (+ 1 x) (+ 2 x))) 1)
;; You should see a graph showing up
```
