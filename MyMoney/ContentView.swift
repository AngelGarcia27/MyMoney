import SwiftUI

struct ContentView: View {
    @ObservedObject private var authService = AuthService.shared
    
    var body: some View {
        ZStack {
            if authService.isAuthenticated {
                HomeView()
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            } else {
                SignInView()
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: authService.isAuthenticated)
    }
}

// preview canvas
#Preview {
    ContentView()
}
