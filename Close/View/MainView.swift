import UIKit
import SwiftUI

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white

        // Create buttons
        let emotionWheelButton = createButton(title: "Emotion Wheel")
        let myPostsButton = createButton(title: "My Posts")
        let peersPostsButton = createButton(title: "Peers' Posts")

        // Add buttons to view
        let stackView = UIStackView(arrangedSubviews: [emotionWheelButton, myPostsButton, peersPostsButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Set constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Add actions to buttons
        emotionWheelButton.addTarget(self, action: #selector(emotionWheelButtonTapped), for: .touchUpInside)
        myPostsButton.addTarget(self, action: #selector(myPostsButtonTapped), for: .touchUpInside)
        peersPostsButton.addTarget(self, action: #selector(peersPostsButtonTapped), for: .touchUpInside)
    }

    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc func emotionWheelButtonTapped() {
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    @objc func myPostsButtonTapped() {
        let myPostsView = MyPostsView()
        let hostingController = UIHostingController(rootView: myPostsView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    @objc func peersPostsButtonTapped() {
        let myPeersPostView = MyPeersPostView()
        let hostingController = UIHostingController(rootView: myPeersPostView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

@available(iOS 13.0, *)
struct HomePageViewController_Preview: PreviewProvider {
    static var previews: some View {
        PreviewViewController()
    }
}

@available(iOS 13.0, *)
struct PreviewViewController: View {
    var body: some View {
        Text("Preview")
            .onAppear {
                let navigationController = UINavigationController(rootViewController: HomePageViewController())
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
    }
}
