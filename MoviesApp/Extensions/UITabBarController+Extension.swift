
import UIKit

extension UITabBarController {
    
    func addSubviewToLastTabItem(_ image: UIImage) {

        if let lastTabBarButton = self.tabBar.subviews.last, let tabItemImageView = lastTabBarButton.subviews.first {
            let imgView = UIImageView()
            imgView.frame = tabItemImageView.frame
            imgView.layer.cornerRadius = tabItemImageView.frame.height/2
            imgView.layer.masksToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.image = image
            if let lastSubview = self.tabBar.subviews.last,
               let lastImageView = lastSubview.subviews.compactMap({ $0 as? UIImageView }).first,
               let lastLabel = lastSubview.subviews.compactMap({ $0 as? UILabel }).first
            {
                self.tabBar.subviews.last?.addSubview(imgView)
                imgView.snp.makeConstraints { make in
                    make.centerY.centerY.equalTo(lastImageView)
                    make.leading.trailing.equalTo(lastLabel)
                    make.top.bottom.equalTo(lastImageView)
                }
                lastImageView.isHidden = true
            }
            
        }
    }
}


