import SwiftUI

struct PostCell: View {
    let post: Post
    let username: String
    @State private var selectedImageUrl: URL? = nil
    @State private var isFullScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(username)
                    .font(.headline)
                Spacer()
            }
            
            Text(post.description)
                .font(.body)
                .padding(.vertical, 2)
            
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
            .padding()
        }.fullScreenCover(isPresented: $isFullScreen, onDismiss: {
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
    }
}
