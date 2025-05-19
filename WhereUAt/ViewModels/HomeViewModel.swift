import SwiftUI
import FirebaseAuth

class HomeViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var showingTranslation = [String: Bool]()
    @Published var usernameMap = [String: String]()
    @Published var locationMap = [String: Location]()
    @Published var likedPosts = [String]()

    var postService: PostService
    var userService: UserService
    var locationService: LocationService
    var slangService: SlangService

    var currentUserID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    init(postService: PostService, userService: UserService, locationService: LocationService, slangService: SlangService) {
        self.postService = postService
        self.userService = userService
        self.locationService = locationService
        self.slangService = slangService
        fetchSlangTermsAndPosts()
    }

    func fetchUsernamesForPosts() {
        let userIds = Set(posts.map { $0.user_id }.filter { !$0.isEmpty })
        userIds.forEach { id in
            userService.fetchUserData(userID: id) { result in
                switch result {
                case .success(let userData):
                    DispatchQueue.main.async {
                        self.usernameMap[id] = userData.username
                    }
                case .failure(let error):
                    print("Error fetching user data: \(error)")
                }
            }
        }
    }

    func likeDislikePost(postId: String) {
        postService.likeDislikePost(userId: currentUserID, postId: postId) { success, liked in
            if success {
                DispatchQueue.main.async {
                    if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                        if liked {
                            self.posts[index].likes += 1
                            self.likedPosts.append(postId)
                        } else {
                            self.posts[index].likes -= 1
                            self.likedPosts.removeAll(where: { $0 == postId })
                        }
                    }
                }
            } else {
                print("Error in liking/disliking post")
            }
        }
    }

    func fetchPosts() {
        postService.getAllPosts { posts in
            self.posts = posts
            self.fetchUsernamesForPosts()
            self.fetchLocationsForPosts(posts: posts)
        }
    }

    func fetchLocationsForPosts(posts: [Post]) {
        for post in posts {
            if !post.location_id.isEmpty {
                locationService.fetchLocation(withId: post.location_id) { location in
                    DispatchQueue.main.async {
                        self.locationMap[post.id] = location
                        print("Fetched location: \(location?.name ?? "Unknown") for post ID: \(post.id)")
                    }
                }
            }
        }
    }

    func fetchSlangTermsAndPosts() {
        slangService.fetchSlangTerms { success in
            if success {
                self.fetchPosts()
            } else {
                print("Failed to fetch slang terms")
            }
        }
    }
}
