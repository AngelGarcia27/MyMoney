import SwiftUI

struct SavingPlannerView: View {
    @StateObject private var model = SavingPlannerModel()
    
    var body: some View {
        ScrollView {
            SavingsCalculatorView(model: model)
                .padding()
        }
        .navigationTitle("Saving Planner")
        .navigationBarTitleDisplayMode(.large)
    }
}

// preview canvas
#Preview {
    NavigationStack {
        SavingPlannerView()
    }
}
