import SwiftUI

// sub tools in the Auto Loan feature
enum MortgageTool: String, CaseIterable, Identifiable {
    case calculator = "Mortgage Calculator"
    case analysis = "Graph Analysis"
    var id: String { self.rawValue }
}

struct MortgageView: View {
    // controls which tool is shown
    @State private var selectedTool: MortgageTool = .calculator
    @StateObject private var model = MortgageLoanModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Mortgage")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // tool switcher
                Picker("Select Tool", selection: $selectedTool) {
                    ForEach(MortgageTool.allCases) { tool in
                        Text(tool.rawValue).tag(tool)
                    }
                }
                .pickerStyle(.segmented)
                
                // shows the selected tool
                switch selectedTool {
                case .calculator:
                    MortgageLoanCalculatorView(model: model)

                case .analysis:
                    MortgageAnalysisView(model: model)
                }
            }
            .padding()
        }
    }
}

// preview canvas
#Preview {
    MortgageView()
}
