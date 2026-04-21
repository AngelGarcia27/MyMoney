import SwiftUI

struct BudgetChatView: View {
    let income: Double
    let expenses: [BudgetExpense]
    let totalExpenses: Double
    let remaining: Double
    
    @Environment(\.dismiss) private var dismiss
    @State private var userInput = ""
    @State private var messages: [BudgetChatMessage] = []
    @State private var isLoading = false
    
    private let claudeService = ClaudeService(apiKey: ClaudeConfig.apiKey)
    
    private var budgetContext: String {
        var context = """
        You are a helpful budget advisor. Keep responses brief and actionable (2-3 sentences max).
        
        Current Budget:
        - Monthly Income: $\(String(format: "%.0f", income))
        - Total Expenses: $\(String(format: "%.0f", totalExpenses))
        - Remaining: $\(String(format: "%.0f", remaining))
        
        Expenses by category:
        """
        
        for expense in expenses {
            context += "\n- \(expense.category.rawValue): \(expense.name) - $\(String(format: "%.0f", expense.amount))"
        }
        
        return context
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                BudgetMessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if isLoading {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Thinking...")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    TextField("Ask about your budget...", text: $userInput)
                        .textFieldStyle(.plain)
                        .onSubmit { sendMessage() }
                    
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(userInput.isEmpty || isLoading ? .gray : .purple)
                    }
                    .disabled(userInput.isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("Budget Tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                if messages.isEmpty {
                    getInitialTip()
                }
            }
        }
    }
    
    private func getInitialTip() {
        isLoading = true
        Task {
            do {
                let prompt = "Based on my budget, give me one quick tip to improve my finances."
                let response = try await claudeService.sendMessage(prompt, systemPrompt: budgetContext)
                await MainActor.run {
                    messages.append(BudgetChatMessage(content: response, isUser: false))
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    messages.append(BudgetChatMessage(
                        content: "Add your income and expenses to get personalized tips!",
                        isUser: false
                    ))
                    isLoading = false
                }
            }
        }
    }
    
    private func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        messages.append(BudgetChatMessage(content: trimmedInput, isUser: true))
        userInput = ""
        isLoading = true
        
        Task {
            do {
                let response = try await claudeService.sendMessage(trimmedInput, systemPrompt: budgetContext)
                await MainActor.run {
                    messages.append(BudgetChatMessage(content: response, isUser: false))
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    messages.append(BudgetChatMessage(
                        content: "Sorry, couldn't process that. Try again.",
                        isUser: false
                    ))
                    isLoading = false
                }
            }
        }
    }
}

struct BudgetChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct BudgetMessageBubble: View {
    let message: BudgetChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding(12)
                .background(message.isUser ? Color.purple : Color(.systemGray5))
                .foregroundStyle(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if !message.isUser { Spacer() }
        }
    }
}
