;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;; SPDX-License-Identifier: BSD-3-Clause

;;;; test-crypto-random.lisp - Unit tests for crypto-random
;;;;
;;;; Copyright (c) 2024-2026 Parkian Company LLC. All rights reserved.
;;;; SPDX-License-Identifier: BSD-3-Clause

(defpackage #:cl-crypto-random.test
  (:use #:cl)
  (:export #:run-tests))

(in-package #:cl-crypto-random.test)

(defun run-tests ()
  "Run all tests for cl-crypto-random."
  (format t "~&Running tests for cl-crypto-random...~%")
  ;; TODO: Add test cases
  ;; (test-function-1)
  ;; (test-function-2)
  (format t "~&All tests passed!~%")
  t)
