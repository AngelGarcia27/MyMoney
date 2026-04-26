import SwiftUI
import Charts

// display balance over time chart and summary
struct MortgageAnalysisView: View {
    @ObservedObject var model: MortgageLoanModel
    @State private var whatIfPayment: String = ""
        
    private var whatIfPaymentValue: Double {
        Double(whatIfPayment) ?? 0
    }
    
    private var isWhatIfValid: Bool {
        whatIfPaymentValue > model.monthlyPrincipalAndInterest && model.loanAmount > 0
    }
    
    private var whatIfAmortization: [MortgageWhatIfPoint] {
        guard isWhatIfValid else { return [] }
        
        let P = model.loanAmount
        let r = model.monthlyRate
        let pay = whatIfPaymentValue
        
        var balance = P
        var points: [MortgageWhatIfPoint] = []
        points.append(MortgageWhatIfPoint(month: 0, balance: balance))
        
        var month = 1
        while balance > 0 {
            let interest = (r == 0) ? 0 : balance * r
            var principal = pay - interest
            
            if principal < 0 { principal = 0 }
            if principal > balance { principal = balance }
            
            balance -= principal
            
            points.append(MortgageWhatIfPoint(month: month, balance: max(balance, 0)))
            month += 1
            
            if month > 1000 { break }
        }
        
        return points
    }
    
    private var whatIfTotalInterest: Double {
        guard isWhatIfValid else { return 0 }
        
        let P = model.loanAmount
        let r = model.monthlyRate
        let pay = whatIfPaymentValue
        
        var balance = P
        var interestSum = 0.0
        var month = 0
        
        while balance > 0 && month < 1000 {
            let interest = (r == 0) ? 0 : balance * r
            var principal = pay - interest
            
            if principal < 0 { principal = 0 }
            if principal > balance { principal = balance }
            
            balance -= principal
            interestSum += interest
            month += 1
        }
        
        return interestSum
    }
    
    private var interestSavings: Double {
        model.totalInterest - whatIfTotalInterest
    }
    
    private var monthsSaved: Int {
        guard isWhatIfValid else { return 0 }
        return (model.termYears * 12) - whatIfAmortization.count + 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            GroupBox("Graph") {
                if model.amortization.isEmpty {
                    Text("Enter mortgage details to see the graph.")
                        .foregroundStyle(.secondary)
                } else {
                    Chart {
                        ForEach(model.amortization) { point in
                            LineMark(
                                x: .value("Month", point.month),
                                y: .value("Balance", point.balance),
                                series: .value("Type", "Standard")
                            )
                            .foregroundStyle(by: .value("Type", "Standard"))
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                        
                        if isWhatIfValid {
                            ForEach(whatIfAmortization) { point in
                                LineMark(
                                    x: .value("Month", point.month),
                                    y: .value("Balance", point.balance),
                                    series: .value("Type", "What-If")
                                )
                                .foregroundStyle(by: .value("Type", "What-If"))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartForegroundStyleScale([
                        "Standard": Color.blue,
                        "What-If": Color.green
                    ])
                    .frame(height: 220)

                    HStack {
                        Circle().fill(.blue).frame(width: 8, height: 8)
                        Text("Standard")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if isWhatIfValid {
                            Circle().fill(Color.green).frame(width: 8, height: 8)
                                .padding(.leading, 8)
                            Text("What-If")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            GroupBox("What-If Payment") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Custom Payment")
                        Spacer()
                        TextField("", text: $whatIfPayment)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 120)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    if model.monthlyPrincipalAndInterest > 0 {
                        Text("Minimum P&I: \(formatCurrency(model.monthlyPrincipalAndInterest))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    if isWhatIfValid {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Interest Saved")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(formatCurrency(interestSavings))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            }
                            
                            HStack {
                                Text("Months Saved")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(monthsSaved) months")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            }
                            
                            HStack {
                                Text("New Payoff")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(whatIfAmortization.count - 1) months")
                                    .monospacedDigit()
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
            
            GroupBox("Summary") {
                VStack(alignment: .leading, spacing: 10) {
                    summaryRow("Mortgage Amount", formatCurrency(model.loanAmount))
                    summaryRow("Monthly Payment", formatCurrency(model.monthlyPayment))
                    summaryRow("Total Interest", formatCurrency(model.totalInterest))
                    summaryRow("Total Paid", formatCurrency(model.totalPaid))
                }
            }
        }
        .padding(.top, 8)
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).monospacedDigit()
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

struct MortgageWhatIfPoint: Identifiable {
    let id = UUID()
    let month: Int
    let balance: Double
}

struct MortgageAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MortgageAnalysisView(model: MortgageLoanModel())
                .padding()
        }
    }
}
