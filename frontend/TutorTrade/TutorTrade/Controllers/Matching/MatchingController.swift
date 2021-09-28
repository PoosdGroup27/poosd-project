//
//  MatchingController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class MatchingController: UIViewController {
<<<<<<< HEAD
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Matching"
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
=======

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Matching"
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

>>>>>>> main
}
