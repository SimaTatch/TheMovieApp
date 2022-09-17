
import Foundation
import UIKit
import SnapKit

class CastCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "CastCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    var castName: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkBlue
        label.font = .openSans_Regular14
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var characterName: UILabel = {
        let label = UILabel()
        label.textColor = .customDarkGray
        label.font = .openSans_Regular14
        label.numberOfLines = 0
        label.textAlignment = .center
        label.minimumScaleFactor = 0.3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var castImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupViews() {
        addSubview(castImage)
        addSubview(castName)
        addSubview(characterName)
        
        castImage.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(140)
        }
        castName.snp.makeConstraints { make in
            make.top.equalTo(castImage.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(30)
        }
        characterName.snp.makeConstraints { make in
            make.top.equalTo(castName.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(25)
        }
    }
}
