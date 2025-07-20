//
//  MainView.swift
//  LingvoAi
//
//  Created by Artur Bagautdinov on 20.07.2025.
//

import SwiftUICore
import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var shouldShowLoginView = false
    var body: some View {
        
        NavigationStack{
            ZStack{
                Button {
                    do {
                        try FirebaseAuth.Auth.auth().signOut()
                        shouldShowLoginView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.black)
                }
                .navigationDestination(isPresented: $shouldShowLoginView) {
                    Login()
                }
                .padding(.leading, 350)
            }
            .navigationDestination(isPresented: $shouldShowLoginView) {
                Login()
            }
        }
    }
}
#Preview {
    MainView()
}
