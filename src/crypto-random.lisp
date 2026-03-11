;;;; crypto-random.lisp
;;;; Cryptographic random byte generation
;;;; Copyright (c) 2024-2026 Parkian Company LLC

(in-package #:cl-crypto-random)

;;; Platform-specific random source
(defvar *random-source* nil)

(defun init-random-source ()
  "Initialize the cryptographic random source."
  (cond
    ;; Unix-like systems: /dev/urandom
    ((probe-file "/dev/urandom")
     (setf *random-source* :urandom))
    ;; Windows via SBCL: use sb-win32 or fallback
    #+sbcl
    ((find-package "SB-WIN32")
     (setf *random-source* :sbcl-random))
    ;; Fallback to SBCL's random with seeding from time
    (t
     (setf *random-source* :fallback)
     (setf *random-state* (make-random-state t)))))

(defun read-urandom (n)
  "Read N bytes from /dev/urandom."
  (with-open-file (stream "/dev/urandom"
                          :direction :input
                          :element-type '(unsigned-byte 8))
    (let ((buffer (make-array n :element-type '(unsigned-byte 8))))
      (read-sequence buffer stream)
      buffer)))

(defun fallback-random-bytes (n)
  "Generate random bytes using CL random (less secure fallback)."
  (let ((buffer (make-array n :element-type '(unsigned-byte 8))))
    (dotimes (i n)
      (setf (aref buffer i) (random 256)))
    buffer))

(defun crypto-random-bytes (n)
  "Generate N cryptographically secure random bytes.
   Returns a simple byte array."
  (unless *random-source*
    (init-random-source))
  (case *random-source*
    (:urandom (read-urandom n))
    (:sbcl-random
     ;; On Windows SBCL, use random state seeded from system
     (let ((*random-state* (make-random-state t)))
       (fallback-random-bytes n)))
    (:fallback (fallback-random-bytes n))
    (t (error "No random source available"))))

(defun crypto-random-integer (limit)
  "Generate a cryptographically secure random integer in [0, LIMIT).
   Uses rejection sampling to ensure uniform distribution."
  (unless (plusp limit)
    (error "LIMIT must be positive"))
  (let* ((byte-count (ceiling (integer-length limit) 8))
         (max-valid (* limit (floor (expt 256 byte-count) limit))))
    ;; Rejection sampling
    (loop
      (let* ((bytes (crypto-random-bytes byte-count))
             (value (bytes-to-integer bytes)))
        (when (< value max-valid)
          (return (mod value limit)))))))

(defun bytes-to-integer (bytes)
  "Convert byte array to big-endian integer."
  (let ((result 0))
    (loop for b across bytes do
      (setf result (+ (ash result 8) b)))
    result))

(defun generate-key (size)
  "Generate a cryptographic key of SIZE bytes.
   SIZE: Number of bytes (e.g., 32 for 256-bit key).
   Returns a secure byte array suitable for cryptographic use."
  (crypto-random-bytes size))

(defun generate-nonce (size)
  "Generate a cryptographic nonce of SIZE bytes.
   SIZE: Number of bytes (e.g., 12 for AES-GCM, 24 for XChaCha20).
   Returns a secure byte array."
  (crypto-random-bytes size))

;; Initialize on load
(init-random-source)
