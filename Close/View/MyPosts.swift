import SwiftUI

struct MyPostsView: View {
    @State private var posts = [
        "I currently feel excited about this new SwiftUI page!",
        "Feeling motivated to learn more and create awesome apps.",
        "Just finished building my first SwiftUI project. It's amazing!"
    ]

    @State private var isRefreshed = false
    @State private var isCreatePostPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posts, id: \.self) { post in
                            PostView(postText: post)
                        }
                        
                        Button(action: {
                            refreshPosts()
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $isCreatePostPresented) {
                            CreateNewPostView(isPresented: $isCreatePostPresented, posts: $posts)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    isCreatePostPresented = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            )
            .navigationTitle("My Post's")
        }
    }
    
    private func refreshPosts() {
        // Simulate data refresh
        isRefreshed.toggle()
    }
}

struct PostView: View {
    let postText: String
    @Environment(\.presentationMode) var presentationMode // Add this line

    var body: some View {
        VStack(alignment: .leading) {
            Text(postText)
                .font(.body)
            Text(getTimestamp())
                .font(.caption)
                .foregroundColor(.gray)
            Divider()
                .background(Color.gray)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to MyPostsView
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func getTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: Date())
    }
}

struct CreateNewPostView: View {
    @Binding var isPresented: Bool
    @Binding var posts: [String]
    
    @State private var postText = ""
    @State private var isShowingPost = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("I currently feel...")
                    .font(.title)
                    .padding(.top, 20)
                
                TextEditor(text: $postText)
                    .frame(height: 150)
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
                
                Button(action: {
                    let newPost = postText
                    posts.append(newPost)
                    isPresented.toggle()
                }) {
                    Text("Post")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationTitle("Create Post")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct MyPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsView()
    }
}
