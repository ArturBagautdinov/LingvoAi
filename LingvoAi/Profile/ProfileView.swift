//
//  ProfileCreationView.swift
//  LingvoAi
//
//  Created by Ляйсан on 21.07.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name: String = ""
    @State private var spokenLanguages: String = ""
    @State private var isAnimated = false
    @State private var gender: Gender = .male
    @State private var shouldShowLoginView = false
    
    enum Gender {
        case female, male
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: 60) {
            
                VStack(spacing: 20) {
                    VStack (spacing: -50) {
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
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(15)
                        }
                        .padding(.leading, 300)
                        .fullScreenCover(isPresented: $shouldShowLoginView) {
                            Login()
                        }
                        
                    
                        GradientHeader(header: "Profile")
                    }
                    
                
                    
                    
                    Image(gender == .male ? "male" : "female")
                        .resizable()
                        .frame(width: 210, height: 210)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(LinearGradient(colors: [.bluePurple, .dRed], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        )
                    HStack {
                        Text("male")
                        Button {
                            gender = .male
                        } label: {
                            Image(systemName: "record.circle")
                                .foregroundColor(gender == .male ? .white : .gray)
                        }
                        
                        Text("female")
                        Button {
                            gender = .female
                        } label: {
                            Image(systemName: "record.circle")
                                .foregroundColor(gender == .female ? .white : .gray)
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Name")
                        ProfileTextFieldView(name: $name, placeholder: "Enter your name")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Spoken languages")
                        ProfileTextFieldView(name: $spokenLanguages, placeholder: "Enter languages you speak")
                    }
                }
                
                AuthButton(text: "SAVE", icon: "lasso.badge.sparkles", isAnimated: $isAnimated) {
                    saveUserData()
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
        }
        .padding(.bottom, -35)
    }
    
    func saveUserData() {
        guard let userId = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
        
        let user = User(id: userId, name: name, spokenLanguages: spokenLanguages)
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("Users").document(userId).setData(from: user)
        } catch {
            print("Saving error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProfileView()
}

struct ProfileTextFieldView: View {
    @Binding var name: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $name)
            .padding()
            .frame(width: 370, height: 40)
            .foregroundStyle(.white)
            .background(.black)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(LinearGradient(colors: [.bluePurple, .dRed, .bluePurple], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
            )
    }
}

