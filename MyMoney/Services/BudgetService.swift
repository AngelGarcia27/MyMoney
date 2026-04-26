import Foundation
import Supabase

struct BudgetData: Codable {
    var id: UUID?
    let userId: UUID?
    var monthlyIncome: Double
    
    enum CodingKeys: String, CodingKey {
        case id, monthlyIncome = "monthly_income", userId = "user_id"
    }
}

struct BudgetExpenseData: Codable, Identifiable {
    var id: UUID?
    let budgetId: UUID?
    let name: String
    let amount: Double
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, budgetId = "budget_id", name, amount, category
    }
}

struct NewBudget: Encodable {
    let userId: UUID
    let monthlyIncome: Double
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id", monthlyIncome = "monthly_income"
    }
}

struct NewExpense: Encodable {
    let budgetId: UUID
    let name: String
    let amount: Double
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case budgetId = "budget_id", name, amount, category
    }
}

struct UpdateBudget: Encodable {
    let monthlyIncome: Double
    
    enum CodingKeys: String, CodingKey {
        case monthlyIncome = "monthly_income"
    }
}

@MainActor
class BudgetService: ObservableObject {
    static let shared = BudgetService()
    
    @Published var currentBudget: BudgetData?
    @Published var expenses: [BudgetExpenseData] = []
    
    private let supabase = SupabaseManager.shared.client
    
    func loadBudget() async {
        guard let userId = try? await supabase.auth.session.user.id else { return }
        
        do {
            let budgets: [BudgetData] = try await supabase
                .from("budgets")
                .select()
                .eq("user_id", value: userId.uuidString)
                .limit(1)
                .execute()
                .value
            
            if let budget = budgets.first {
                currentBudget = budget
                expenses = try await supabase
                    .from("budget_expenses")
                    .select()
                    .eq("budget_id", value: budget.id!.uuidString)
                    .execute()
                    .value
            }
        } catch {
            print("BudgetService: \(error.localizedDescription)")
        }
    }
    
    func saveBudget(monthlyIncome: Double) async {
        guard let userId = try? await supabase.auth.session.user.id else { return }
        
        do {
            if let existingId = currentBudget?.id {
                try await supabase
                    .from("budgets")
                    .update(UpdateBudget(monthlyIncome: monthlyIncome))
                    .eq("id", value: existingId.uuidString)
                    .execute()
                currentBudget?.monthlyIncome = monthlyIncome
            } else {
                let newBudget = NewBudget(userId: userId, monthlyIncome: monthlyIncome)
                let inserted: BudgetData = try await supabase
                    .from("budgets")
                    .insert(newBudget)
                    .select()
                    .single()
                    .execute()
                    .value
                currentBudget = inserted
            }
        } catch {
            print("BudgetService: \(error.localizedDescription)")
        }
    }
    
    func addExpense(name: String, amount: Double, category: String) async {
        guard let budgetId = currentBudget?.id else {
            print("BudgetService: No budget ID - cannot add expense")
            return
        }
        
        print("BudgetService: Adding expense - name: \(name), amount: \(amount), category: \(category), budgetId: \(budgetId)")
        
        do {
            let newExpense = NewExpense(budgetId: budgetId, name: name, amount: amount, category: category)
            let inserted: BudgetExpenseData = try await supabase
                .from("budget_expenses")
                .insert(newExpense)
                .select()
                .single()
                .execute()
                .value
            expenses.append(inserted)
            print("BudgetService: Expense added successfully - \(inserted)")
        } catch {
            print("BudgetService addExpense error: \(error)")
        }
    }
    
    func deleteExpense(_ expense: BudgetExpenseData) async {
        guard let id = expense.id else { return }
        
        do {
            try await supabase.from("budget_expenses").delete().eq("id", value: id.uuidString).execute()
            expenses.removeAll { $0.id == id }
        } catch {
            print("BudgetService: \(error.localizedDescription)")
        }
    }
}
