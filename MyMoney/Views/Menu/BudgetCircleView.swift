import SwiftUI
import Charts

struct BudgetCircleView: View {
    @StateObject private var budgetService = BudgetService.shared
    @State private var monthlyIncome: String = ""
    @State private var showingAddExpense = false
    @State private var expenses: [BudgetExpense] = []
    @State private var newExpenseName: String = ""
    @State private var newExpenseAmount: String = ""
    @State private var selectedCategory: ExpenseCategory = .other
    @State private var showingExportSheet = false
    @State private var pdfData: Data?
    @State private var showingBudgetChat = false
    @State private var hasLoadedData = false
    
    private var incomeValue: Double {
        Double(monthlyIncome) ?? 0
    }
    
    private var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    private var remaining: Double {
        incomeValue - totalExpenses
    }
    
    private var expensesByCategory: [CategoryTotal] {
        var totals: [ExpenseCategory: Double] = [:]
        for expense in expenses {
            totals[expense.category, default: 0] += expense.amount
        }
        return totals.map { CategoryTotal(category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Budget Overview")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 16) {
                incomeInputSection
                
                if incomeValue > 0 {
                    budgetCircleSection
                    
                    if !expenses.isEmpty {
                        expenseLegendSection
                    }
                }
                
                if !expenses.isEmpty {
                    expensesListSection
                }
                
                addExpenseButton
                
                if incomeValue > 0 || !expenses.isEmpty {
                    exportButton
                    
                    budgetChatButton
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseSheet(
                expenseName: $newExpenseName,
                expenseAmount: $newExpenseAmount,
                selectedCategory: $selectedCategory,
                onAdd: addExpense
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingExportSheet) {
            if let data = pdfData {
                ShareSheet(items: [data])
            }
        }
        .sheet(isPresented: $showingBudgetChat) {
            BudgetChatView(
                income: incomeValue,
                expenses: expenses,
                totalExpenses: totalExpenses,
                remaining: remaining
            )
            .presentationDetents([.large])
        }
        .task {
            if !hasLoadedData {
                await loadBudgetData()
                hasLoadedData = true
            }
        }
        .onChange(of: monthlyIncome) { _, newValue in
            if let income = Double(newValue), income > 0, hasLoadedData {
                Task {
                    await budgetService.saveBudget(monthlyIncome: income)
                }
            }
        }
    }
    
    @ViewBuilder
    private var exportButton: some View {
        Button {
            pdfData = PDFExportService.generateBudgetPDF(
                monthlyIncome: incomeValue,
                expenses: expenses,
                totalExpenses: totalExpenses,
                remaining: remaining
            )
            showingExportSheet = true
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export Budget")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.green)
            )
        }
    }
    
    @ViewBuilder
    private var budgetChatButton: some View {
        Button {
            showingBudgetChat = true
        } label: {
            HStack {
                Image(systemName: "sparkles")
                Text("Get AI Tips")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.purple)
            )
        }
    }
    
    @ViewBuilder
    private var incomeInputSection: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill")
                .font(.title2)
                .foregroundStyle(.green)
            
            TextField("Monthly Income", text: $monthlyIncome)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .font(.title3.weight(.semibold))
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            
            if !monthlyIncome.isEmpty {
                Text("/ month")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
    
    @ViewBuilder
    private var budgetCircleSection: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 20)
            
            expenseSegments
            
            if remaining > 0 && totalExpenses > 0 {
                Circle()
                    .trim(from: totalExpenses / incomeValue, to: 1.0)
                    .stroke(Color.green.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
            
            centerContent
        }
        .frame(height: 180)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var expenseSegments: some View {
        if !expenses.isEmpty {
            ForEach(Array(expensesByCategory.enumerated()), id: \.element.category) { index, categoryTotal in
                Circle()
                    .trim(from: trimStart(for: index), to: trimEnd(for: index))
                    .stroke(categoryTotal.category.color, style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
        }
    }
    
    @ViewBuilder
    private var centerContent: some View {
        VStack(spacing: 4) {
            Text(remaining >= 0 ? "Remaining" : "Over Budget")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(formatCurrency(abs(remaining)))
                .font(.title2.weight(.bold))
                .foregroundColor(remaining >= 0 ? .primary : .red)
            
            if incomeValue > 0 {
                let percentage = Int((totalExpenses / incomeValue) * 100)
                Text("\(percentage)% spent")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var expenseLegendSection: some View {
        VStack(spacing: 8) {
            ForEach(expensesByCategory, id: \.category) { categoryTotal in
                legendRow(for: categoryTotal)
            }
        }
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    private func legendRow(for categoryTotal: CategoryTotal) -> some View {
        HStack {
            Circle()
                .fill(categoryTotal.category.color)
                .frame(width: 10, height: 10)
            
            Text(categoryTotal.category.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(formatCurrency(categoryTotal.total))
                .font(.caption.weight(.medium))
            
            let percentage = Int((categoryTotal.total / incomeValue) * 100)
            Text("(\(percentage)%)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var expensesListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Expenses")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            
            ForEach(expenses) { expense in
                expenseRow(for: expense)
            }
        }
    }
    
    @ViewBuilder
    private func expenseRow(for expense: BudgetExpense) -> some View {
        HStack {
            Image(systemName: expense.category.icon)
                .foregroundStyle(expense.category.color)
                .frame(width: 24)
            
            Text(expense.name)
                .font(.subheadline)
            
            Spacer()
            
            Text(formatCurrency(expense.amount))
                .font(.subheadline.weight(.medium))
            
            Button {
                deleteExpense(expense)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var addExpenseButton: some View {
        Button {
            showingAddExpense = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Expense")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue.opacity(0.1))
            )
        }
    }
    
    private func trimStart(for index: Int) -> CGFloat {
        guard incomeValue > 0 else { return 0 }
        var start: Double = 0
        for i in 0..<index {
            start += expensesByCategory[i].total / incomeValue
        }
        return min(start, 1.0)
    }
    
    private func trimEnd(for index: Int) -> CGFloat {
        guard incomeValue > 0 else { return 0 }
        var end: Double = 0
        for i in 0...index {
            end += expensesByCategory[i].total / incomeValue
        }
        return min(end, 1.0)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    private func addExpense() {
        guard let amount = Double(newExpenseAmount), !newExpenseName.isEmpty else { return }
        
        let name = newExpenseName
        let category = selectedCategory
        
        let expense = BudgetExpense(name: name, amount: amount, category: category)
        expenses.append(expense)
        
        Task {
            await budgetService.addExpense(name: name, amount: amount, category: category.rawValue)
        }
        
        newExpenseName = ""
        newExpenseAmount = ""
        selectedCategory = .other
        showingAddExpense = false
    }
    
    private func deleteExpense(_ expense: BudgetExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses.remove(at: index)
        }
        
        if let matchingExpense = budgetService.expenses.first(where: { $0.name == expense.name && $0.amount == expense.amount }) {
            Task {
                await budgetService.deleteExpense(matchingExpense)
            }
        }
    }
    
    private func loadBudgetData() async {
        await budgetService.loadBudget()
        
        if let budget = budgetService.currentBudget {
            monthlyIncome = budget.monthlyIncome > 0 ? String(format: "%.0f", budget.monthlyIncome) : ""
        }
        
        print("Loaded expenses: \(budgetService.expenses)")
        
        expenses = budgetService.expenses.map { data in
            BudgetExpense(
                name: data.name,
                amount: data.amount,
                category: ExpenseCategory(rawValue: data.category) ?? .other
            )
        }
    }
}

struct AddExpenseSheet: View {
    @Binding var expenseName: String
    @Binding var expenseAmount: String
    @Binding var selectedCategory: ExpenseCategory
    let onAdd: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Name", text: $expenseName)
                    
                    HStack {
                        Text("$")
                        TextField("Amount", text: $expenseAmount)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd()
                    }
                    .disabled(expenseName.isEmpty || expenseAmount.isEmpty)
                }
            }
        }
    }
}

struct BudgetExpense: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let category: ExpenseCategory
}

struct CategoryTotal {
    let category: ExpenseCategory
    let total: Double
}

enum ExpenseCategory: String, CaseIterable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case savings = "Savings"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .transportation: return "car.fill"
        case .food: return "fork.knife"
        case .utilities: return "bolt.fill"
        case .healthcare: return "heart.fill"
        case .entertainment: return "tv.fill"
        case .shopping: return "bag.fill"
        case .savings: return "banknote.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .housing: return .blue
        case .transportation: return .orange
        case .food: return .green
        case .utilities: return .yellow
        case .healthcare: return .red
        case .entertainment: return .purple
        case .shopping: return .pink
        case .savings: return .mint
        case .other: return .gray
        }
    }
}

#Preview {
    ScrollView {
        BudgetCircleView()
            .padding()
    }
    .background(Color(.systemGroupedBackground))
}
