import SwiftUI

struct ContentView: View {
    @State private var isCreatePostPresented = false

    var body: some View {
        NavigationView {
            VStack {
                RemoteImage(url: URL(string: "https://miro.medium.com/v2/resize:fit:720/format:webp/1*ieAJuyRI3-iOVOBnJzkEwA.jpeg"))
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Text("I am currently feeling...")
                    .font(.title)
                    .padding(.top, 20)
                
                Spacer()
                
                NavigationLink(destination: CreatePostView(), isActive: $isCreatePostPresented) {
                    EmptyView()
                }
                
                Button(action: {
                    isCreatePostPresented = true
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationTitle("Feeling Page")
        }
    }
}

struct RemoteImage: View {
    let url: URL?

    var body: some View {
        if let url = url, let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "questionmark.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }
}

struct CreatePostView: View {
    @State private var postText = ""
    @State private var isShowingPost = false
    @Environment(\.presentationMode) var presentationMode // Add this line

    var body: some View {
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
                isShowingPost.toggle()
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
        .alert(isPresented: $isShowingPost) {
            Alert(title: Text("Post Created"), message: Text("Your post has been created successfully."), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to Feeling Page
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct FeelingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct EmotionwheelView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
