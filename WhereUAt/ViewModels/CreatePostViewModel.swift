import SwiftUI
import FirebaseAuth
import FirebaseStorage

class CreatePostViewModel: ObservableObject {
    @Published var description: String = ""
    @Published var selectedLocationId: String = ""
    @Published var locations: [Location] = []
    @Published var selectedImage: UIImage?
    
    var postService: PostService
    var locationService: LocationService
    
    init(postService: PostService, locationService: LocationService) {
        self.postService = postService
        self.locationService = locationService
    }
    
    func createNewPost(completion: @escaping (Bool, Post?) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid ?? "Unknown User"
        var newPost = Post(description: description, likes: 0, user_id: currentUserID, location_id: selectedLocationId)
        
        if let selectedImage = selectedImage {
            uploadImage(selectedImage) { url in
                newPost.image_url = url
                self.postService.createPost(newPost) { success in
                    completion(success, success ? newPost : nil)
                }
            }
        } else {
            postService.createPost(newPost) { success in
                completion(success, success ? newPost : nil)
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    func loadLocations() {
        locationService.fetchLocations { locations, error in
            if let error = error {
                print("Error fetching locations: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.locations = locations
                }
            }
        }
    }

}
