# Zhirox Debt OS

Kurdish RTL Flutter frontend foundation for **Zhirox Debt Intelligence OS**.

## Work rule

All frontend work is done directly on the `main` branch. No extra branch is used for this project unless the owner explicitly changes this rule.

## Current frontend stage

The project is now in the frontend completion stage based on the tested Xano database and backend. The backend/database should not be redesigned during this stage.

## Tested backend flow

- Auth/Login
- Manager permissions
- Customer create/list/profile
- Debt request with approval when credit limit is exceeded
- Payment received
- Ledger debit/credit consistency
- Receipts
- Dashboard summary
- Daily report
- Data quality scan

## Run locally

```bash
flutter pub get
flutter create . --platforms=web
flutter run -d chrome
```

## Build for web

```bash
flutter create . --platforms=web
flutter pub get
flutter build web --release
```

## Frontend acceptance checklist

- Login works
- Dashboard totals load
- Customer list loads
- Customer profile opens
- Customer creation works
- Debt creation works
- Approval flow works
- Payment works
- Daily report loads
- Data quality scan passes
- Logout clears the session
