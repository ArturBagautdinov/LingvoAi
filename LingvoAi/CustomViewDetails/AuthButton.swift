//
//  AuthButton.swift
//  LingvoAi
//
//  Created by Ляйсан on 19.07.2025.
//

import SwiftUI

struct AuthButton: View {
    var text: String = ""
    @Binding var isAnimated: Bool
    var action: () -> Void
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AngularGradient(colors: [.black, .bluePurple, .dRed, .black],
                                      center: .center,
                                      angle: .degrees(isAnimated ? 360 : 0)))
                .frame(width: 170, height: 40)
                .blur(radius: 10)
                .onAppear {
                    withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                        isAnimated = true
                    }
                }
            
            Button {
                action()
            } label: {
                Text("\(text)   \(Image(systemName: "arrow.forward"))")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 30)
                    .padding(.vertical, 10)
                    .padding(.leading, 25)
                    .padding(.trailing, 15)
                    .background(.black)
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.bluePurple, lineWidth: 1)
                    }
            }
            
        }
    }
}

