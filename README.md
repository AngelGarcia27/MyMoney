# MyMoney

A personal finance app built with SwiftUI featuring loan calculators, budget tracking, and financial education.

## Features

- **Auto Loan Calculator** - Monthly payments, amortization, what-if scenarios
- **Mortgage Calculator** - Includes taxes, amortization graphs, what-if analysis
- **Savings Planner** - Compound interest projections
- **Budget Tracker** - Track income/expenses with visual breakdown (syncs to account)
- **Financial Education** - Lessons with AI-powered Q&A
- **Market Dashboard** - Live rates via FRED API

## Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## Setup

1. Clone the repo
2. Copy config templates:
   ```bash
   cp MyMoney/Config/ClaudeConfig.swift.template MyMoney/Config/ClaudeConfig.swift
   cp MyMoney/Config/SupabaseConfig.swift.template MyMoney/Config/SupabaseConfig.swift
   ```
3. Add your API keys:
   - `ClaudeConfig.swift` - Claude API key (from [Anthropic Console](https://console.anthropic.com))
   - `SupabaseConfig.swift` - Supabase URL and anon key (from [Supabase Dashboard](https://supabase.com) → Project Settings → API)
4. Open `MyMoney.xcodeproj` and run

> **Note:** "Continue as Guest" is available without Supabase or Claude setup. Guest mode provides full calculator functionality but no data persistence or AI features.

## Supabase Setup

For budget persistence, run the SQL in [`MyMoney/Config/supabase-setup.sql`](MyMoney/Config/supabase-setup.sql) in your Supabase Dashboard → SQL Editor.