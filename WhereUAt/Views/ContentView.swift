import SwiftUI

struct ContentView: View {
    private let postService = PostService()
    private let userService = UserService()
    private let locationService = LocationService()
    private let slangService = SlangService()
    private let homeViewModel: HomeViewModel

    init() {
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        homeViewModel = HomeViewModel(postService: postService, userService: userService, locationService: locationService, slangService: slangService)
    }
    
    var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
        .font(.headline)
    }
}
