# cl-crypto-random

Cryptographic random byte generation for Common Lisp.

## Features

- Platform-aware random source selection
- Uses /dev/urandom on Unix-like systems
- Uniform distribution via rejection sampling
- Convenience functions for keys and nonces
- Zero external dependencies

## Installation

```lisp
(asdf:load-system :cl-crypto-random)
```

## Usage

```lisp
(use-package :cl-crypto-random)

;; Generate random bytes
(crypto-random-bytes 32)  ; 32 random bytes

;; Generate random integer in range
(crypto-random-integer 1000000)  ; [0, 999999]

;; Generate cryptographic key
(generate-key 32)   ; 256-bit key
(generate-key 16)   ; 128-bit key

;; Generate nonce
(generate-nonce 12)  ; 96-bit nonce (AES-GCM)
(generate-nonce 24)  ; 192-bit nonce (XChaCha20)
```

## API

- `crypto-random-bytes n` - Generate N random bytes
- `crypto-random-integer limit` - Random integer in [0, limit)
- `generate-key size` - Generate cryptographic key
- `generate-nonce size` - Generate cryptographic nonce

## Platform Support

- **Unix/Linux/macOS**: Uses /dev/urandom
- **Windows**: Falls back to SBCL random state (seeded from system)
- **Other**: CL random with time-based seeding (less secure)

## Security Notes

- Always prefer /dev/urandom platforms for cryptographic use
- The fallback random source may not be cryptographically secure
- For production use on Windows, consider native crypto API integration

## License

BSD-3-Clause. Copyright (c) 2024-2026 Parkian Company LLC
