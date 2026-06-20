# Compile Checklist

Use this checklist after each frontend wiring step.

## Commands

```bash
flutter pub get
flutter analyze
flutter build web --release
```

## What to fix first

1. Missing imports.
2. Wrong constructor parameters.
3. Model field name mismatches.
4. Widget return type errors.
5. API URL or token errors after the build succeeds.

## Current focus

The app now starts through `AppRoot`. The next work is compile cleanup and final wiring for customer profile, debt, payment, and approval flows.
