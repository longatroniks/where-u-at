import SwiftUI

struct CreatePostView: View {
    @ObservedObject var viewModel: CreatePostViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var posts: [Post]
    @State private var showingImagePicker = false
    @State private var isCreatingPost = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details").font(.body)) {
                    TextField("Description", text: $viewModel.description)
                        .font(.body)
                    
                    Picker("Select Location", selection: $viewModel.selectedLocationId) {
                        ForEach(viewModel.locations, id: \.id) { location in
                            Text(location.name).tag(location.id)
                        }
                    }
                    .font(.body)
                    
                    Button("Select image") {
                        showingImagePicker = true
                    }
                    .foregroundColor(.black)
                    
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                            .padding()
                    }
                    
                    Button("Create Post") {
                        isCreatingPost = true
                        viewModel.createNewPost { success, newPost in
                            if success, let newPost = newPost {
                                posts.append(newPost)
                                presentationMode.wrappedValue.dismiss()
                            }
                            isCreatingPost = false
                        }
                    }
                    .disabled(isCreatingPost)
                }
            }
            .navigationBarTitle("Create Post", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
        }
        .onAppear(perform: viewModel.loadLocations)
    }
}
