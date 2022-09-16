
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.tintColor = .customLightBlue
        tabBar.backgroundColor = .white
        
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let profileVC = ProfileViewController()
        let favoriteVC = FavoriteViewController()
        let watchlistVC = WatchlistViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: homeVC, image: UIImage(systemName: "house")!, title: "Home"),
            generateNavigationController(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
            generateNavigationController(rootViewController: favoriteVC, image: UIImage(systemName: "star")!, title: "Favorite"),
            generateNavigationController(rootViewController: watchlistVC, image: UIImage(systemName: "list.and.film")!, title: "Watchlist"),
            generateNavigationController(rootViewController: profileVC, image: UIImage(systemName: "person.badge.plus")!, title: "Profile")
        ]
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 50, left: 0, bottom: -6, right: 0)
        return navigationVC
    }
    
//    func setupNavigationBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "arrow.uturn.backward"),
//            style: .plain,
//            target: self,
//            action: #selector(backButtonTapped))
//        
//        navigationItem.leftBarButtonItem?.tintColor = .white
//        navigationController?.hidesBarsOnSwipe = true
//    }
//
//    @objc func backButtonTapped(){
//        TMDBClient.logout {
//            DispatchQueue.main.async {
//                let auth = AuthorizationViewController()
//                if let parentNav = self.navigationController {
//                    parentNav.dismiss(animated: true) {
//                        parentNav.pushViewController(auth, animated: true)
//                        TMDBClient.Auth.sessionId = ""
//                        TMDBClient.Auth.guestSessionID = ""
//                    }
//                }
//            }
//        }
//    }
}

