import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct Auth {
    
    func register(email: String, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { resul, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func login(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
}
