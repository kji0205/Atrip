//
//  mainSwiperBannerCell.swift
//  Atrip
//
//  Created by jimmy on 2020/04/09.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class mainSwiperBannerCell: UICollectionViewCell {
    
    //부모 메서드 초기화 시켜줘야 한다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //셀에 이미지 뷰 객체를 넣어주기 위해서 생성
    let mainSwiperBannerCellImage: UIImageView = {
        let img = UIImageView()
        //자동으로 위치 정렬 금지
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    func setupView(){
        backgroundColor = .yellow
        //셀에 위에서 만든 이미지 뷰 객체를 넣어준다.
        addSubview(mainSwiperBannerCellImage)
        //제약조건 설정하기
        myImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        myImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        myImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //myImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
        //myImage.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
}
