import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settings: AppSettings
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    settings.isDarkMode.toggle()
                }) {
                    Image(systemName: settings.isDarkMode ? "sun.max.fill" : "moon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding()
                }
                
                ProfileHeader(username: $viewModel.username, email: $viewModel.email)
                
                Divider()
                
                ForEach(viewModel.userPosts, id: \.id) { post in
                    PostCell(post: post, username: viewModel.username)
                }
                
                Spacer()
                
                SignOutButton(action: {
                    viewModel.signOut {
                        authViewModel.isAuthenticated = false
                    }
                })
                
            }
            .padding()
            .onAppear {
                viewModel.loadUserProfile()
                viewModel.loadUserPosts()
            }
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}
