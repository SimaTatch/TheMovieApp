
import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "MoviesCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    public let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var progressView: CircularProgressView = {
        var progressView = CircularProgressView(frame: CGRect(x: 5, y: 8, width: 18, height: 18), lineWidth: 3, rounded: true)
//        progressView.trackColor = .lightGray
        progressView.backgroundColor = .clear
//        progressView.progress = 0.4
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    var progressValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.font = .openSans_Regular14
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var movieTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.314, green: 0.333, blue: 0.361, alpha: 1)
        label.font = .openSans_SemiBold14
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func setupViews() {
        addSubview(cellStackView)
        cellStackView.addArrangedSubview(posterImage)
        cellStackView.addArrangedSubview(progressStackView)
        progressStackView.addArrangedSubview(progressView)
        progressStackView.addArrangedSubview(progressValueLabel)
        cellStackView.addArrangedSubview(movieTitle)
        
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(195)
        }
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(30)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(progressStackView.snp.width).multipliedBy(0.2)
            make.height.equalTo(progressStackView.snp.height)
        }
        progressValueLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(progressView.snp.right).inset(-2)
            make.right.equalTo(0)
            make.height.equalTo(progressStackView.snp.height)
        }
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(25)
        }
    }
}
