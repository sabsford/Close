import SwiftUI

struct MyPostsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Post's")
                    .font(.title)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        PostView(postText: "I currently feel excited about this new SwiftUI page!")
                        PostView(postText: "Feeling motivated to learn more and create awesome apps.")
                        PostView(postText: "Just finished building my first SwiftUI project. It's amazing!")
                    }
                    .padding()
                }
            }
            .navigationTitle("My Post's")
        }
    }
}

struct PostView: View {
    let postText: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(postText)
                .font(.body)
            Divider()
                .background(Color.gray)
        }
    }
}

struct MyPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsView()
    }
}

