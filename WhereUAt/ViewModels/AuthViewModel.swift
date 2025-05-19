import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isRegistering = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let userService = UserService()
    
    func signIn(email: String, password: String) {
        userService.signInUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isAuthenticated = true
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }

    func signUp(email: String, password: String, username: String) {
        guard !username.isEmpty else {
            self.alertMessage = "Username cannot be empty"
            self.showAlert = true
            return
        }
        
        startRegistering()
        userService.createUser(email: email, password: password, username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isAuthenticated = true
                    self.stopRegistering()
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }

    func signOut() {
        userService.signOut { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isAuthenticated = false
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    func startRegistering() {
        isRegistering = true
    }

    func stopRegistering() {
        isRegistering = false
    }

    func getUserID() -> String? {
        return userService.getCurrentUserID()
    }
}
