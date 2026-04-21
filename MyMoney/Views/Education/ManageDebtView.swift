import SwiftUI

struct ManageDebtView: View {
    @State private var totalDebt: String = ""
    @State private var monthlyPayment: String = ""
    @State private var interestRate: String = ""
    @State private var selectedStrategy: DebtStrategy = .avalanche
    @FocusState private var isInputFocused: Bool
    
    enum DebtStrategy: String, CaseIterable {
        case avalanche = "Avalanche"
        case snowball = "Snowball"
        
        var description: String {
            switch self {
            case .avalanche:
                return "Pay off highest interest rate first"
            case .snowball:
                return "Pay off smallest balance first"
            }
        }
    }
    
    private var debt: Double {
        Double(totalDebt) ?? 0
    }
    
    private var payment: Double {
        Double(monthlyPayment) ?? 0
    }
    
    private var rate: Double {
        Double(interestRate) ?? 0
    }
    
    private var monthsToPayoff: Int {
        guard debt > 0, payment > 0, rate > 0 else { return 0 }
        
        let monthlyRate = rate / 100 / 12
        let debtTimesRate = debt * monthlyRate
        let paymentMinusDebtRate = payment - debtTimesRate
        let numerator = payment / paymentMinusDebtRate
        let denominator = 1 + monthlyRate
        let months = log(numerator) / log(denominator)
        
        return Int(ceil(months))
    }
    
