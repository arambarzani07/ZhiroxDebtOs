# Frontend Completion Plan

This document defines the frontend completion track for Zhirox Debt OS based on the tested Xano backend.

## Backend status

The backend foundation has passed manual testing for authentication, permissions, customer creation, debt, approval, payment, ledger postings, receipts, dashboard summary, daily report, and data quality scan.

## Main branch rule

All frontend changes are applied directly to `main`. No additional branches are used unless the owner explicitly changes this rule.

## Current stage

The current stage is API layer separation and UI completion. Existing backend and database logic should not be changed in this stage.

## Stage 1 - API connectivity

- Confirm all API group base URLs.
- Store the login token locally.
- Send the token to private endpoints.
- Use consistent loading, retry, and error states.
- Keep API communication inside reusable service classes.

## Stage 2 - Core flow

- Login screen.
- Dashboard screen.
- Customer list.
- Customer creation.
- Customer profile / Debt Passport.
- Give debt.
- Receive payment.
- Approval confirmation when credit limit is exceeded.

## Stage 3 - Financial protection UX

- Show current balance prominently.
- Show credit limit.
- Show trust score, risk score, risk level, and debt health.
- Show warning when a debt request needs approval.
- Show receipt number after payment.
- Prevent double submission with loading states.

## Stage 4 - Reports and control

- Dashboard summary.
- Daily report.
- Receipt detail.
- Data quality scan page.
- Settings and logout.

## Stage 5 - Production readiness

- Split the compact implementation into feature folders.
- Add typed response models.
- Add tests.
- Prepare web build configuration.
- Confirm deployment on Netlify or Cloudflare.

## Acceptance checklist

The frontend stage is accepted when the app can log in, show dashboard totals, list customers, open a customer profile, create a customer, create debt, handle approval, record payment, show daily report, run data quality scan, and log out.
