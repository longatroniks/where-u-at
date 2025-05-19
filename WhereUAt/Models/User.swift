import FirebaseAuth

class User {
    var email: String
    var uid: String

    init(firebaseUser: FirebaseAuth.User) {
        self.email = firebaseUser.email ?? ""
        self.uid = firebaseUser.uid
    }
}
