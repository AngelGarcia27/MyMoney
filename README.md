# MyMoney - Personal Finance Calculator App

A financial planning application built with SwiftUI that has calculators for auto loans, mortgages, and savings goals with real-time market data integration.

## Features

### Financial Calculators
- **Auto Loan Calculator**: Calculate monthly payments, total interest, and compare different loan terms
- **Mortgage Calculator**: Estimate monthly payments including property taxes and insurance
- **Savings Planner**: Plan savings goals with compound interest projections

### Market Dashboard
- Real-time average auto loan rates (via FRED API)
- Current mortgage rates (via FRED API)
- High-yield savings account averages
- S&P 500 market performance

### Financial Education (Coming Soon)
- Short 2-3 minute lessons on financial topics
- Categories: Auto Loans, Mortgages, Savings
- Key takeaways for quick learning

## Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later
- **macOS**: Sonoma 14.0 or later (for development)
- **Swift**: 5.9 or later

## Installation & Setup

### 1. Clone or Download the Project

### 2. Open in Xcode
```bash
open MyMoney.xcodeproj
```

### 3. Select Target Device
- In Xcode, select a simulator or connected device from the scheme selector (top toolbar)
- Recommended: iPhone 16 Pro or later simulator (unless you have an iphone)

### 4. Build and Run
- Click the Play button in Xcode
- The app will compile and launch in the simulator/device

## How to Use

### Auto Loan Calculator
1. Navigate to "Auto Loan Calculator" from the home screen
2. Enter vehicle details:
   - Price of Vehicle
   - Down Payment
   - Trade-In Value (optional)
   - APR (interest rate)
   - Loan Term (select from dropdown)
   - Sales Tax
   - Fees
3. View calculated monthly payment and breakdown
4. Switch to "Graph Analysis" tab to see amortization schedule
5. Use "What If" feature to compare different payment amounts

### Mortgage Calculator
1. Navigate to "Mortgage Calculator"
2. Enter home details:
   - Home Price
   - Down Payment
   - APR
   - Property Tax (as percentage, e.g., 1 = 1%)
   - Loan Term (15, 20, 30, or 50 years)
3. View monthly payment including principal, interest, and taxes
4. Use "Graph Analysis" for amortization visualization
5. Compare different payment scenarios with "What If"

### Savings Planner
1. Navigate to "Saving Planner"
2. Enter savings details:
   - Starting Balance
   - Monthly Contribution
   - Annual Interest Rate
   - Goal Amount
   - Target Date
3. View projected balance and timeline to reach your goal
4. See compound interest growth over time

### Market Dashboard
- View current average rates on the home screen
- Data refreshes when app launches
- Auto Loan and Mortgage rates are live from FRED API
- Savings and S&P 500 data are currently static placeholders