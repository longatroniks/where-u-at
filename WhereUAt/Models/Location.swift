import Foundation
import CoreLocation
import FirebaseFirestore

struct Location: Identifiable {
    let id: String
    var coordinates: CLLocationCoordinate2D
    var description: String
    var name: String
    var user_id: String

    init?(documentId: String, documentData: [String: Any]) {
        guard let name = documentData["name"] as? String,
              let user_id = documentData["user_id"] as? String,
              let description = documentData["description"] as? String,
              let geoPoint = documentData["coordinates"] as? GeoPoint else {
            return nil
        }

        self.id = documentId
        self.coordinates = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        self.description = description
        self.name = name
        self.user_id = user_id
    }

    init(coordinates: CLLocationCoordinate2D, description: String, name: String, user_id: String) {
        self.id = UUID().uuidString
        self.coordinates = coordinates
        self.description = description
        self.name = name
        self.user_id = user_id
    }
}
