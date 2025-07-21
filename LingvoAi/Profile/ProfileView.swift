import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var shouldShowLoginView = false
    @State var isAnimated = false
    
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
                    
                    ZStack {
                        NavigationLink {
                            ProfileCreationView()
                        } label: {
                            CreateButton(isAnimated: $isAnimated)
                        }
                    }
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

struct CreateButton: View {
    @Binding var isAnimated: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AngularGradient(colors: [.black, .bluePurple,.dRed, .black] , center: .center, angle: .degrees(isAnimated ? 360 : 0)))
                .frame(width: 145, height: 55)
                .blur(radius: 10)
                .onAppear {
                    withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                        isAnimated.toggle()
                    }
                }
            Text("Create  \(Image(systemName: "wand.and.sparkles"))")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 140, height: 50)
                .padding(.horizontal, 10)
                .background(.black)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.bluePurple, lineWidth: 1)
                )
        }
    }
}

