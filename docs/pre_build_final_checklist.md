# Zhirox AI Debt — Pre-Build Final Checklist

ئەم فایلە چێکلیستی کۆتاییە بۆ قۆناغی پێش build. مەبەست ئەوەیە database، backend، API contract، frontend integration، deploy config و manual smoke test پێش build یەکجار تەواو بپشکنرێن.

## 1. Database / Xano

Status: LOCKED

- [x] Tables دروست کراون و locked ـن.
- [x] Core financial source of truth: ledger entries.
- [x] Customer profile balances لە ledger/recalculation دەخوێنرێنەوە.
- [x] Receipts table و verify token هەیە.
- [x] Approval requests هەیە بۆ credit-limit و sensitive actions.
- [x] Data quality tables/functions هەیە بۆ balance/profile/receipt fixes.
- [x] Settings/license/permissions tables هەیە.
- [x] Audit logs بۆ کردارە هەستیارەکان هەیە.

Do not change database schema unless a real frontend/API test proves a backend defect.

## 2. Backend / API Contract

Status: LOCKED

Base instance:

```text
https://x8ki-letl-twmt.n7.xano.io
```

API groups expected by Flutter:

```text
zhirox-auth
zhirox-customers
zhirox-dashboard
zhirox-reports
zhirox-data-quality
zhirox-approvals
zhirox-financial-events
zhirox-receipts
zhirox-settings
zhirox-whatsapp
zhirox-exports
```

Required backend areas:

- [x] Auth: login, me.
- [x] Customers: list/profile/statement/duplicates/merge.
- [x] Financial events: give debt, receive payment, customer ledger.
- [x] Approvals: approve/reject.
- [x] Dashboard summary.
- [x] Reports: daily, weekly, monthly, top debtors, paid/unpaid, approval, cash movement, employee activity, branch summary.
- [x] Receipts: verify, by customer.
- [x] Data quality: scan, fix balance, fix missing profile, fix receipt link.
- [x] Settings: market settings, permissions, license status.
- [x] WhatsApp drafts: payment reminder, receipt message, customer statement, manager broadcast.
- [x] Exports: customers, ledger, reports, audit logs, customer statement, receipts.

## 3. Flutter Frontend Integration

Status: INTEGRATED

Connected areas:

- [x] API endpoints mapped to Xano groups.
- [x] ApiClient sends JSON and Authorization Bearer token.
- [x] ApiClient has request timeout.
- [x] Auth token is validated with /me before entering home.
- [x] Login clears invalid token on failure.
- [x] Dashboard connected.
- [x] Customers list connected.
- [x] Customer profile connected.
- [x] Customer statement/ledger shown in profile.
- [x] Give debt connected.
- [x] Receive payment connected.
- [x] Approval/reject connected.
- [x] Reports overview connected.
- [x] Data quality scan and repairs connected.
- [x] Settings/license/permissions connected.
- [x] Receipt verification connected.
- [x] Receipts by customer connected.
- [x] WhatsApp drafts connected.
- [x] Export actions connected.
- [x] Manager broadcast draft connected.
- [x] Kurdish RTL direction enabled.

## 4. Deploy / Web Readiness

Status: READY FOR TEST BUILD

- [x] web/index.html exists and is RTL/ckb-ready.
- [x] Netlify publish path is build/web.
- [x] Netlify has SPA redirect to /index.html.
- [x] Netlify build script installs Flutter if missing.
- [x] GitHub Actions Flutter workflow exists.
- [x] flutter config --enable-web included in build flow.

## 5. Manual Smoke Test Before Final Build

Run this test order before final production build:

1. Login with real Xano admin account.
2. Confirm /me succeeds and app opens home.
3. Open dashboard and confirm totals load.
4. Open customers list and confirm real customers load.
5. Open one customer profile.
6. Confirm current balance, risk, debt health, credit limit show correctly.
7. Add small debt under credit limit.
8. Confirm ledger updates and balance increases.
9. Receive partial payment.
10. Confirm ledger updates and balance decreases.
11. Add debt above credit limit.
12. Confirm approval request appears.
13. Approve it and confirm ledger/balance update.
14. Open reports and confirm daily/weekly/monthly data loads.
15. Run data quality scan and confirm issues count.
16. Test receipt verify token if a token exists.
17. Generate WhatsApp payment reminder draft.
18. Generate customer statement draft.
19. Generate export customers/ledger/reports/receipts.
20. Logout and login again.

## 6. Build Gate

The project is ready to attempt build when all of the following are true:

- [ ] Manual smoke test completed on browser.
- [ ] No red API errors in app UI.
- [ ] Netlify build starts from latest main branch.
- [ ] Flutter analyze passes or only non-blocking infos remain.
- [ ] Flutter web build creates build/web.

## 7. Rule After This Point

No more database/backend changes unless a real failed test shows a backend problem.

Frontend changes after this point should only be:

- compile fixes,
- UI polish,
- parsing fixes,
- endpoint parameter fixes,
- build/deploy fixes.