    private var totalInterestPaid: Double {
        guard debt > 0, payment > 0 else { return 0 }
        return (payment * Double(monthsToPayoff)) - debt
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                introductionSection
                debtTypesSection
                strategiesSection
                calculatorSection
                tipsSection
                quizSection
            }
            .padding()
        }
        .navigationTitle("Manage Debt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
            }
        }
    }
    
    private var introductionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Understanding Debt")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Not all debt is bad, but high-interest debt can prevent you from building wealth. Learn strategies to pay off debt efficiently and avoid common pitfalls.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private var debtTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Types of Debt")
                .font(.title3)
                .fontWeight(.semibold)
            
            DebtTypeCard(
                icon: "creditcard.fill",
                title: "Credit Card Debt",
                description: "High interest (15-25%), should be paid off first",
                priority: "High Priority",
                color: .red
            )
            
            DebtTypeCard(
                icon: "car.fill",
                title: "Auto Loans",
                description: "Medium interest (4-8%), depreciating asset",
                priority: "Medium Priority",
                color: .orange
            )
            
            DebtTypeCard(
                icon: "graduationcap.fill",
                title: "Student Loans",
                description: "Low-medium interest (3-7%), often tax deductible",
                priority: "Medium Priority",
                color: .blue
            )
            
            DebtTypeCard(
                icon: "house.fill",
                title: "Mortgage",
                description: "Low interest (3-6%), appreciating asset",
                priority: "Low Priority",
                color: .green
            )
        }
    }
    
    private var strategiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Debt Payoff Strategies")
                .font(.title3)
                .fontWeight(.semibold)
            
            DebtStrategyCard(
                strategy: .avalanche,
                isSelected: selectedStrategy == .avalanche,
                onTap: { selectedStrategy = .avalanche }
            )
            
            DebtStrategyCard(
                strategy: .snowball,
                isSelected: selectedStrategy == .snowball,
                onTap: { selectedStrategy = .snowball }
            )
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var calculatorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Debt Payoff Calculator")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Calculate how long it will take to pay off your debt.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Debt")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter amount", text: $totalDebt)
                        .keyboardType(.decimalPad)
                        .focused($isInputFocused)
                        .padding()
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Payment")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter amount", text: $monthlyPayment)
                        .keyboardType(.decimalPad)
                        .focused($isInputFocused)
                        .padding()
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Interest Rate (%)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter rate", text: $interestRate)
                        .keyboardType(.decimalPad)
                        .focused($isInputFocused)
                        .padding()
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            if debt > 0 && payment > 0 && monthsToPayoff > 0 {
                VStack(spacing: 12) {
                    DebtResultCard(
                        title: "Time to Payoff",
                        value: "\(monthsToPayoff / 12) years, \(monthsToPayoff % 12) months",
                        color: .orange
                    )
                    
                    DebtResultCard(
                        title: "Total Interest Paid",
                        value: String(format: "$%.2f", totalInterestPaid),
                        color: .red
                    )
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Debt Management Tips")
                .font(.title3)
                .fontWeight(.semibold)
            
            DebtTipCard(
                icon: "dollarsign.circle.fill",
                title: "Pay More Than Minimum",
                description: "Even small extra payments can significantly reduce interest and payoff time"
            )
            
            DebtTipCard(
                icon: "arrow.down.circle.fill",
                title: "Stop Adding New Debt",
                description: "Avoid using credit cards while paying off existing debt"
            )
            
            DebtTipCard(
                icon: "phone.fill",
                title: "Negotiate Lower Rates",
                description: "Call creditors to request lower interest rates or payment plans"
            )
            
            DebtTipCard(
                icon: "arrow.triangle.merge",
                title: "Consider Consolidation",
                description: "Combine multiple debts into one lower-interest loan if it makes sense"
            )
        }
    }
    
    private var quizSection: some View {
        VStack(spacing: 16) {
            Text("Test Your Knowledge")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Take a quick quiz to see how well you understand debt management")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            NavigationLink {
                QuizView(
                    title: "Debt Management Quiz",
                    questions: debtQuizQuestions
                )
            } label: {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Take Quiz")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color.orange.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var debtQuizQuestions: [QuizQuestion] {
        [
            QuizQuestion(
                question: "Which type of debt should you typically pay off first?",
                options: ["Mortgage", "Student loans", "Credit card debt", "Auto loan"],
                correctAnswer: 2,
                explanation: "Credit card debt usually has the highest interest rates (15-25%), so paying it off first saves you the most money in interest."
            ),
            QuizQuestion(
                question: "What is the 'Avalanche Method' of debt repayment?",
                options: ["Pay smallest balance first", "Pay highest interest rate first", "Pay newest debt first", "Pay random debts"],
                correctAnswer: 1,
                explanation: "The Avalanche Method focuses on paying off debts with the highest interest rates first, which saves you the most money over time."
            ),
            QuizQuestion(
                question: "What is the 'Snowball Method' of debt repayment?",
                options: ["Pay highest interest first", "Pay smallest balance first", "Pay largest balance first", "Pay oldest debt first"],
                correctAnswer: 1,
                explanation: "The Snowball Method focuses on paying off the smallest balances first for psychological wins, building momentum as you eliminate debts."
            ),
            QuizQuestion(
                question: "Why should you pay more than the minimum payment on credit cards?",
                options: ["It looks good", "To reduce interest and pay off faster", "Banks require it", "It's the law"],
                correctAnswer: 1,
                explanation: "Paying only the minimum means most of your payment goes to interest, not principal. Paying more reduces total interest and helps you become debt-free faster."
            ),
            QuizQuestion(
                question: "What should you do before taking on new debt?",
                options: ["Nothing, just do it", "Evaluate if you can afford payments", "Max out credit cards", "Ignore your budget"],
                correctAnswer: 1,
                explanation: "Before taking on new debt, ensure you can comfortably afford the payments within your budget without sacrificing essential expenses or savings."
            )
        ]
    }
}

struct DebtTypeCard: View {
    let icon: String
    let title: String
    let description: String
    let priority: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(priority)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.2))
                        .foregroundStyle(color)
                        .clipShape(Capsule())
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DebtStrategyCard: View {
    let strategy: ManageDebtView.DebtStrategy
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: strategy == .avalanche ? "flame.fill" : "snowflake")
                            .foregroundStyle(isSelected ? .orange : .secondary)
                        
                        Text(strategy.rawValue)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    
                    Text(strategy.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.orange)
                        .font(.title3)
                }
            }
            .padding()
            .background(isSelected ? Color.orange.opacity(0.1) : Color.black.opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct DebtResultCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DebtTipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.orange)
                .frame(width: 40, height: 40)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ManageDebtView()
    }
}
