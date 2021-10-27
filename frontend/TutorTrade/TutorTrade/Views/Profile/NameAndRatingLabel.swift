//
//  TutorNameAndRatingLabel.swift
//  TutorTrade
//
//  Created by brock davis on 10/12/21.
//

import UIKit

class NameAndRatingLabel: UILabel {

    private static let ratingIcon : UIImage = UIImage(named: "RatingIcon")!
    
    override var bounds: CGRect {
        didSet {
            self.layer.cornerRadius = self.bounds.width / 2
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
    

    private var firstNameRange : NSRange
    var firstName : String {
        get {
            self.attributedText!.attributedSubstring(from: firstNameRange).string
        }
        set {
            (self.attributedText! as! NSMutableAttributedString).replaceCharacters(in: firstNameRange, with: newValue)
        }
    }
    
    private var lastNameRange : NSRange
    var lastName : String {
        get {
            self.attributedText!.attributedSubstring(from: lastNameRange).string
        }
        set {
            (self.attributedText! as! NSMutableAttributedString).replaceCharacters(in: lastNameRange, with: newValue)
        }
    }
    
    private var ratingRange : NSRange
    var rating : Double {
        get {
            Double(self.attributedText!.attributedSubstring(from: ratingRange).string)!
        }
        set {
            (self.attributedText! as! NSMutableAttributedString).replaceCharacters(in: ratingRange, with: String(newValue))
        }
    }

    internal init(firstName: String, lastName: String, rating: Double, font: UIFont = .systemFont(ofSize: 17), lineSpacing: CGFloat = 8) {
        
        let ratingAttachment = NSTextAttachment(image: Self.ratingIcon)
        ratingAttachment.bounds = CGRect(x: 0, y: -font.lineHeight / 7, width: font.lineHeight, height: font.lineHeight)
        
        let firstName = NSAttributedString(string: firstName)
        let lastName = NSAttributedString(string: lastName)
        let rating = NSAttributedString(string: String(rating))
        
        self.firstNameRange = NSRange(location: 0, length: firstName.length)
        self.lastNameRange = NSRange(location: firstNameRange.length + 1, length: lastName.length)
        self.ratingRange = NSRange(location: lastNameRange.location + lastNameRange.length + 3, length: rating.length)
        
        super.init(frame: .zero)
        
        let attributedString = NSMutableAttributedString(attributedString: firstName)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(lastName)
        attributedString.append(NSAttributedString(string: "\n  "))
        attributedString.append(rating)
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(attachment: ratingAttachment))
        
        self.font = font
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttributes([.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
        self.numberOfLines = 3
        self.textAlignment = .center
    
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

}
