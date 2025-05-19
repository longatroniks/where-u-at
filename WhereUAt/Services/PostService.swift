import Foundation
import FirebaseFirestore

class PostService {
    private let db = Firestore.firestore()

    func createPost(_ post: Post, completion: @escaping (Bool) -> Void) {
        var postData: [String: Any] = [
            "description": post.description,
            "likes": post.likes,
            "user_id": post.user_id,
            "location_id": post.location_id
        ]

        if let imageUrl = post.image_url {
            postData["image_url"] = imageUrl
        }

        db.collection("posts").document(post.id).setData(postData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func getAllPosts(completion: @escaping ([Post]) -> Void) {
        db.collection("posts").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var posts: [Post] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let post = Post(
                        id: document.documentID,
                        description: data["description"] as? String ?? "",
                        likes: data["likes"] as? Int ?? 0,
                        user_id: data["user_id"] as? String ?? "",
                        location_id: data["location_id"] as? String ?? "",
                        image_url: data["image_url"] as? String
                    )
                    posts.append(post)
                }
                completion(posts)
            }
        }
    }

    func updatePost(_ post: Post, completion: @escaping (Bool) -> Void) {
        var updateData: [String: Any] = [
            "description": post.description,
            "likes": post.likes,
            "user_id": post.user_id,
            "location_id": post.location_id
        ]

        // Include image_url if it's not nil
        if let imageUrl = post.image_url {
            updateData["image_url"] = imageUrl
        }

        db.collection("posts").document(post.id).updateData(updateData) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func deletePost(_ postId: String, completion: @escaping (Bool) -> Void) {
        db.collection("posts").document(postId).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func likeDislikePost(userId: String, postId: String, completion: @escaping (Bool, Bool) -> Void) {
        let userRef = db.collection("users").document(userId)
        let postRef = db.collection("posts").document(postId)

        var liked = false 

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            let userDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldLikes = postDocument.data()?["likes"] as? Int else {
                return nil
            }

            var updatedLikedPosts = userDocument.data()?["liked_posts"] as? [String] ?? []

            if let index = updatedLikedPosts.firstIndex(of: postId) {
                updatedLikedPosts.remove(at: index)
                transaction.updateData(["likes": oldLikes - 1], forDocument: postRef)
                liked = false
            } else {
                updatedLikedPosts.append(postId)
                transaction.updateData(["likes": oldLikes + 1], forDocument: postRef)
                liked = true
            }

            transaction.updateData(["liked_posts": updatedLikedPosts], forDocument: userRef)

            return nil
        }) { (_, error) in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(false, false)
            } else {
                completion(true, liked)
            }
        }
    }
}
