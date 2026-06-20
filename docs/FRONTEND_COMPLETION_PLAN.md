# Frontend Completion Plan

This document defines the frontend completion track for Zhirox Debt OS based on the tested Xano backend.

## Backend status

The backend foundation has passed manual testing for authentication, permissions, customer creation, debt, approval, payment, ledger postings, receipts, dashboard summary, daily report, and data quality scan.

## Rule

Do not redesign the database or backend during this frontend stage. The frontend must consume the confirmed API contract and clearly report any API mismatch.

## Stages

### 1. API connectivity

- Confirm all API group base URLs.
- Store the login token locally.
- Send the token to private endpoints.
- Use consistent loading, retry, and error states.

### 2. Core flow

- Login screen.
- Dashboard screen.
- Customer list.
- Customer creation.
- Customer profile / Debt Passport.
- Give debt.
- Receive payment.
- Approval confirmation when credit limit is exceeded.

### 3. Financial protection UX

- Show current balance prominently.
- Show credit limit.
- Show trust score, risk score, risk level, and debt health.
- Show warning when a debt request needs approval.
- Show receipt number after payment.
- Prevent double submission with loading states.

### 4. Reports and control

- Dashboard summary.
- Daily report.
- Receipt detail.
- Data quality scan page.
- Settings and logout.

### 5. Production readiness

- Split the first compact implementation into feature folders.
- Add typed models.
- Add tests.
- Add web platform files.
- Add Android and iOS platform files when needed.
- Prepare web deployment settings.

## Current implementation

The first runnable Flutter foundation is in `lib/main.dart`.

## API configuration

The Auth group base URL is configured in `ApiConfig`. Other API group URLs are derived from the same host and the matching Xano group slug. If any group URL differs, update `ApiConfig`.

## Acceptance checklist

The frontend stage is accepted when the app can: login, show dashboard totals, list customers, open customer profile, create customer, create debt, handle approval, record payment, show daily report, and logout.
