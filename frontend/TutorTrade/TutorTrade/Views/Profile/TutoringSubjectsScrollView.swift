//
//  TutoringSubjectsScrollView.swift
//  TutorTrade
//
//  Created by brock davis on 10/12/21.
//

import UIKit

class TutoringSubjectsScrollView: UIScrollView {
    
    enum SubjectState {
        case selected
        case unselected
    }
    
    let tutoringSubjects : [String]
    
    var selectedTutoringSubjects : Set<String>
    
    var selectionObserver : ((String, TutoringSubjectsScrollView.SubjectState) -> ())?
    
    var stackViews: [UIStackView]
    
    private let selectedButtonStrokeColor = UIColor(named: "SelectedSubjectBorderColor")!
    
    private let selectedButtonFillColor = UIColor(named: "SelectedSubjectFillColor")!
    
    private let unselectedButtonStrokeColor = UIColor.black
    
    private let unselectedButtonFillColor = UIColor.white
    
    private let subjectButtonFont = UIFont(name: "Roboto-Bold", size: 14)!
    
    internal init(tutoringSubjects: [String], selectedTutoringSubjects: Set<String>?, selectionObserver: ((String, TutoringSubjectsScrollView.SubjectState) -> ())? = nil) {
        
        self.tutoringSubjects = tutoringSubjects
        self.selectedTutoringSubjects = selectedTutoringSubjects ?? []
        self.selectionObserver = selectionObserver
        self.stackViews = Self.createStackViews(count: 3)
        
        super.init(frame: .zero)
        self.showsHorizontalScrollIndicator = false
        
        stackViews.forEach { self.addSubview($0) }
        
        let parititions = partitionSubjects(partitions: 3, subjects: tutoringSubjects)
        
        
        var stackViewIndex = 0
        var rowWidths: [UIStackView : CGFloat] = [:]
        stackViews.forEach { rowWidths[$0] = 0 }
        
        for paritition in parititions {
            for subject in paritition {
                let subjectButton = createSubjectButton(subjectName: subject, state: self.selectedTutoringSubjects.contains(subject) ? .selected : .unselected)
                rowWidths[stackViews[stackViewIndex]]! += subjectButton.bounds.width + 7
                stackViews[stackViewIndex].addArrangedSubview(subjectButton)
            }
            stackViewIndex += 1
        }
        
        setupViewLayout(rowWidths: rowWidths)
    }
    
    private func partitionSubjects(partitions partitionCount: Int, subjects: [String]) -> [[String]] {
        let totalWeight = subjects.reduce(0) { result, currentString in
            result + currentString.count
        }
        let parititionWeight = totalWeight / partitionCount
        
        var partitions : [[String]] = []
        var subjectIndex = 0
        
        for i in 0..<partitionCount {
            var combinedWeight = 0
            partitions.append([])
            while (combinedWeight + subjects[subjectIndex].count) <= parititionWeight && subjectIndex < subjects.count {
                partitions[i].append(subjects[subjectIndex])
                combinedWeight += subjects[subjectIndex].count
                subjectIndex += 1
            }
        }
        
        var i = 0
        while subjectIndex < subjects.count {
            partitions[i % 2].append(subjects[subjectIndex])
            subjectIndex += 1
            i += 1
        }
        return partitions
    }
    
    private func setupViewLayout(rowWidths: [UIStackView : CGFloat]) {
        
        var maxWidthStackView : UIStackView = stackViews[0]
        var previousStackView : UIStackView? = nil
        for stackView in stackViews {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: previousStackView?.bottomAnchor ?? self.contentLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
                stackView.widthAnchor.constraint(equalToConstant: rowWidths[stackView]!),
                stackView.heightAnchor.constraint(equalToConstant: 50)
            ])
            previousStackView = stackView
            maxWidthStackView = (rowWidths[maxWidthStackView]! > rowWidths[stackView]!) ? maxWidthStackView : stackView
        }
        
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: maxWidthStackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: previousStackView!.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private static func createStackViews(count: Int) -> [UIStackView] {
        var stackViews : [UIStackView] = []
        for _ in 0..<count {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackViews.append(stackView)
        }
        return stackViews
    }
    
    private func createSubjectButton(subjectName: String, state: SubjectState) -> UIButton {
        let subjectButton = UIButton()
        subjectButton.setTitle(subjectName, for: .normal)
        subjectButton.setTitleColor(.black, for: .normal)
        subjectButton.titleLabel!.font = subjectButtonFont
        subjectButton.sizeToFit()
        subjectButton.bounds = CGRect(x: 0, y: 0, width: subjectButton.bounds.width + 20, height: subjectButton.bounds.height + 10)
        subjectButton.setBackgroundImage(drawButtonImage(size: subjectButton.bounds.size, state: .unselected), for: .normal)
        subjectButton.setBackgroundImage(drawButtonImage(size: subjectButton.bounds.size, state: .selected), for: .selected)
        if state == .selected {
            subjectButton.isSelected = true
        }
        subjectButton.addTarget(self, action: #selector(subjectButtonTapped(sender:)), for: .touchUpInside)
        return subjectButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    @objc func subjectButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
        selectedTutoringSubjects.update(with: sender.title(for: .normal)!)
        selectionObserver?(sender.currentTitle!, (sender.isSelected) ? .selected : .unselected)
    }
    
    private func drawButtonImage(size: CGSize, state: SubjectState) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            let borderPath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2), cornerRadius: 20.0).cgPath
            switch state {
            case .selected:
                context.setStrokeColor(selectedButtonStrokeColor.cgColor)
                context.setFillColor(selectedButtonFillColor.cgColor)
            case .unselected:
                context.setStrokeColor(unselectedButtonStrokeColor.cgColor)
                context.setFillColor(unselectedButtonFillColor.cgColor)
            }
            context.addPath(borderPath)
            context.drawPath(using: .fillStroke)
        }
    }
    
    
    
}
