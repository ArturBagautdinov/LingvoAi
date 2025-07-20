//
//  LingvoAiApp.swift
//  LingvoAi
//
//  Created by Ляйсан on 19.07.2025.
//

import SwiftUI
import Firebase


@main
struct LingvoAiApp: App {
    
    init() {
    FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Login()
        }
    }
}
