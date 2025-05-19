import FirebaseFirestore

struct Post: Identifiable, Codable {
    var id: String = UUID().uuidString
    var description: String
    var likes: Int
    var user_id: String
    var location_id: String
    var image_url: String?  

    init(id: String = UUID().uuidString, description: String, likes: Int, user_id: String, location_id: String, image_url: String? = nil) {
        self.id = id
        self.description = description
        self.likes = likes
        self.user_id = user_id
        self.location_id = location_id
        self.image_url = image_url
    }
}
