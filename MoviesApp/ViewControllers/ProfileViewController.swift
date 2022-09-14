
import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        setupConstraints()
    }
    
    private let userPhotoImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
//        imageView.layer.borderWidth = 5
//        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .specialGray
        label.font = .openSans_Regular20
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
    
    fileprivate func setupConstraints(){
        view.addSubview(userPhotoImage)
        view.addSubview(userNameLabel)

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
    }
}
    
