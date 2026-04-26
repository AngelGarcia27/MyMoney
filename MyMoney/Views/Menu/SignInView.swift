import SwiftUI

struct SignInView: View {
    let brandColor = Color(red: 0/255, green: 109/255, blue: 91/255)
    @State private var showSignIn = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // background
                brandColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    // logo/title
                    VStack(spacing: 16) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        Text("MyMoney")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("Manage your finances with ease")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // bottom section
                    VStack(spacing: 16) {
                        // buttons at bottom
                        HStack(spacing: 12) {
                            Button {
                                showSignIn = true
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.white)
                                    .foregroundStyle(brandColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            Button {
                                showSignUp = true
                            } label: {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        Button {
                            AuthService.shared.continueAsGuest()
                        } label: {
                            Text("Continue as Guest")
                                .fontWeight(.medium)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 8)
                }
            }
            .sheet(isPresented: $showSignIn) {
                SignInFormView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
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
