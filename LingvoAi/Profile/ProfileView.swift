import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var shouldShowLoginView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()
                VStack {
                    Text("Profile")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    Spacer()
                    Button {
                        do {
                            try FirebaseAuth.Auth.auth().signOut()
                            shouldShowLoginView = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        VStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                    }
                    .fullScreenCover(isPresented: $shouldShowLoginView) {
                        Login()
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
