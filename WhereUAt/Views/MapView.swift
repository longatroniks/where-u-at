import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = MapViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.328979, longitude: 14.457664),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedLocation: Location?
    @State private var isLocationInfoPresented = false
    @State private var isAddingLocation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: viewModel.markers) { marker in
                    MapAnnotation(coordinate: marker.coordinate) {
                        Button(action: {
                            withAnimation {
                                zoomInOnLocation(marker.location)
                            }
                        }) {
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchAndUpdateLocations()
                }
                .edgesIgnoringSafeArea(.all)
                
                if isLocationInfoPresented, let location = selectedLocation {
                    LocationInfoView(location: location, isPresented: $isLocationInfoPresented)
                        .transition(.move(edge: .bottom))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.isAddingLocation = true }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding(10)
                            .background(Circle().fill(Color.blue))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingLocation) {
            CreateLocationView(authViewModel: authViewModel, isAddingLocation: $isAddingLocation)
        }
    }

    private func zoomInOnLocation(_ location: Location) {
        selectedLocation = location
        isLocationInfoPresented = true
        let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        region = MKCoordinateRegion(center: location.coordinates, span: zoomLevel)
    }
}
