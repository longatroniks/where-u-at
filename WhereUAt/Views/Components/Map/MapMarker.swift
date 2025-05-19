//
//  MapMarker.swift
//  WhereUAt
//
//  Created by Karlo Longin (RIT Student) on 08.12.2023..
//

import MapKit

struct MapMarker: Identifiable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var location: Location

    init(location: Location) {
        self.id = UUID()
        self.coordinate = location.coordinates
        self.location = location
    }
}
