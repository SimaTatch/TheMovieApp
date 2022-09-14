
import UIKit

extension UIButton {

    func customButtonExtension() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.specialLightGray.cgColor
        self.titleLabel?.font = .openSans_Regular16
        self.titleLabel?.minimumScaleFactor = 0.3
        self.tintColor = .someDarkBlue
        self.titleEdgeInsets = UIEdgeInsets(top: 25, left: -18, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -25, left: 32, bottom: 0, right: -30)
    }
}
