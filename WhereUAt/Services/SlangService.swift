import FirebaseFirestore

class SlangService {
    private var slangDictionary: [String: String] = [:]
    private let db = Firestore.firestore()
    
    func fetchSlangTerms(completion: @escaping (Bool) -> Void) {
        db.collection("slangs").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let term = data["term"] as? String, let translation = data["translation"] as? String {
                        self.slangDictionary[term] = translation
                    }
                }
                completion(true)
            }
        }
    }
    
    func translatePostText(postText: String) -> String {
        var translatedText = postText
        let words = postText.components(separatedBy: .whitespacesAndNewlines)
        
        for word in words {
            if let translation = slangDictionary[word] {
                translatedText = translatedText.replacingOccurrences(of: word, with: translation)
            }
        }
        
        return translatedText
    }
    
    func hasDifferentTranslation(for postText: String) -> Bool {
        let translatedText = translatePostText(postText: postText)
        return translatedText != postText
    }
}
