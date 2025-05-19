import FirebaseAuth
import FirebaseFirestore

struct UserData {
    let username: String
    let email: String
}

class UserService {
    private let db = Firestore.firestore()

    func createUser(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Firebase Auth Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            self.db.collection("users").document(uid).setData([
                "username": username,
                "email": email
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    func signInUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let firebaseUser = authResult?.user {
                let user = User(firebaseUser: firebaseUser)
                completion(.success(user))
            } else {
                print("No user returned from Firebase")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user returned from Firebase"])))
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchUserData(userID: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        guard !userID.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID is empty"])))
            return
        }
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String ?? "Unknown"
                let email = data?["email"] as? String ?? "No Email"
                completion(.success(UserData(username: username, email: email)))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    func fetchCurrentUserProfile(completion: @escaping (Result<UserData, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }
        
        fetchUserData(userID: userId, completion: completion)
    }

    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
