import SwiftUI

struct SignInView: View {
    let brandColor = Color(red: 0/255, green: 109/255, blue: 91/255)
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
                        NavigationLink {
                            HomeView()
                        } label: {
                            Text("Continue as Guest")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        
                        // buttons at bottom
                        HStack(spacing: 12) {
                            NavigationLink {
                                Text("Coming Soon")
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.white)
                                    .foregroundStyle(brandColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            NavigationLink {
                                Text("Coming Soon")
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
                    }
                    .padding(24)
                    .padding(.bottom, 8)
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
