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
            ZStack {
                BackgroundGradient()
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("LingvoAI")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Text("Ваш интеллектуальный помощник\n в изучении Английского языка")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 25) {
                        FeatureText(icon: "text.book.closed", text: "Глубокая проверка грамматики")
                        FeatureText(icon: "bubble.left.and.bubble.right", text: "Живые диалоги с ИИ")
                        FeatureText(icon: "gamecontroller", text: "Увлекательные языковые квизы")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    Text("Начните своё обучение сейчас!")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}
struct FeatureText: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40)
            
            Text(text)
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}
extension Color {
    static let blueNPurple = Color(red: 0.4, green: 0.3, blue: 0.8)
}

#Preview {
    MainView()
}
