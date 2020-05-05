//
//  ATControllerBase.swift
//  Atrip
//
//  Created by jimmy on 2020/05/05.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class ATControllerBase: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false

        // MARK: Logo
        let logo = UIImage(named: "logo140.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
    }

}
