//
//  GradientHeader.swift
//  LingvoAi
//
//  Created by Ляйсан on 23.07.2025.
//

import SwiftUI

struct GradientHeader: View {
    var header: String
    
    var body: some View {
        Text(header)
            .font(.system(size: 36, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


