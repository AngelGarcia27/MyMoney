import SwiftUI

struct HomeView: View {
    @StateObject private var marketData = MarketDataViewModel()
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(greeting)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Market Overview")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                DashboardCard(
                                    title: "Avg Auto Loan",
                                    value: marketData.autoLoanRate,
                                    subtitle: "60-month new car",
                                    icon: "car.fill",
                                    color: .blue,
                                    trendData: [
                                        TrendPoint(index: 0, value: 6.8),
                                        TrendPoint(index: 1, value: 7.0),
                                        TrendPoint(index: 2, value: 7.1),
                                        TrendPoint(index: 3, value: 7.3),
                                        TrendPoint(index: 4, value: 7.2)
                                    ]
                                )
                                
                                DashboardCard(
                                    title: "Avg Mortgage",
                                    value: marketData.mortgageRate,
                                    subtitle: "30-year fixed",
                                    icon: "house.fill",
                                    color: .green,
                                    trendData: [
                                        TrendPoint(index: 0, value: 6.5),
                                        TrendPoint(index: 1, value: 6.7),
                                        TrendPoint(index: 2, value: 6.9),
                                        TrendPoint(index: 3, value: 6.8),
                                        TrendPoint(index: 4, value: 6.8)
                                    ]
                                )
                            }
                            
                            HStack(spacing: 12) {
                                DashboardCard(
                                    title: "Savings APY",
                                    value: marketData.savingsAPY,
                                    subtitle: "High-yield avg",
                                    icon: "dollarsign.circle.fill",
                                    color: .orange,
                                    trendData: [
                                        TrendPoint(index: 0, value: 4.2),
                                        TrendPoint(index: 1, value: 4.3),
                                        TrendPoint(index: 2, value: 4.4),
                                        TrendPoint(index: 3, value: 4.5),
                                        TrendPoint(index: 4, value: 4.5)
                                    ]
                                )
                                
                                DashboardCard(
                                    title: "S&P 500",
                                    value: marketData.sp500Change,
                                    subtitle: "Today",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: .purple,
                                    trendData: [
                                        TrendPoint(index: 0, value: 5200),
                                        TrendPoint(index: 1, value: 5250),
                                        TrendPoint(index: 2, value: 5220),
                                        TrendPoint(index: 3, value: 5280),
                                        TrendPoint(index: 4, value: 5300)
                                    ]
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Calculators & Tools")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        VStack(spacing: 12){
                            NavigationLink {
                                AutoLoanView()
                            } label: {
                                HomeCardButton(
                                    title: "Auto Loan Calculator",
                                    subtitle: "Calculate monthly payments and total interest",
                                    systemImage: "car",
                                    color: .blue
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                MortgageView()
                            } label: {
                                HomeCardButton(
                                    title: "Mortgage Calculator",
                                    subtitle: "Plan your home loan and amortization",
                                    systemImage: "house",
                                    color: .green
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                SavingPlannerView()
                            } label: {
                                HomeCardButton(
                                    title: "Saving Planner",
                                    subtitle: "Set goals and track your savings growth",
                                    systemImage: "banknote",
                                    color: .orange
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                EducationView()
                            } label: {
                                HomeCardButton(
                                    title: "Education",
                                    subtitle: "Learn financial basics",
                                    systemImage: "book.fill",
                                    color: .purple
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
            }
            .onAppear {
                Task {
                    await marketData.fetchRates()
                }
            }
        }
    }
}

// preview canvas
#Preview {
    HomeView()
}
