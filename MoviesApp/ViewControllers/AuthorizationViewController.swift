
import UIKit
import SnapKit

//protocol AuthorizationVCDelegate: AnyObject {
//    func avatarImage(image: UIImage)
//}

class AuthorizationViewController: UIViewController {

    var movieDict: [String:[Movie]]?

    
//    weak var delegate: AuthorizationVCDelegate? // HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .customDarkBlue
        setupViews()
        loginSegmentControl.addUnderlineForSelectedSegment()
        
        DispatchQueue.main.async {
            TMDBClient.getPopular { movies, error in
                MovieModel.popular = movies
            }
            TMDBClient.getTopRated { movies, error in
                MovieModel.topRated = movies
            }
            TMDBClient.getNowPlaying { movies, error in
                MovieModel.nowPlaying = movies
            }
            TMDBClient.getTrending { movies, error in

//                for movie in movies {
//                    if ((self.movieDict?.keys.contains(movie.mediaType ?? "")) != nil) {
//                        self.movieDict![movie.mediaType ?? ""]?.append(movie)
//                    } else {
//                        self.movieDict?.updateValue(movie, forKey: movie.mediaType ?? "")
//                    }
//                }
//                let groupedCurrencyKey = Dictionary(grouping: self, by: {String($0.prefix(1))})
                MovieModel.trending = movies
            }
        }
    }
    
    @objc func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
    }

    // MARK:
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
//            print(TMDBClient.Auth.requestToken)
            TMDBClient.login(username: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
        } else {
//            print("Not Successful!")
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }

    func handleLoginResponse(success: Bool, error: Error?) {
//        print(TMDBClient.Auth.requestToken)
        if success {
            TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }

    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            TMDBClient.accountDetails(completion: handleAccountDetailsResponse(success:error:))

        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleAccountDetailsResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            let tabBar = TabBarController()
            self.navigationController?.pushViewController(tabBar, animated: true)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        userNameTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        remindMeLaterButton.isEnabled = !loggingIn
    }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.setLoggingIn(false)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - UI
    let activityIndicator: UIActivityIndicatorView = {
        let activityIn = UIActivityIndicatorView(style: .white)
        activityIn.translatesAutoresizingMaskIntoConstraints = false
        return activityIn
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome."
        label.textColor = .white
        label.font = .openSans_ExtraBold42
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.3
        label.text = "Millions of movies, TV shows and people to discover."
        label.textColor = .white
        label.font = .openSans_Regular24
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginSegmentControl: UISegmentedControl = {
         let buyOrSellItems = ["Login","Sign Up"]
         let segmentControl = UISegmentedControl(items: buyOrSellItems)
         segmentControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
         segmentControl.selectedSegmentIndex = 0
         segmentControl.translatesAutoresizingMaskIntoConstraints = false
         return segmentControl
     }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = .white
        label.font = .openSans_SemiBold14
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .openSans_Regular20
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.customDarkBlue.cgColor
        textField.backgroundColor = .specialLightGray
        let padding: CGFloat = 10.0
        textField.setPadding(left: padding, right: padding)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .white
        label.font = .openSans_SemiBold14
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .openSans_Regular20
        textField.backgroundColor = .specialLightGray
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.customDarkBlue.cgColor
        textField.backgroundColor = .specialLightGray
        let padding: CGFloat = 10.0
        textField.setPadding(left: padding, right: padding)
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.backgroundColor = .customLightBlue
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.customDarkBlue, for: .normal)
        button.titleLabel?.font = .openSans_SemiBold18
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var remindMeLaterButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(remindMeLaterPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitle("Remind Me Later", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .openSans_SemiBold18
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - UISegmentControl Implementation
    @objc func indexChanged(_ segmentControl: UISegmentedControl) {
        segmentControl.changeUnderlinePosition()
        switch segmentControl.selectedSegmentIndex {
        case 0:
            refreshTextFields()
            break
        case 1:
            refreshTextFields()
            break
        default:
            break
        }
    }
    
    //MARK: - UITextFields' Implementation   
    func textFieldPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTextField.frame.height))
        self.passwordTextField.leftView = paddingView
        self.passwordTextField.leftViewMode = UITextField.ViewMode.always
        self.userNameTextField.leftView = paddingView
        self.userNameTextField.leftViewMode = UITextField.ViewMode.always
    }
    
    func refreshTextFields() {
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    //MARK: - UIButton Implementation
    @objc func remindMeLaterPressed(_ sender: UIButton) {
        let tabBar = TabBarController()
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
    //MARK: - SetupViews And Constraints
    private func setupViews() {
        view.addSubview(movieStackView)
        movieStackView.addArrangedSubview(welcomeLabel)
        movieStackView.addArrangedSubview(descriptionLabel)
        movieStackView.addArrangedSubview(loginSegmentControl)
        movieStackView.addArrangedSubview(userNameLabel)
        movieStackView.addArrangedSubview(userNameTextField)
        movieStackView.addArrangedSubview(passwordLabel)
        movieStackView.addArrangedSubview(passwordTextField)
        movieStackView.addArrangedSubview(loginButton)
        movieStackView.addArrangedSubview(remindMeLaterButton)
        view.addSubview(activityIndicator)
        
        movieStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(70)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-100)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
//            make.width.equalTo(335)
            make.height.equalTo(58)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).inset(-6)
            make.left.right.equalTo(0)
//            make.width.equalTo(335)
            make.height.equalTo(60)
        }
        loginSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).inset(-6)
            make.left.right.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(55)
//            make.width.equalTo(343)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(loginSegmentControl.snp.bottom).inset(-16)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(22)
        }
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).inset(-4)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(52)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).inset(-16)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(22)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).inset(-4)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(52)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).inset(-20)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(42)
        }
        remindMeLaterButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).inset(-20)
            make.left.right.equalTo(0)
//            make.width.equalTo(343)
            make.height.equalTo(33)
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(movieStackView.snp.bottom).inset(-5)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(30)
        }
    }
}

