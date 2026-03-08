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
