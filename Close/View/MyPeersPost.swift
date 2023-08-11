import SwiftUI

struct MyPeersPostView: View {
    @State private var posts = [
        "I am currently feeling Excited. Because I just launched my new SwiftUI app. Excited to share with everyone!",
        "I am currently feeling a bit overwhelmed with all the SwiftUI features to explore.",
        "I am currently completed the SwiftUI course and ready to start building real projects."
    ]

    @State private var isRefreshed = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posts, id: \.self) { post in
                            PeerPostView(postText: post)
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
            .navigationTitle("My Peers Posts")
        }
    }
    
    private func refreshPosts() {
        // Simulate data refresh
        isRefreshed.toggle()
    }
}

struct PeerPostView: View {
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

struct MyPeersPostView_Previews: PreviewProvider {
    static var previews: some View {
        MyPeersPostView()
    }
}
