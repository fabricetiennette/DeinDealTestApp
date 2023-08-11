import UIKit

public extension UIView {
    final func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}

public extension UIView {
    func fadeAnimationIn(_ duration: TimeInterval? = 0.2, onCompletion: ((Bool) -> Void)? = nil) {
        self.layer.removeAllAnimations()
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (finished: Bool) in
                        onCompletion?(finished)
        }
        )
    }

    func fadeAnimationOut(_ duration: TimeInterval? = 0.2, onCompletion: ((Bool) -> Void)? = nil) {
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (finished: Bool) in
                        self.isHidden = finished
                        onCompletion?(finished)
        })
    }
}
