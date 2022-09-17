
import Foundation
import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var movieTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.314, green: 0.333, blue: 0.361, alpha: 1)
        label.font = .openSans_SemiBold14
        label.minimumScaleFactor = 0.3
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var movieDescrip: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.314, green: 0.333, blue: 0.361, alpha: 1)
        label.font = .openSans_Regular14
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public let titleAndDescripStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setupConstraints() {
        addSubview(posterImage)
        addSubview(titleAndDescripStackView)
        titleAndDescripStackView.addArrangedSubview(movieTitle)
        titleAndDescripStackView.addArrangedSubview(movieDescrip)
        
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
            make.bottom.equalTo(0)
        }
        titleAndDescripStackView.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(posterImage.snp.right).inset(-5)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
        }
        movieDescrip.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).inset(-3)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}
