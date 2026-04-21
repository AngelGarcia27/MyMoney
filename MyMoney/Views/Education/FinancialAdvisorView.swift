import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}

struct FinancialAdvisorView: View {
    @State private var userInput = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    @FocusState private var isInputFocused: Bool
    
    private let claudeService = ClaudeService(apiKey: ClaudeConfig.apiKey)
    
    private let systemPrompt = """
    You are a friendly financial education assistant for the MyMoney app. Your role is to help users understand personal finance concepts in simple, clear terms.
    
    Topics you can help with:
    - Budgeting (50/30/20 rule)
    - Emergency funds
    - Investing basics
    - Debt management
    - Saving strategies
    
    Keep responses concise and beginner-friendly. Use examples when helpful. If asked about specific investment advice or complex tax situations, remind users to consult a financial professional.
    """
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
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
                TextField("Ask a financial question...", text: $userInput, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...4)
                    .focused($isInputFocused)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(userInput.isEmpty || isLoading ? .gray : .blue)
                }
                .disabled(userInput.isEmpty || isLoading)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle("Financial Advisor")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if messages.isEmpty {
                messages.append(ChatMessage(
                    content: "Hi! I'm your financial education assistant. Ask me anything about budgeting, saving, investing, or managing debt. How can I help you today?",
                    isUser: false
                ))
            }
        }
    }
    
    private func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        messages.append(ChatMessage(content: trimmedInput, isUser: true))
        userInput = ""
        isLoading = true
        
        Task {
            do {
                let response = try await claudeService.sendMessage(trimmedInput, systemPrompt: systemPrompt)
                await MainActor.run {
                    messages.append(ChatMessage(content: response, isUser: false))
                    isLoading = false
                }
            } catch {
                print("Claude Error: \(error)")
                await MainActor.run {
                    messages.append(ChatMessage(
                        content: "Error: \(error.localizedDescription)",
                        isUser: false
                    ))
                    isLoading = false
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding(12)
                .background(message.isUser ? Color.blue : Color(.systemGray5))
                .foregroundStyle(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    NavigationStack {
        FinancialAdvisorView()
    }
}
