import SwiftUI
import MapKit

struct CreateLocationView: View {
    
    var authViewModel: AuthViewModel
    var locationService = LocationService()
    
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var description = ""
    @State private var name = ""
    @State private var alertMessage = ""
    
    @State private var isAdding = false
    @State private var showAlert = false
    
    @Binding var isAddingLocation: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                        .font(.body)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                        .font(.body)
                    TextField("Description", text: $description)
                        .font(.body)
                    TextField("Name", text: $name)
                        .font(.body)
                }
                
                Button("Add New Location") {
                    isAdding = true
                    locationService.addLocation(latitude: latitude, longitude: longitude, description: description, name: name, userId: authViewModel.getUserID() ?? "") { success, error in
                        if success {
                            isAddingLocation = false
                        } else {
                            print("Error adding location: \(error?.localizedDescription ?? "Unknown error")")
                        }
                        isAdding = false
                    }
                }
                .disabled(isAdding)
                .padding().alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("New Location")
            .navigationBarItems(trailing: Button("Cancel") {
                isAddingLocation = false
            })
        }
    }
}
