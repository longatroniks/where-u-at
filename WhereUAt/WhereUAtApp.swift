import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isAuthenticated {
                    ContentView()
                        .environmentObject(settings)
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
            .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
