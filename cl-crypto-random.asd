;;;; cl-crypto-random.asd
;;;; Cryptographic random bytes
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(asdf:defsystem #:cl-crypto-random
  :description "Cryptographic random byte generation"
  :author "Parkian Company LLC"
  :license "BSD-3-Clause"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:module "src"
                :components ((:file "crypto-random")))))
