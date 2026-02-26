import SwiftUI

struct MortgageLoanCalculatorView: View {
    @ObservedObject var model: MortgageLoanModel
    @State private var showPaymentBreakdown: Bool = false

    private let termOptions: [Int] = [15, 20, 30, 50]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            GroupBox("Inputs") {
                VStack(spacing: 12) {
                    moneyField(title: "Home Price", value: $model.homePriceInput)
                    moneyField(title: "Down Payment", value: $model.downPaymentInput)
                    HStack {
                        Text("Term")
                        Spacer()
                        Picker("Term", selection: $model.termYearsInput) {
                            ForEach(termOptions, id: \.self) { years in
                                Text("\(years) years").tag(years)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    percentField(title: "APR", value: $model.aprInput)
                    moneyField(title: "Annual Property Tax", value: $model.propertyTaxInput)
                    moneyField(title: "Closing Costs", value: $model.closingCostsInput)
                }
            }

            GroupBox("Results") {
                VStack(alignment: .leading, spacing: 10) {

                    DisclosureGroup(isExpanded: $showPaymentBreakdown) {
                        VStack(alignment: .leading, spacing: 8) {

                            breakdownRow("Principal & Interest", formatCurrency(model.monthlyPrincipalAndInterest))
                            breakdownRow("Property Tax", formatCurrency(model.monthlyPropertyTax))

                            Divider()

                            breakdownRow("Home Price", formatCurrency(model.homePrice))
                            breakdownRow("Down Payment", "− " + formatCurrency(model.downPayment))
                            breakdownRow("Loan Amount", formatCurrency(model.loanAmount))
                            breakdownRow("APR", formatPercent(model.aprPercent))
                            breakdownRow("Term", "\(model.termYears) years")

                            Text("Monthly payment includes principal, interest, and property tax.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                        .padding(.top, 8)
                    } label: {
                        HStack {
                            Text("Estimated Monthly")
                                .font(.headline)
                            Spacer()
                            Text(formatCurrency(model.monthlyPayment))
                                .font(.headline)
                                .monospacedDigit()
                        }
                    }
                    .animation(.easeInOut, value: showPaymentBreakdown)

                    Divider()

                    resultRow("Loan Amount", formatCurrency(model.loanAmount))
                    resultRow("Total Interest", formatCurrency(model.totalInterest))
                    resultRow("Total Paid", formatCurrency(model.totalPaid))
                }
            }

            if model.loanAmount <= 0 {
                Text("Loan Amount $0, No Monthly Payment")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 8)
    }

    private func moneyField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0", value: value, format: .number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .frame(width: 140)
        }
    }

    private func percentField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0", value: value, format: .number)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .frame(width: 140)
        }
    }

    private func resultRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .monospacedDigit()
        }
    }

    private func breakdownRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .monospacedDigit()
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func formatPercent(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        let num = formatter.string(from: NSNumber(value: value)) ?? "0"
        return "\(num)%"
    }
}

struct MortgageLoanCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MortgageLoanCalculatorView(model: MortgageLoanModel())
                .padding()
        }
    }
}
