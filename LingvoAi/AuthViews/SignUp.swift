import SwiftUI
import Firebase

struct SignUp: View {
    @State private var isAnimated: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage :String?
    private var authenticationService: Auth = Auth()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()
                Spacer()
                
                VStack(spacing: 0) {
                    Spacer()
                    ZStack {
                        Text("Lingvo")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .trailing,
                                    endPoint: .leading
                                )
                            )
                            .blur(radius: 10)
                            .offset(x: 3, y: 3)
                        Text("Lingvo")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 105)
                    
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
                    
                    AuthButton(text: "SIGN UP", isAnimated: $isAnimated) {
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
                            
                        errorMessage = nil
                        
                        authenticationService.register(email: email, password: password) { error in
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                }
                            }
                    }
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                        NavigationLink {
                            Login()
                        } label: {
                            Text("Log in")
                                .underline()
                        }
                    }
                    .foregroundStyle(.lGray)
                }
                
            }
        }
        .navigationBarBackButtonHidden()
        
    }
    
    
}

#Preview {
    SignUp()
}
