import SwiftUI

struct EmergencyFundView: View {
    @State private var monthlyExpenses: String = ""
    @State private var selectedMonths: Int = 3
    @FocusState private var isInputFocused: Bool
    
    private var expenses: Double {
        Double(monthlyExpenses) ?? 0
    }
    
    private var emergencyFundGoal: Double {
        expenses * Double(selectedMonths)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Introduction
                VStack(alignment: .leading, spacing: 12) {
                    Text("What is an Emergency Fund?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("An emergency fund is money set aside to cover unexpected expenses like medical bills, car repairs, or job loss. Financial experts recommend saving 3-6 months of living expenses.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Why it matters
                VStack(alignment: .leading, spacing: 16) {
                    Text("Why You Need One")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    EmergencyReasonCard(
                        icon: "cross.case.fill",
                        title: "Medical Emergencies",
                        description: "Unexpected health issues can be expensive",
                        color: .red
                    )
                    
                    EmergencyReasonCard(
                        icon: "car.fill",
                        title: "Vehicle Repairs",
                        description: "Car breakdowns happen when you least expect them",
                        color: .blue
                    )
                    
                    EmergencyReasonCard(
                        icon: "briefcase.fill",
                        title: "Job Loss",
                        description: "Having savings gives you time to find new work",
                        color: .orange
                    )
                    
                    EmergencyReasonCard(
                        icon: "house.fill",
                        title: "Home Repairs",
                        description: "Appliances break and roofs leak",
                        color: .green
                    )
                }
                
                // Calculator section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Calculate Your Goal")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Try it yourself - enter your monthly expenses to see how much you should save.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Expenses")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("Enter amount", text: $monthlyExpenses)
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                            .padding()
                            .background(Color.black.opacity(0.04))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Months of Coverage")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Picker("Months", selection: $selectedMonths) {
                            Text("3 months").tag(3)
                            Text("4 months").tag(4)
                            Text("5 months").tag(5)
                            Text("6 months").tag(6)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    if expenses > 0 {
                        VStack(spacing: 12) {
                            EmergencyResultCard(
                                title: "Your Emergency Fund Goal",
                                amount: emergencyFundGoal,
                                color: .green
                            )
                            
                            Text("This amount will cover \(selectedMonths) months of expenses at $\(expenses, specifier: "%.2f") per month.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding()
                .background(Color.green.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Building tips
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to Build Your Fund")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    BuildingTipCard(
                        number: "1",
                        title: "Start Small",
                        description: "Begin with $500-$1,000 as a starter emergency fund"
                    )
                    
                    BuildingTipCard(
                        number: "2",
                        title: "Automate Savings",
                        description: "Set up automatic transfers to your savings account"
                    )
                    
                    BuildingTipCard(
                        number: "3",
                        title: "Keep It Separate",
                        description: "Use a high-yield savings account you won't touch"
                    )
                    
                    BuildingTipCard(
                        number: "4",
                        title: "Build Gradually",
                        description: "Increase your fund over time as your income grows"
                    )
                }
                
                // Quiz section
                VStack(spacing: 16) {
                    Text("Test Your Knowledge")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Take a quick quiz to see how well you understand emergency funds")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                        QuizView(
                            title: "Emergency Fund Quiz",
                            questions: emergencyFundQuizQuestions
                        )
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Take Quiz")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color.green.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Emergency Fund")
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
    
    private var emergencyFundQuizQuestions: [QuizQuestion] {
        [
            QuizQuestion(
                question: "How many months of expenses should you save in an emergency fund?",
                options: ["1-2 months", "3-6 months", "12 months", "24 months"],
                correctAnswer: 1,
                explanation: "Financial experts recommend saving 3-6 months of living expenses to cover most emergencies without going into debt."
            ),
            QuizQuestion(
                question: "Where should you keep your emergency fund?",
                options: ["Under your mattress", "In stocks", "In a high-yield savings account", "In cryptocurrency"],
                correctAnswer: 2,
                explanation: "A high-yield savings account keeps your money safe, accessible, and earning interest while being separate from your regular spending account."
            ),
            QuizQuestion(
                question: "What is NOT a good reason to use your emergency fund?",
                options: ["Job loss", "Medical emergency", "New TV on sale", "Car repair"],
                correctAnswer: 2,
                explanation: "Emergency funds are for unexpected, necessary expenses - not for wants or planned purchases like a TV on sale."
            ),
            QuizQuestion(
                question: "What should you do first when building an emergency fund?",
                options: ["Save 6 months immediately", "Start with $500-$1,000", "Invest in stocks", "Buy insurance"],
                correctAnswer: 1,
                explanation: "Start with a smaller, achievable goal of $500-$1,000 as a starter emergency fund, then gradually build up to 3-6 months of expenses."
            ),
            QuizQuestion(
                question: "How can you build your emergency fund faster?",
                options: ["Wait for a windfall", "Automate monthly transfers", "Keep it in checking", "Spend less on needs"],
                correctAnswer: 1,
                explanation: "Automating monthly transfers ensures you consistently save without having to think about it, making it easier to build your fund over time."
            )
        ]
    }
}

struct EmergencyReasonCard: View {
    let icon: String
    let title: String
    let description: String
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
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
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

struct EmergencyResultCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BuildingTipCard: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.green)
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
        EmergencyFundView()
    }
}
