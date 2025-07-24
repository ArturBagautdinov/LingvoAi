import SwiftUI
import FirebaseAuth

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAnimated = false
    @State private var userIsLoggedIn = false
    @StateObject private var authenticationService: Auth = Auth()
    @State private var errorMessage: String? = nil
    
    var body: some View {
        if userIsLoggedIn {
            TabBarView()
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()

                VStack(spacing: 40) {
                    Spacer()
                    Spacer()
                    VStack(spacing: 2) {
                        Text("Welcome")
                            .font(.system(size: 45, weight: .bold, design: .default))
                            .padding(.leading, -130)
                        Text("to")
                            .font(.system(size: 21, weight: .medium, design: .default))
                            .italic()
                        Text("Lingvo")
                            .font(.system(size: 50, weight: .bold, design: .default))
                            .padding(.leading, 130)
                    }
                    .foregroundStyle(.white)
                    .overlay(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("Lingvo")
                                .font(.system(size: 50, weight: .bold))
                                .blur(radius: 2)
                        )
                        .offset(x: 100, y: 1)
                    )
                            
                    VStack(spacing: 40) {

                        VStack(spacing: 20) {
                            TextField("Email", text: $email)
                                .padding()
                                .frame(height: 40)
                                .background(.white)
                                .cornerRadius(5)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(height: 40)
                                .background(.white)
                                .cornerRadius(5)
                            
                            if let error = errorMessage {
                                Text(error)
                                    .foregroundStyle(.red)
                                    .font(.caption)
                            }
                        }
                        .frame(width: 370)
                        
                        AuthButton(text: "LOGIN", icon: "arrow.right",  isAnimated: $isAnimated) {
                            if email.isEmpty {
                                    errorMessage = "Enter email"
                                    return
                                }
                                
                            if password.isEmpty {
                                    errorMessage = "Enter пароль"
                                    return
                                }
                                
                            if password.count < 6 {
                                    errorMessage = "The password must be at least 6 characters long"
                                    return
                                }
                                
                            authenticationService.login(email: email, password: password) { error in
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                }
                            }
                            
                        }.padding(.top, 30)
                        
                        
                    }
                    .padding(.top, 40)
                    Spacer()
                    Spacer()
                
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                        NavigationLink {
                            SignUp()
                        } label: {
                            Text("Sign up")
                                .underline()
                        }
                    }
                    .foregroundStyle(.lGray)
                    
                }
            }
            .onAppear {
                FirebaseAuth.Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Login()
}

