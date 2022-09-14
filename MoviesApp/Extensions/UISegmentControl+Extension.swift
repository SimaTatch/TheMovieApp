
import UIKit

extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        removeDividerLine()
        self.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.openSans_SemiBold28!, NSAttributedString.Key.foregroundColor: UIColor.customLightBlue], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.openSans_SemiBold28!, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    func removeDividerLine() {
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.clear.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 3.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height + 20.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.white
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

//class SegmentedControl: UISegmentedControl {
//    override func layoutSubviews() {
//      super.layoutSubviews()
//      layer.cornerRadius = self.bounds.size.height / 2.0
//      layer.borderColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0).cgColor
//      layer.borderWidth = 1.0
//      layer.masksToBounds = true
//
//      clipsToBounds = true
//   }
//}

class OYSegmentControl: UISegmentedControl{
  
  override func layoutSubviews(){
      
    super.layoutSubviews()
    let segmentStringSelected: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.openSans_SemiBold14 as Any,
      NSAttributedString.Key.foregroundColor : UIColor.black
    ]
    
    let segmentStringHighlited: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont.openSans_Regular14 as Any,
      NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    ]
    
    setTitleTextAttributes(segmentStringHighlited, for: .normal)
    setTitleTextAttributes(segmentStringSelected, for: .selected)
    setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
      
    layer.masksToBounds = true
    
    if #available(iOS 13.0, *) {
      selectedSegmentTintColor = #colorLiteral(red: 0, green: 0.861200273, blue: 0.67304039, alpha: 1)
    } else {
      tintColor = #colorLiteral(red: 0, green: 0.861200273, blue: 0.67304039, alpha: 1)
    }
    
      backgroundColor = .clear
    
    //corner radius
      let cornerRadius = bounds.height / 2
    let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    //background
    clipsToBounds = true
      layer.cornerRadius = CGFloat(cornerRadius)
    layer.maskedCorners = maskedCorners
    layer.borderWidth = 1
    layer.borderColor = UIColor(red: 0.353, green: 0.784, blue: 0.98, alpha: 1).cgColor

    let foregroundIndex = numberOfSegments
    if subviews.indices.contains(foregroundIndex),
      let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
      foregroundImageView.image = UIImage()
      foregroundImageView.clipsToBounds = true
      foregroundImageView.layer.masksToBounds = true
        let layer1 = CAGradientLayer()
        layer1.colors = [
          UIColor(red: 0.565, green: 0.808, blue: 0.631, alpha: 1).cgColor,
          UIColor(red: 0.235, green: 0.745, blue: 0.788, alpha: 1).cgColor
        ]
        layer1.locations = [0, 1]
        layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.frame =  foregroundImageView.frame
        layer1.position = foregroundImageView.center
        foregroundImageView.layer.insertSublayer(layer1, at: 0)
        foregroundImageView.layer.cornerRadius = bounds.height / 2 + 5
      foregroundImageView.layer.maskedCorners = maskedCorners
    }
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}


