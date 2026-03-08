import SwiftUI

struct EducationView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    EducationCard(
                        icon: "chart.pie.fill",
                        title: "Budgeting Basics",
                        description: "Learn the 50/30/20 rule: 50% needs, 30% wants, 20% savings",
                        color: .blue
                    )
                    
                    EducationCard(
                        icon: "banknote.fill",
                        title: "Emergency Fund",
                        description: "Save 3-6 months of expenses for unexpected situations",
                        color: .green
                    )
                    
                    EducationCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Start Investing",
                        description: "Begin with index funds and diversify your portfolio",
                        color: .purple
                    )
                    
                    EducationCard(
                        icon: "creditcard.fill",
                        title: "Manage Debt",
                        description: "Pay off high-interest debt first, then build savings",
                        color: .orange
                    )
                }
                .padding()
            }
            .navigationTitle("Financial Education")
        }
    }
}

struct EducationCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// preview canvas
#Preview {
    EducationView()
}
