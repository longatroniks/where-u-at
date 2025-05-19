import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showingCreatePostView = false
    
    @State private var fullScreenImageUrl: URL? = nil
    @State private var selectedImageUrl: URL? = nil
    @State private var isFullScreen = false
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.posts, id: \.id) { post in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(viewModel.usernameMap[post.user_id] ?? post.user_id)
                                .font(.headline)
                                .bold()
                            Spacer()
                            if let location = viewModel.locationMap[post.id] {
                                Text("@\(location.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Location not available")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(post.description)
                            .font(.body)
                            .padding(.vertical, 2)
                        
                        if viewModel.showingTranslation[post.id, default: false] {
                            Text(viewModel.slangService.translatePostText(postText: post.description))
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        
                        if viewModel.slangService.hasDifferentTranslation(for: post.description) {
                            Button(action: {
                                viewModel.showingTranslation[post.id, default: false].toggle()
                            }) {
                                Text(viewModel.showingTranslation[post.id, default: false] ? "Hide Translation" : "Show Translation")
                                    .font(.subheadline)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        
                        
                        VStack {
                            if let imageUrl = post.image_url, let url = URL(string: imageUrl) {
                                Button(action: {
                                    self.selectedImageUrl = url
                                    self.isFullScreen = true
                                }) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .clipped()
                                    .cornerRadius(8)
                                    .padding(.vertical)
                                }
                            }
                        }
                        
                        HStack(spacing: 20) {
                            LikeButton(isLiked: viewModel.likedPosts.contains(post.id), likesCount: post.likes) {
                                viewModel.likeDislikePost(postId: post.id)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .listStyle(PlainListStyle())
                .navigationBarItems(trailing: Button(action: {
                    showingCreatePostView = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }).fullScreenCover(isPresented: $isFullScreen, onDismiss: {
                    self.isFullScreen = false
                }) {
                    if let url = selectedImageUrl {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    self.isFullScreen = false
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("Image not available")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.isFullScreen = false
                            }
                    }
                }
                .sheet(isPresented: $showingCreatePostView) {
                    CreatePostView(viewModel: CreatePostViewModel(postService: viewModel.postService, locationService: viewModel.locationService), posts: $viewModel.posts)
                }
                .onAppear {
                    viewModel.fetchSlangTermsAndPosts()
                }
            }
            .navigationBarTitle("wya.", displayMode: .inline)
        }
    }
}
