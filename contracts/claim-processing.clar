;; Claim Processing Contract
;; Processes crop insurance claims

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_CLAIM_EXISTS (err u401))
(define-constant ERR_CLAIM_NOT_FOUND (err u402))
(define-constant ERR_INVALID_POLICY (err u403))
(define-constant ERR_CLAIM_ALREADY_PROCESSED (err u404))

;; Claim status: 1 = Pending, 2 = Approved, 3 = Rejected, 4 = Paid
(define-map claims uint {
  policy-id: uint,
  farmer: principal,
  claim-amount: uint,
  damage-percentage: uint,
  evidence-hash: (string-ascii 64),
  submission-block: uint,
  status: uint,
  assessor: (optional principal),
  payout-amount: uint
})

(define-map authorized-assessors principal bool)
(define-data-var next-claim-id uint u1)

;; Public functions
(define-public (submit-claim
  (policy-id uint)
  (claim-amount uint)
  (damage-percentage uint)
  (evidence-hash (string-ascii 64)))
  (let ((claim-id (var-get next-claim-id)))
    ;; In a real implementation, verify policy exists and is active
    (map-set claims claim-id {
      policy-id: policy-id,
      farmer: tx-sender,
      claim-amount: claim-amount,
      damage-percentage: damage-percentage,
      evidence-hash: evidence-hash,
      submission-block: block-height,
      status: u1,
      assessor: none,
      payout-amount: u0
    })
    (var-set next-claim-id (+ claim-id u1))
    (ok claim-id)
  )
)

(define-public (assess-claim (claim-id uint) (approved bool) (payout-amount uint))
  (match (map-get? claims claim-id)
    claim-data
    (begin
      (asserts! (default-to false (map-get? authorized-assessors tx-sender)) ERR_UNAUTHORIZED)
      (asserts! (is-eq (get status claim-data) u1) ERR_CLAIM_ALREADY_PROCESSED)
      (map-set claims claim-id (merge claim-data {
        status: (if approved u2 u3),
        assessor: (some tx-sender),
        payout-amount: (if approved payout-amount u0)
      }))
      (ok true)
    )
    ERR_CLAIM_NOT_FOUND
  )
)

(define-public (process-payout (claim-id uint))
  (match (map-get? claims claim-id)
    claim-data
    (begin
      (asserts! (is-eq (get status claim-data) u2) ERR_UNAUTHORIZED)
      ;; In a real implementation, transfer STX to farmer
      (map-set claims claim-id (merge claim-data {status: u4}))
      (ok (get payout-amount claim-data))
    )
    ERR_CLAIM_NOT_FOUND
  )
)

(define-public (authorize-assessor (assessor principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_UNAUTHORIZED)
    (map-set authorized-assessors assessor true)
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-claim (claim-id uint))
  (map-get? claims claim-id)
)

(define-read-only (get-claim-status (claim-id uint))
  (match (get-claim claim-id)
    claim-data (get status claim-data)
    u0
  )
)

;; Private variables
(define-data-var contract-owner principal tx-sender)
