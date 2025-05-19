import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var userPosts: [Post] = []
    
    private let userService: UserService
    private let postService: PostService
    
    init(userService: UserService = UserService(), postService: PostService = PostService()) {
        self.userService = userService
        self.postService = postService
    }
    
    func loadUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated. Cannot load profile.")
            return
        }
        
        userService.fetchCurrentUserProfile { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.username = profile.username
                    self.email = profile.email
                case .failure(let error):
                    print("Error fetching user profile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadUserPosts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated. Cannot load posts.")
            return
        }
        
        postService.getAllPosts { posts in
            DispatchQueue.main.async {
                self.userPosts = posts.filter { $0.user_id == userId }
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        userService.signOut { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.username = ""
                    self?.email = ""
                    self?.userPosts = []
                    completion()
                case .failure(let error):
                    print("Error signing out: \(error.localizedDescription)")
                }
            }
        }
    }

}
