import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Menu")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            Divider()
            
            Label("Home", systemImage: "house")
            Label("Auto Loan Calculator", systemImage: "car")
            Label("Mortgage Calculator", systemImage: "percent")
            Label("Saving Planner", systemImage: "banknote")
            Label("Eduaction", systemImage: "book")
            
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.systemBackground))
    }
}

// preview canvas
#Preview {
    HomeView()
}
