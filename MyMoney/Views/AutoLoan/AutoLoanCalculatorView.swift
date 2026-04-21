import SwiftUI

struct AutoLoanCalculatorView: View {
    @ObservedObject var model: AutoLoanModel
    @State private var showPaymentBreakdown: Bool = false
    @State private var showingExportSheet = false
    @State private var pdfData: Data?

    private let termOptions: [Int] = [24, 36, 48, 60, 72, 84]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            GroupBox("Inputs") {
                VStack(spacing: 12) {
                    moneyField(title: "Price of Vehicle", value: $model.autoPriceInput)
                    moneyField(title: "Down Payment", value: $model.downPaymentInput)
                    moneyField(title: "Trade-In Value", value: $model.tradeInInput)

                    HStack {
                        Text("Term")
                        Spacer()
                        Picker("Term", selection: $model.termMonthsInput) {
                            ForEach(termOptions, id: \.self) { months in
                                Text("\(months) mo").tag(months)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    percentField(title: "APR", value: $model.aprInput)
                    percentField(title: "Sales Tax", value: $model.salesTaxInput)
                    moneyField(title: "Fees (doc/registration/etc.)", value: $model.feesInput)
                }
            }

            GroupBox("Results") {
                VStack(alignment: .leading, spacing: 10) {

                    DisclosureGroup(isExpanded: $showPaymentBreakdown) {
                        VStack(alignment: .leading, spacing: 8) {

                            breakdownRow(
                                "Sales tax (\(formatPercent(model.salesTaxPercent)) of \(formatCurrency(model.taxableAmount)))",
                                formatCurrency(model.salesTax)
                            )

                            breakdownRow("Fees", formatCurrency(model.fees))
                            breakdownRow("Out-the-door total", formatCurrency(model.outTheDoorTotal))
                            breakdownRow("Down payment", "− " + formatCurrency(model.downPayment))
                            breakdownRow("Trade-in credit", "− " + formatCurrency(model.tradeIn))

                            Divider()

                            breakdownRow("Loan amount (principal)", formatCurrency(model.loanAmount))
                            breakdownRow("APR", formatPercent(model.aprPercent))
                            breakdownRow("Term", "\(model.termMonths) months")

                            Text("Assumes sales tax and fees are financed in the loan.")
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
            
            if model.loanAmount > 0 {
                Button {
                    pdfData = PDFExportService.generateAutoLoanPDF(model: model)
                    showingExportSheet = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Summary")
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.blue)
                    )
                }
            }
        }
        .padding(.top, 8)
        .sheet(isPresented: $showingExportSheet) {
            if let data = pdfData {
                ShareSheet(items: [data])
            }
        }
    }

    private func moneyField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            // have empty input field
            TextField("", text: Binding(
                get: { value.wrappedValue == 0 ? "" : "\(value.wrappedValue)" },
                set: { value.wrappedValue = Double($0) ?? 0 }
            ))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .frame(width: 140)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }

    private func percentField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            // have empty input field
            TextField("", text: Binding(
                get: { value.wrappedValue == 0 ? "" : "\(value.wrappedValue)" },
                set: { value.wrappedValue = Double($0) ?? 0 }
            ))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .frame(width: 140)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
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

struct AutoLoanCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            AutoLoanCalculatorView(model: AutoLoanModel())
                .padding()
        }
    }
}
