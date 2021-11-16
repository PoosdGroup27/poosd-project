import UIKit

extension UIView {
    static var matchingPageTitleContainerView: UIView {
        get {
            let titleContainer = UIView()
            titleContainer.backgroundColor = UIColor(named: "MatchingPageColor")!
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
            return titleContainer
        }
    }
}

extension UIButton {
    static var undoButton: UIButton {
        get {
            let button = UIButton()
            button.setImage(UIImage(named: "UndoIcon")!, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }
}

extension UIImageView {
    
    static var matchingTitleImage: UIImageView {
        get {
            let imageView = UIImageView(image: UIImage(named: "MatchingLogoImage")!)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
}
