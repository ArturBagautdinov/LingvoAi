import Foundation
import SwiftUI
import FirebaseAuth

class Auth: ObservableObject {
    @Published var error: String?
    
    func register(email: String, password: String, completion: @escaping (Error?) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
            
        }
    }
}
