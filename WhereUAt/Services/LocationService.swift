import Foundation
import CoreLocation
import FirebaseFirestore

class LocationService {
    var onLocationAdded: (() -> Void)?
    
    private let db = Firestore.firestore()
    
    func fetchLocations(completion: @escaping ([Location], Error?) -> Void) {
        db.collection("locations").getDocuments { querySnapshot, error in
            if let error = error {
                completion([], error)
            } else {
                var locations: [Location] = []
                for document in querySnapshot!.documents {
                    if let location = Location(documentId: document.documentID, documentData: document.data()) {
                        locations.append(location)
                    }
                }
                completion(locations, nil)
            }
        }
    }
    
    func fetchLocation(withId id: String, completion: @escaping (Location?) -> Void) {
        db.collection("locations").document(id).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching location: \(error)")
                completion(nil)
                return
            }
            
            guard let document = documentSnapshot, document.exists, let documentData = document.data() else {
                completion(nil)
                return
            }
            
            if let location = Location(documentId: document.documentID, documentData: documentData) {
                completion(location)
            } else {
                completion(nil)
            }
        }
    }
    
    func addLocation(latitude: String, longitude: String, description: String, name: String, userId: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let lat = parseCoordinate(latitude), let lon = parseCoordinate(longitude) else {
            let error = NSError(domain: "InvalidCoordinates", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid coordinates"])
            completion(false, error)
            return
        }
        
        let coordinates = GeoPoint(latitude: lat, longitude: lon)
        let locationData: [String: Any] = [
            "coordinates": coordinates,
            "description": description,
            "name": name,
            "user_id": userId
        ]
        
        db.collection("locations").addDocument(data: locationData) { error in
            if let error = error {
                completion(false, error)
            } else {
                self.onLocationAdded?()
                completion(true, nil)
            }
        }
    }
    
    private func parseCoordinate(_ coordinate: String) -> Double? {
        let formattedCoordinate = coordinate.replacingOccurrences(of: ",", with: ".")
        return Double(formattedCoordinate)
    }
    
}
