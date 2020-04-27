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
                    self.setMainBannerImage(mainScreenDataBanner: mainScreenData.mainSwiper)
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

            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainBannerScrollView.frame.width, height: self.mainBannerScrollView.frame.height)
            
            mainBannerScrollView.contentSize.width = mainBannerScrollView.frame.width * CGFloat(i + 1)
            mainBannerScrollView.addSubview(imageView)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
