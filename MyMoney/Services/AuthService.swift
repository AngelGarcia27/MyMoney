import Foundation
import Supabase

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated = false
    @Published var isGuest = false
    @Published var currentUser: User?
    @Published var isLoading = false
    
    private let supabase = SupabaseManager.shared.client
    
    private init() {
        Task {
            await checkAuthStatus()
            await observeAuthChanges()
        }
    }
    
    func checkAuthStatus() async {
        do {
            let session = try await supabase.auth.session
            currentUser = session.user
            isAuthenticated = true
            print("✅ Auth check: User authenticated - \(session.user.email ?? "no email")")
        } catch {
            isAuthenticated = false
            currentUser = nil
            print("❌ Auth check: No session found - \(error.localizedDescription)")
        }
    }
    
    private func observeAuthChanges() async {
        for await state in supabase.auth.authStateChanges {
            switch state.event {
            case .signedIn:
                currentUser = state.session?.user
                isAuthenticated = true
                print("✅ Auth event: User signed in")
            case .signedOut:
                currentUser = nil
                isAuthenticated = false
                print("❌ Auth event: User signed out")
            default:
                break
            }
        }
    }
    
    func signUp(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )
        
        currentUser = response.user
        isAuthenticated = true
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let response = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        
        currentUser = response.user
        isAuthenticated = true
    }
    
    func signOut() async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await supabase.auth.signOut()
        currentUser = nil
        isAuthenticated = false
    }
    
    func resetPassword(email: String) async throws {
        try await supabase.auth.resetPasswordForEmail(email)
    }
    
    func continueAsGuest() {
        isGuest = true
        isAuthenticated = true
    }
}
