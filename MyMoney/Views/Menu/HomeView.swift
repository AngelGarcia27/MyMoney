import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Welcome")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 14){
                        VStack(alignment: .leading, spacing: 14) {
                            Text("COMING SOON DASHBOARD")
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Calculators & Tools")
                            .font(.headline)
                            .foregroundStyle(.black.opacity(0.75))
                        
                            VStack(spacing: 12){
                                NavigationLink {
                                    AutoLoanView()
                                } label: {
                                    HomeCardButton(
                                        title: "Auto Loan Calculator",
                                        subtitle: "Compare Cost Among Terms for Debt Payoff",
                                        systemImage: "car"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            VStack(spacing: 12){
                                NavigationLink {
                                    MortgageView()
                                } label: {
                                    HomeCardButton(
                                        title: "Mortgage Calculator",
                                        subtitle: "Compare Cost Among Terms for Debt Payoff",
                                        systemImage: "house"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            VStack(spacing: 12){
                                NavigationLink {
                                    SavingPlannerView()
                                } label: {
                                    HomeCardButton(
                                        title: "Saving Planner",
                                        subtitle: "Compare Cost Among Terms for Debt Payoff",
                                        systemImage: "book"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            VStack(spacing: 12){
                                NavigationLink {
                                    EducationView()
                                } label: {
                                    HomeCardButton(
                                        title: "Education",
                                        subtitle: "Compare Cost Among Terms for Debt Payoff",
                                        systemImage: "eyeglasses"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    .padding(.horizontal)
                    Spacer(minLength: 24)
                }
            }
            .navigationTitle("MyMoney")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// preview canvas
#Preview {
    HomeView()
}
