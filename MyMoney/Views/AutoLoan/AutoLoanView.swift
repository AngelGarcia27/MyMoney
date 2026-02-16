import SwiftUI

// sub tools in the Auto Loan feature
enum AutoLoanTool: String, CaseIterable, Identifiable {
    case calculator = "Auto Loan Calculator"
    case analysis = "Graph Analysis"
    var id: String { self.rawValue }
}

struct AutoLoanView: View {
    // controls which tool is shown
    @State private var selectedTool: AutoLoanTool = .calculator
    @StateObject private var model = AutoLoanModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Auto Loan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // tool switcher
                Picker("Select Tool", selection: $selectedTool) {
                    ForEach(AutoLoanTool.allCases) { tool in
                        Text(tool.rawValue).tag(tool)
                    }
                }
                .pickerStyle(.segmented)
                
                // shows the selected tool
                switch selectedTool {
                case .calculator:
                    AutoLoanCalculatorView(model: model)

                case .analysis:
                    LoanAnalysisView(model: model)
                }
            }
            .padding()
        }
    }
}


// preview canvas
#Preview {
    AutoLoanView()
}
