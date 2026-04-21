import SwiftUI

struct StartInvestingView: View {
    @State private var initialInvestment: String = ""
    @State private var monthlyContribution: String = ""
    @State private var years: Double = 10
    @State private var returnRate: Double = 7
    @FocusState private var isInputFocused: Bool
    
    private var initial: Double {
        Double(initialInvestment) ?? 0
    }
    
    private var monthly: Double {
        Double(monthlyContribution) ?? 0
    }
    
    private var futureValue: Double {
        let monthlyRate = returnRate / 100 / 12
        let months = years * 12
        
        // Future value of initial investment
        let fvInitial = initial * pow(1 + monthlyRate, months)
        
        // Future value of monthly contributions
        let fvMonthly = monthly * ((pow(1 + monthlyRate, months) - 1) / monthlyRate)
        
        return fvInitial + fvMonthly
    }
    
    private var totalContributed: Double {
        initial + (monthly * years * 12)
    }
    
    private var totalGains: Double {
        futureValue - totalContributed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Introduction
                VStack(alignment: .leading, spacing: 12) {
                    Text("Why Invest?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Investing allows your money to grow over time through compound interest. Starting early, even with small amounts, can lead to significant wealth over the long term.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Investment types
                VStack(alignment: .leading, spacing: 16) {
                    Text("Investment Options")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    InvestmentTypeCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Index Funds",
                        description: "Low-cost funds that track market indexes like S&P 500",
                        risk: "Low-Medium",
                        color: .blue
                    )
                    
                    InvestmentTypeCard(
                        icon: "building.columns.fill",
                        title: "Bonds",
                        description: "Fixed-income securities that pay regular interest",
                        risk: "Low",
                        color: .green
                    )
                    
                    InvestmentTypeCard(
                        icon: "chart.bar.fill",
                        title: "Individual Stocks",
                        description: "Shares of specific companies with higher potential returns",
                        risk: "Medium-High",
                        color: .purple
                    )
                    
                    InvestmentTypeCard(
                        icon: "house.fill",
                        title: "Real Estate",
                        description: "Property investments for rental income and appreciation",
                        risk: "Medium",
                        color: .orange
                    )
                }
                
                // Calculator section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Investment Growth Calculator")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("See how your investments can grow over time with compound interest.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Initial Investment")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter amount", text: $initialInvestment)
                                .keyboardType(.decimalPad)
                                .focused($isInputFocused)
                                .padding()
                                .background(Color.black.opacity(0.04))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Monthly Contribution")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter amount", text: $monthlyContribution)
                                .keyboardType(.decimalPad)
                                .focused($isInputFocused)
                                .padding()
                                .background(Color.black.opacity(0.04))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time Period: \(Int(years)) years")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Slider(value: $years, in: 1...40, step: 1)
                                .tint(.purple)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Expected Return: \(returnRate, specifier: "%.1f")% per year")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Slider(value: $returnRate, in: 1...15, step: 0.5)
                                .tint(.purple)
                        }
                    }
                    
                    if initial > 0 || monthly > 0 {
                        VStack(spacing: 12) {
                            InvestmentResultCard(
                                title: "Future Value",
                                amount: futureValue,
                                color: .purple
                            )
                            
                            HStack(spacing: 12) {
                                InvestmentSmallCard(
                                    title: "Total Invested",
                                    amount: totalContributed,
                                    color: .blue
                                )
                                
                                InvestmentSmallCard(
                                    title: "Total Gains",
                                    amount: totalGains,
                                    color: .green
                                )
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Key principles
                VStack(alignment: .leading, spacing: 16) {
                    Text("Key Investing Principles")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    InvestingPrincipleCard(
                        icon: "clock.fill",
                        title: "Start Early",
                        description: "Time in the market beats timing the market. The earlier you start, the more your money can grow."
                    )
                    
                    InvestingPrincipleCard(
                        icon: "arrow.triangle.branch",
                        title: "Diversify",
                        description: "Don't put all your eggs in one basket. Spread investments across different assets."
                    )
                    
                    InvestingPrincipleCard(
                        icon: "repeat.circle.fill",
                        title: "Stay Consistent",
                        description: "Regular contributions, even small ones, add up significantly over time."
                    )
                    
                    InvestingPrincipleCard(
                        icon: "chart.line.downtrend.xyaxis",
                        title: "Think Long-Term",
                        description: "Don't panic during market downturns. Stay invested for long-term growth."
                    )
                }
                
                // Quiz section
                VStack(spacing: 16) {
                    Text("Test Your Knowledge")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Take a quick quiz to see how well you understand investing basics")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                        QuizView(
                            title: "Investing Quiz",
                            questions: investingQuizQuestions
                        )
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Take Quiz")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Start Investing")
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
    
    private var investingQuizQuestions: [QuizQuestion] {
        [
            QuizQuestion(
                question: "What is the main benefit of starting to invest early?",
                options: ["Higher returns", "Compound interest over time", "Lower taxes", "Less risk"],
                correctAnswer: 1,
                explanation: "Starting early allows compound interest to work in your favor - your earnings generate their own earnings over many years."
            ),
            QuizQuestion(
                question: "What is an index fund?",
                options: ["A single stock", "A fund that tracks a market index", "A savings account", "A type of bond"],
                correctAnswer: 1,
                explanation: "An index fund is a type of investment that tracks a market index like the S&P 500, providing instant diversification at low cost."
            ),
            QuizQuestion(
                question: "What does 'diversification' mean in investing?",
                options: ["Buying only one stock", "Spreading investments across different assets", "Selling everything", "Investing in bonds only"],
                correctAnswer: 1,
                explanation: "Diversification means spreading your investments across different types of assets to reduce risk - don't put all your eggs in one basket."
            ),
            QuizQuestion(
                question: "What should you do during a market downturn?",
                options: ["Sell everything immediately", "Panic and stop investing", "Stay calm and keep investing", "Move all money to cash"],
                correctAnswer: 2,
                explanation: "Market downturns are normal. Staying invested and continuing regular contributions often leads to better long-term results than panic selling."
            ),
            QuizQuestion(
                question: "What is the typical average annual return of the stock market over the long term?",
                options: ["2-3%", "5-6%", "7-10%", "15-20%"],
                correctAnswer: 2,
                explanation: "Historically, the stock market has averaged around 7-10% annual returns over the long term, though individual years can vary significantly."
            )
        ]
    }
}

struct InvestmentTypeCard: View {
    let icon: String
    let title: String
    let description: String
    let risk: String
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
                    
                    Text(risk)
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

struct InvestmentResultCard: View {
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

struct InvestmentSmallCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InvestingPrincipleCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.purple)
                .frame(width: 40, height: 40)
                .background(Color.purple.opacity(0.15))
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
        StartInvestingView()
    }
}
