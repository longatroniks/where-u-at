import SwiftUI

class MapViewModel: ObservableObject {
    @Published var markers: [MapMarker] = []
    private var locationService = LocationService()

    init() {
        locationService.onLocationAdded = { [weak self] in
            self?.fetchAndUpdateLocations()
        }
        fetchAndUpdateLocations()
    }

    func fetchAndUpdateLocations() {
        locationService.fetchLocations { [weak self] locations, error in
            if let error = error {
                print("Error fetching locations: \(error)")
            } else {
                DispatchQueue.main.async {
                    self?.markers = locations.map(MapMarker.init)
                }
            }
        }
    }
}
