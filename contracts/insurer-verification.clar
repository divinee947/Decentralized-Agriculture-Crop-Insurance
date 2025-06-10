;; Insurer Verification Contract
;; Validates and manages crop insurance providers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_FOUND (err u102))

;; Data structures
(define-map verified-insurers principal bool)
(define-map insurer-details principal {
  name: (string-ascii 50),
  license-number: (string-ascii 20),
  verification-date: uint,
  is-active: bool
})

;; Public functions
(define-public (verify-insurer (insurer principal) (name (string-ascii 50)) (license (string-ascii 20)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? verified-insurers insurer)) ERR_ALREADY_VERIFIED)
    (map-set verified-insurers insurer true)
    (map-set insurer-details insurer {
      name: name,
      license-number: license,
      verification-date: block-height,
      is-active: true
    })
    (ok true)
  )
)

(define-public (revoke-verification (insurer principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-some (map-get? verified-insurers insurer)) ERR_NOT_FOUND)
    (map-set verified-insurers insurer false)
    (ok true)
  )
)

;; Read-only functions
(define-read-only (is-verified-insurer (insurer principal))
  (default-to false (map-get? verified-insurers insurer))
)

(define-read-only (get-insurer-details (insurer principal))
  (map-get? insurer-details insurer)
)
