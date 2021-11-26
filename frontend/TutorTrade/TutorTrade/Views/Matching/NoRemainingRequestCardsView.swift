//
//  NoRemainingRequestCardsView.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import UIKit

internal class NoRemainingRequestCardsView: UIView {
    
    private let noCardsRemainingImage: UIImageView = .noCardsRemainingGraphic
    
    private let noCardsRemainingTitle: UILabel = .noCardsRemaingTitle
    
    private let noCardsRemainingParagraph: UILabel = .noCardsRemainingParagraph
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(noCardsRemainingImage) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
        self.addSubview(noCardsRemainingTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.noCardsRemainingImage.bottomAnchor, constant: UIScreen.main.bounds.height / 23.2),
                $0.centerXAnchor.constraint(equalTo: self.noCardsRemainingImage.centerXAnchor)
            ])
        }
        
        self.addSubview(noCardsRemainingParagraph) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.noCardsRemainingTitle.bottomAnchor, constant: UIScreen.main.bounds.height / 47.764),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
}
