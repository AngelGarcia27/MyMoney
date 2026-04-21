import Foundation

class ClaudeService: ObservableObject {
    private let apiKey: String
    private let baseURL = "https://api.anthropic.com/v1/messages"
    
    @Published var isLoading = false
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func sendMessage(_ message: String, systemPrompt: String? = nil) async throws -> String {
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        var body: [String: Any] = [
            "model": "claude-sonnet-4-6",
            "max_tokens": 1024,
            "messages": [["role": "user", "content": message]]
        ]
        
        if let systemPrompt = systemPrompt {
            body["system"] = systemPrompt
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Claude API Error: \(httpResponse.statusCode) - \(errorBody)")
            throw ClaudeError.apiError(statusCode: httpResponse.statusCode, message: errorBody)
        }
        
        let claudeResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        return claudeResponse.content.first?.text ?? ""
    }
}

struct ClaudeResponse: Codable {
    let content: [ContentBlock]
}

struct ContentBlock: Codable {
    let type: String
    let text: String
}

enum ClaudeError: Error, LocalizedError {
    case invalidResponse
    case apiError(statusCode: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let statusCode, let message):
            return "API error \(statusCode): \(message)"
        }
    }
}
