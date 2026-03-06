import SwiftUI

struct SavingsCalculatorView: View {
    @ObservedObject var model: SavingPlannerModel
    @State private var startDate: Date = .now

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            GroupBox("Inputs") {
                VStack(spacing: 16) {

                    moneyField(title: "Starting Balance", value: $model.startingBalance)
                    moneyField(title: "Monthly Contribution", value: $model.monthlyContribution)
                    percentField(title: "APY", value: $model.annualInterestRate)
                    moneyField(title: "Goal Amount", value: $model.goalAmount)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }
            }

            GroupBox("Results") {
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        Text("Months to Goal")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(monthsText(model.monthsToGoal))
                            .font(.title3)
                            .fontWeight(.bold)
                            .monospacedDigit()
                    }
                    .padding(.vertical, 4)
                    
                    if let goalDateText = goalDateText(monthsToGoal: model.monthsToGoal) {
                        resultRow("Goal Date", goalDateText)
                        Divider()
                            .padding(.vertical, 2)
                    }

                    let endBalance = model.projectionToGoal.last?.balance ?? 0
                    let endInterest = model.projectionToGoal.last?.interestEarnedToDate ?? 0
                    let endContrib = model.projectionToGoal.last?.contributionsToDate ?? 0

                    resultRow("Total Contributed", formatCurrency(endContrib))
                    Divider()
                        .padding(.vertical, 2)
                    resultRow("Interest Earned", formatCurrency(endInterest))
                    Divider()
                        .padding(.vertical, 2)
                    resultRow("Final Balance", formatCurrency(endBalance))
                }
            }

            
            footerHint

        }
        .padding(.top, 8)
    }

    private var footerHint: some View {
        Group {
            if model.goal == 0 {
                Text("Set a Goal Amount to calculate time-to-goal.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else if model.contribution == 0 && model.monthlyRate == 0 {
                Text("With $0/month and 0% APY, you won’t reach the goal.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else if model.monthsToGoal == Int.max {
                Text("Goal not reached within 100 years with current inputs.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func moneyField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
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

    private func goalDateText(monthsToGoal: Int) -> String? {
        guard monthsToGoal != Int.max, monthsToGoal > 0 else { return nil }
        guard let goalDate = Calendar.current.date(byAdding: .month, value: monthsToGoal, to: startDate) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: goalDate)
    }

    private func monthsText(_ months: Int) -> String {
        if months == Int.max { return "—" }
        if months == 0 { return "0 months" }

        let years = months / 12
        let remMonths = months % 12

        if years > 0 && remMonths > 0 {
            return "\(years)y \(remMonths)m"
        } else if years > 0 {
            return "\(years)y"
        } else {
            return "\(remMonths)m"
        }
    }
}

struct SavingsCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            SavingsCalculatorView(model: SavingPlannerModel())
                .padding()
        }
    }
}
