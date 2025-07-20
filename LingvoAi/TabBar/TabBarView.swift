//
//  TabBarView.swift
//  LingvoAi
//
//  Created by Artur Bagautdinov on 21.07.2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
            ChatBotMainView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            //QuizView()
                .tabItem {
                    Image(systemName: "graduationcap")
                    Text("Quiz")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                    
                }
        }
        .accentColor(.white)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
        
        
    }
}

#Preview {
    TabBarView()
}
