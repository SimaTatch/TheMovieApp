
import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        setupConstraints()
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.userPhotoImage.layer.cornerRadius = self.userPhotoImage.frame.width / 2
        
        if TMDBClient.Auth.avatarPath.isEmpty {
            self.userPhotoImage.image = UIImage(systemName: "person")!
        } else {
            TMDBClient.downloadAvatarImage(avatarPath: TMDBClient.Auth.avatarPath) { data, error in
                guard let data = data else {
                    return
                }
                let defaultAvatar = UIImage(systemName: "person.badge.plus")!
                let downloadedAvatar = UIImage(data: data) ?? defaultAvatar
                self.userPhotoImage.image = downloadedAvatar.circleMasked
            }
        }
        if TMDBClient.Auth.username.isEmpty {
            self.userNameLabel.text = "Guest"
        } else {
            self.userNameLabel.text = TMDBClient.Auth.username
        }
        
    }
    
    @objc func logoutTapped(){
        TMDBClient.logout {
            DispatchQueue.main.async {
                let auth = AuthorizationViewController()
                if let parentNav = self.tabBarController?.navigationController {
                    parentNav.dismiss(animated: true) {
                        parentNav.pushViewController(auth, animated: true)
                        MovieModel.favorites.removeAll()
                        MovieModel.watchlist.removeAll()
                    }
                }
            }
        }
    }
    
    //MARK: - Setup UIs
    private let userPhotoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .openSans_Bold20
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var logotButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.backgroundColor = .customLightBlue
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor.customDarkBlue, for: .normal)
        button.titleLabel?.font = .openSans_SemiBold18
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    fileprivate func setupConstraints(){
        view.addSubview(userPhotoImage)
        view.addSubview(userNameLabel)
        view.addSubview(logotButton)

        userPhotoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(5)
            make.height.equalTo(120)
            make.width.equalTo(150)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userPhotoImage.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(5)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        logotButton.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).inset(-100)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
            make.height.equalTo(50)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
            
        }
    }
}
    
