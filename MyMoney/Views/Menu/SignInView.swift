import SwiftUI

struct SignInView: View {
    let brandColor = Color(red: 0/255, green: 109/255, blue: 91/255)
    var body: some View {
        NavigationStack {
            ZStack {
                
                // background
                brandColor
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    
                    Spacer()
                    
                    // title
                    Text("MyMoney")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                    
                    // card container
                    VStack(spacing: 16) {
                        
                        NavigationLink {
                            Text("Coming Soon")
                        } label: {
                            primaryButton("Sign In")
                        }
                        
                        NavigationLink {
                            Text("Coming Soon")
                        } label: {
                            secondaryButton("Sign Up")
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        NavigationLink {
                            HomeView()
                        } label: {
                            Text("Continue as Guest")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(24)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding(.horizontal, 28)
                    
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

extension SignInView {
    
    func primaryButton(_ title: String) -> some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBlue))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func secondaryButton(_ title: String) -> some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// preview canvas
#Preview {
    SignInView()
}
