import SwiftUI

struct MyPostsView: View {
    @State private var posts = [
        "I currently feel excited about this new SwiftUI page!",
        "Feeling motivated to learn more and create awesome apps.",
        "Just finished building my first SwiftUI project. It's amazing!"
    ]

    @State private var isRefreshed = false
    
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
                    }
                    .padding()
                }
            }
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
    }
    
    private func getTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: Date())
    }
}

struct MyPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsView()
    }
}
