import SwiftUI

struct SignInView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("MyMoney")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // TODO: Add a sign in
                NavigationLink("Sign In") {
                    Text("Coming Soon")
                }
                
                // TODO: Add Sign Up
                NavigationLink("Sign Up") {
                    Text("Coming Soon")
                }
                
                // TEMP: To Navigate to the Home View
                NavigationLink("Home") {
                    HomeView()
                }
            }
        }
    }
}

// preview canvas
#Preview {
    SignInView()
}
