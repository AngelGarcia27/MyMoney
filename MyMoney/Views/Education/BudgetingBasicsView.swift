import SwiftUI

struct BudgetingBasicsView: View {
    @State private var monthlyIncome: String = ""
    @FocusState private var isInputFocused: Bool
    
    private var income: Double {
        Double(monthlyIncome) ?? 0
    }
    
    private var needs: Double {
        income * 0.50
    }
    
    private var wants: Double {
        income * 0.30
    }
    
    private var savings: Double {
        income * 0.20
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("The 50/30/20 Rule")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    BudgetRuleCard(
                        percentage: "50%",
                        title: "Needs",
                        description: "Essential expenses like rent, utilities, groceries, insurance, and minimum debt payments",
                        color: .blue
                    )
                    
                    BudgetRuleCard(
                        percentage: "30%",
                        title: "Wants",
                        description: "Non-essential spending like dining out, entertainment, hobbies, and subscriptions",
                        color: .purple
                    )
                    
                    BudgetRuleCard(
                        percentage: "20%",
                        title: "Savings",
                        description: "Emergency fund, retirement contributions, investments, and extra debt payments",
                        color: .green
                    )
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Try It Yourself")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly After-Tax Income")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text("$")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            
                            TextField("0", text: $monthlyIncome)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .focused($isInputFocused)
                        }
                        .padding()
                        .background(Color.black.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    if income > 0 {
                        VStack(spacing: 12) {
                            BudgetResultCard(
                                title: "Needs",
                                amount: needs,
                                color: .blue
                            )
                            
                            BudgetResultCard(
                                title: "Wants",
                                amount: wants,
                                color: .purple
                            )
                            
                            BudgetResultCard(
                                title: "Savings",
                                amount: savings,
                                color: .green
                            )
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                
                // Quiz section
                VStack(spacing: 16) {
                    Text("Test Your Knowledge")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Take a quick quiz to see how well you understand the 50/30/20 rule")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                        QuizView(
                            title: "Budgeting Quiz",
                            questions: budgetingQuizQuestions
                        )
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Take Quiz")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Budgeting Basics")
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
    
    private var budgetingQuizQuestions: [QuizQuestion] {
        [
            QuizQuestion(
                question: "What percentage of your income should go to needs in the 50/30/20 rule?",
                options: ["30%", "50%", "20%", "40%"],
                correctAnswer: 1,
                explanation: "The 50/30/20 rule suggests allocating 50% of your income to needs like rent, utilities, groceries, and insurance."
            ),
            QuizQuestion(
                question: "Which of these is considered a 'want' rather than a 'need'?",
                options: ["Rent payment", "Streaming subscriptions", "Groceries", "Health insurance"],
                correctAnswer: 1,
                explanation: "Streaming subscriptions are wants - things you enjoy but don't need to survive. Needs are essential expenses like housing, food, and insurance."
            ),
            QuizQuestion(
                question: "What should you do with the 20% savings portion?",
                options: ["Spend it on wants", "Save for emergencies and retirement", "Use it for needs", "Give it away"],
                correctAnswer: 1,
                explanation: "The 20% should go toward savings, emergency funds, debt repayment, and retirement accounts to build your financial future."
            ),
            QuizQuestion(
                question: "If you earn $3,000 per month, how much should go to wants?",
                options: ["$600", "$900", "$1,500", "$1,000"],
                correctAnswer: 1,
                explanation: "30% of $3,000 is $900. This is your budget for dining out, entertainment, hobbies, and other non-essential expenses."
            ),
            QuizQuestion(
                question: "What's the first step if you can't meet the 50/30/20 rule?",
                options: ["Give up on budgeting", "Reduce wants and increase needs", "Reduce needs and wants where possible", "Ignore the rule completely"],
                correctAnswer: 2,
                explanation: "If 50% doesn't cover your needs, look for ways to reduce both needs (cheaper housing, meal planning) and wants to make room for savings."
            )
        ]
    }
}

struct BudgetRuleCard: View {
    let percentage: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(percentage)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
                .frame(width: 70)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BudgetResultCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("$\(amount, specifier: "%.2f")")
                    .font(.title2)
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

#Preview {
    NavigationStack {
        BudgetingBasicsView()
    }
}
