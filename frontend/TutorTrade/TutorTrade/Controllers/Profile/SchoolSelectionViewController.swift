//
//  SchoolSelectionViewController.swift
//  TutorTrade
//
//  Created by brock davis on 10/25/21.
//

import UIKit

class SchoolSelectionViewController: UIViewController {
    
    var schoolTextField : UITextField!
    var popoverView: UIView!
    var popoverExitButton: UIButton!
    var outOfBoundsExitButton: UIButton!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    convenience init() {
        self.init(viewFactory: DefaultSchoolSelectionViewFactory())
    }
    
    init(viewFactory: SchoolSelectionViewFactory) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
        self.outOfBoundsExitButton.backgroundColor = UIColor(named: "ModalBackgroundOverlay")!
        }
    }
    

    
    override func loadView() {
        super.loadView()
        
        self.outOfBoundsExitButton = UIButton(frame: self.view.bounds)
        self.outOfBoundsExitButton.addTarget(self, action: #selector(exitPopover), for: .touchUpInside)
        self.outOfBoundsExitButton.backgroundColor = .clear
        self.view.addSubview(self.outOfBoundsExitButton)
        
        popoverView = UIView(frame: CGRect(x: 5, y: UIScreen.main.bounds.height * 2/3, width: UIScreen.main.bounds.width - 10, height: (UIScreen.main.bounds.height / 3) - 5))
        popoverView.backgroundColor = .white
        popoverView.layer.cornerRadius = 45
        self.view.addSubview(popoverView)
        
        self.popoverExitButton = UIButton()
        self.popoverExitButton.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.popoverExitButton.center = popoverView.bounds.center.applying(.init(translationX: 145, y: -100))
        self.popoverExitButton.layer.cornerRadius = self.popoverExitButton.bounds.width / 2
        self.popoverExitButton.backgroundColor = .lightGray
        self.popoverExitButton.setBackgroundImage(UIImage(named: "ExitIcon")!, for: .normal)
        self.popoverExitButton.addTarget(self, action: #selector(exitPopover), for: .touchUpInside)
        self.popoverView.addSubview(popoverExitButton)
        
        schoolTextField = UITextField()
        schoolTextField.backgroundColor = .lightGray
        schoolTextField.text = "Enter school"
        schoolTextField.frame = CGRect(x: 75, y: 100, width: 200, height: 40)
        self.popoverView.addSubview(schoolTextField)
        
    }
    
    @objc func exitPopover() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
            self.outOfBoundsExitButton.backgroundColor = .clear
        } completion: { _ in
            self.presentingViewController!.dismiss(animated: true)
        }
    }

}
