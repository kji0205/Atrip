//
//  HashTagCollectionViewCell.swift
//  Atrip
//
//  Created by jimmy on 2020/05/03.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class HashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    static let identifier = "HashTagCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
//        contentView.backgroundColor = .orange
//        title.preferredMaxLayoutWidth = 120
        title.numberOfLines = 1

        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: title.topAnchor).isActive = true
        contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: title.bottomAnchor).isActive = true

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HashTagCollectionViewCell", bundle: nil)
    }
    
    var data: MainScreenDataHashTag? {
        didSet {
            guard let data = self.data else { return }
            self.title.text = data.text
            self.title.sizeToFit()
            self.title.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
             self.title.isUserInteractionEnabled = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc func imageTapped(_ img: AnyObject) {
        guard let url = URL(string: data?.link ?? "") else { return }
        tapAction(url: url)
    }
    
    weak var delegate: CollectionViewCellDelegate?

    func tapAction(url: URL) {
        if let del = self.delegate {
            del.didTapCell(url: url)
        }
    }
}
