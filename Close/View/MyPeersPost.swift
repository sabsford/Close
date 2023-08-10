import SwiftUI

struct MyPeersPostView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("My Peers' Posts")
                    .font(.title)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        PeerPostView(postText: "I am currently feeling Excited. Because I just launched my new SwiftUI app. Excited to share with everyone!")
                        PeerPostView(postText: "I am currently feeling a bit overwhelmed with all the SwiftUI features to explore.")
                        PeerPostView(postText: "I am currently feeling exhausted because I haven't been able to rest due to this projecy.")
                    }
                    .padding()
                }
            }
            .navigationTitle("My Peers' Posts")
        }
    }
}

struct PeerPostView: View {
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

struct MyPeersPostView_Previews: PreviewProvider {
    static var previews: some View {
        MyPeersPostView()
    }
}
