//
//  TutteeRequestCardConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

import UIKit

extension UILabel {
    static func configureTutteeName(withFirstName firstName: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = firstName
        label.font = font
        return label
    }
}

extension UIImageView {
    static func configureTuteeProfileImage(withImage image: UIImage?) -> UIImageView {
        let image = image ?? UIImage(named: "UserImage")!
        let photoView = UIImageView(image: image)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
}
