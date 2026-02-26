import SwiftUI
import Charts

// display balance over time chart and summary
struct MortgageAnalysisView: View {
    @ObservedObject var model: MortgageLoanModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            GroupBox("Graph") {
                // no amortization if empty
                if model.amortization.isEmpty {
                    Text("Enter mortgage details to see the graph.")
                        .foregroundStyle(.secondary)
                } else {
                // amorization chart
                    Chart(model.amortization) { point in
                        LineMark(
                            x: .value("Month", point.month),    // x-value month
                            y: .value("Balance", point.balance) // y-value balance
                        )
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 220)

                    Text("Remaining balance over time") // title of chart
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
            // summary for analysis
            // TODO: add a what if function
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

struct MortgageAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MortgageAnalysisView(model: MortgageLoanModel())
                .padding()
        }
    }
}
