import SwiftUI

struct LoginScreen: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        VStack {
            Image(systemName: "books.vertical.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 32)
            
            Text("Welcome to Shelves")
                .font(.largeTitle)
                .bold()
            
            Text("Your personal library, reimagined.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 60)
            
            Button {
                Task {
                    try? await authManager.signInWithApple()
                }
            } label: {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Sign in with Apple")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            
            if authManager.isLoading {
                ProgressView()
                    .padding(.top)
            }
        }
    }
}
