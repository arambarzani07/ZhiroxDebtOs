# Zhirox Debt OS

Kurdish RTL Flutter frontend foundation for **Zhirox Debt Intelligence OS**.

This frontend is designed for the tested Xano backend/database flow:

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

## Backend API configuration

The app starts from the Auth API base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-auth
```

Other API group URLs are derived in `lib/main.dart` by replacing `zhirox-auth` with the matching group slug:

```text
zhirox-customers
zhirox-financial-events
zhirox-approvals
zhirox-dashboard
zhirox-reports
zhirox-receipts
zhirox-data-quality
```

If any Xano group has a different base URL, update `ApiConfig` in `lib/main.dart`.

## Main endpoints used

```text
POST /login
GET  /me
GET  /list
GET  /id
POST /create
POST /debt
POST /payment
POST /approve
GET  /summary
GET  /daily
POST /scan
```

Because Xano uses separate API groups, each path is called against its own base URL.

## Run locally

```bash
flutter pub get
flutter run
```

Default test login shown in the UI:

```text
admin@zhirox.os
123123123
```

## Current status

This is the first frontend foundation. It contains a single-file Flutter implementation in `lib/main.dart` to make the repo easy to run and test quickly. Later it should be refactored into feature folders after the API paths are fully confirmed from Xano.
