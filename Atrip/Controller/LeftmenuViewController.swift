//
//  LeftmenuViewController.swift
//  Atrip
//
//  Created by jimmy on 2020/04/05.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class LeftmenuViewController: ATControllerBase {

    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        dismiss(animated: true, completion: {
//            print("Dismissing: \(MenuType)")
//        })
        
        let buttonWidth = CGFloat(30)
        let buttonHeight = CGFloat(30)

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "hamburger"), for: .normal)
//        button.addTarget(self, action: #selector(leftMenu), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
