//
//  ATMainViewController.swift
//  Atrip
//
//  Created by jimmy on 2020/04/26.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class ATMainViewController: UIViewController {
 
    @IBOutlet weak var mainBannerScrollView: UIScrollView!
    @IBOutlet weak var mainTipView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - fetch data
        do {
            let data = try fetchMainScreenData()
            let s = String(decoding: data!, as: UTF8.self)
//            print("Data:", s)
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
        
        
    }
    
    enum NetworkError: Error {
        case url
        case statusCode
        case standard
    }
    
    func fetchMainScreenData() throws -> Data? {
        guard let url = URL(string: API_URL_MAIN) else {
            throw NetworkError.url
        }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        // Semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (d, r, e) in
            data = d
            response = r
            error = e
            guard let data = data else { return }
            
            do {
                let mainScreenData = try JSONDecoder().decode(MainScreenDataModel.self, from: data)
//                print(mainScreenData)
                
                DispatchQueue.main.async {
                    // 스크롤 배너
                    self.setMainBannerImage(mainScreenDataBanner: mainScreenData.mainSwiper)
                    // 팁
                    self.makeMainTipView(mainTip: mainScreenData.mainTip)
                }

            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode > 300 {
            throw NetworkError.statusCode
        }
        if error != nil {
            throw NetworkError.standard
        }
        
        return data
    }
    
    func setMainBannerImage(mainScreenDataBanner data: [MainScreenDataBanner]) {
        var imageArray = [MainScreenDataBanner]()
        
        imageArray = data
//        mainBannerScrollView.frame = self.view.frame
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageArray[i].imgurl)
            let url = URL(string: imageArray[i].imgurl)
            do {
                let data = try Data(contentsOf: url!)
                imageView.image = UIImage(data: data)
            } catch  {
                
            }

            imageView.contentMode = .scaleAspectFill
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainBannerScrollView.frame.width, height: self.mainBannerScrollView.frame.height)
            
            mainBannerScrollView.contentSize.width = mainBannerScrollView.frame.width * CGFloat(i + 1)
            mainBannerScrollView.addSubview(imageView)
        }
        
    }
    
    // 팁 영역
    func makeMainTipView(mainTip data: MainTip?) {
        guard let mainTipData = data else { return print("no data") }
//        print(mainTipData)
        
        // MARK: maintip label
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect(x: 0, y: 0, width: mainTipView.frame.width, height: mainTipView.frame.height * 0.2)
//        titleLabel.text = mainTipData.titlename
//        mainTipView.addSubview(titleLabel)
        
        let mainTipImageStackView = UIStackView()
        
        mainTipImageStackView.axis = .horizontal
        mainTipImageStackView.distribution = .equalSpacing
        mainTipImageStackView.alignment = .center
        mainTipImageStackView.spacing = 10.0
        mainTipImageStackView.backgroundColor = .blue
        
        
        mainTipImageStackView.translatesAutoresizingMaskIntoConstraints = false

        
        for i in 0..<mainTipData.data.count {
//        for i in 0..<2 {
            let imageArray = mainTipData.data
            let imageView = UIImageView()
            
            imageView.image = UIImage(named: imageArray[i].imgurl)
            let url = URL(string: imageArray[i].imgurl)
            do {
                let data = try Data(contentsOf: url!)
                imageView.image = UIImage(data: data)
            } catch  {
                
            }

            imageView.contentMode = .scaleAspectFit
//            let xPosition = mainTipImageStackView.frame.width * CGFloat(i)
//            imageView.frame = CGRect(x: xPosition, y: 0, width: mainTipImageStackView.frame.width, height: mainTipImageStackView.frame.height)
            
//            mainTipImageStackView.contentSize.width = mainTipImageStackView.frame.width * CGFloat(i + 1)
            mainTipImageStackView.addArrangedSubview(imageView)
        }
        
        mainTipView.addSubview(mainTipImageStackView)
        
        mainTipImageStackView.centerXAnchor.constraint(equalTo: mainTipView.centerXAnchor).isActive = true
        mainTipImageStackView.centerYAnchor.constraint(equalTo: mainTipView.centerYAnchor).isActive = true

        mainTipImageStackView.arrangedSubviews[0].heightAnchor.constraint(equalTo: mainTipImageStackView.arrangedSubviews[0].widthAnchor).isActive = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
