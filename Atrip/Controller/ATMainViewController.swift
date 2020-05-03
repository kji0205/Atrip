//
//  ATMainViewController.swift
//  Atrip
//
//  Created by jimmy on 2020/04/26.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class ATMainViewController: UIViewController {
    
    @IBOutlet weak var mainSwiperScrollView: UIScrollView!
    @IBOutlet weak var mainTipView: UIView!
    @IBOutlet weak var mainTipCollectionView: UICollectionView!
    @IBOutlet weak var hashTag: UICollectionView!
    @IBOutlet weak var mainBannerScrollView: UIScrollView!
    
    fileprivate var mainTipData: MainTip? {
        didSet {
            self.mainTipCollectionView.reloadData()
        }
    }
    
    fileprivate var mainTipHashTag: [MainScreenDataHashTag]? {
        didSet {
            self.hashTag.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTipCollectionView.delegate = self
        self.mainTipCollectionView.dataSource = self
        // Set the collection view's prefetching data source.
        //        self.mainTipCollectionView.prefetchDataSource = dataSource
        //        self.mainTipCollectionView.reloadData()
        
        // MARK: - fetch data
        do {
            try fetchMainScreenData()
            //            let s = String(decoding: data!, as: UTF8.self)
            //            print("Data:", s)
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
        
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
                    self.setMainBannerSwiperImage(mainScreenDataBanner: mainScreenData.mainSwiper)
                    // 팁
                    self.makeMainTipView(mainTip: mainScreenData.mainTip)
                    // 해시태그
                    self.setHashTagView(hashTag: mainScreenData.mainHashtag)
                    // 스크롤 배너 2
                    self.setMainBannerImage(mainScreenDataBanner: mainScreenData.mainBanner)
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
    
    func setMainBannerSwiperImage(mainScreenDataBanner data: [MainScreenDataBanner]) {
        var imageArray = [MainScreenDataBanner]()
        
        imageArray = data
        
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            //            imageView.image = UIImage(named: imageArray[i].imgurl)
            let url = URL(string: imageArray[i].imgurl)
            do {
                let data = try Data(contentsOf: url!)
                imageView.image = UIImage(data: data)
            } catch  {
                
            }
            
            imageView.contentMode = .scaleAspectFill
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainSwiperScrollView.frame.width, height: self.mainSwiperScrollView.frame.height)
            
            mainSwiperScrollView.contentSize.width = mainSwiperScrollView.frame.width * CGFloat(i + 1)
            mainSwiperScrollView.addSubview(imageView)
        }
        
    }
    
    // 메인 배너
    func setMainBannerImage(mainScreenDataBanner data: MainScreenDataBanner?) {
        
        guard let bannerData = data else { return }
        
        let imageView = UIImageView()
//        imageView.downloaded(from: bannerData.imgurl)
        let url = URL(string: bannerData.imgurl)
        do {
            let data = try Data(contentsOf: url!)
            imageView.image = UIImage(data: data)
        } catch  {
            
        }
        
        imageView.contentMode = .scaleAspectFill
        
        let xPosition = self.view.frame.width * CGFloat(0)
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainBannerScrollView.frame.width, height: self.mainBannerScrollView.frame.height)
        
        mainBannerScrollView.contentSize.width = mainBannerScrollView.frame.width
        mainBannerScrollView.addSubview(imageView)
    }
    
    // 팁 영역
    func makeMainTipView(mainTip data: MainTip?) {
        //        guard let mainTipData = data else { return print("no data") }
        mainTipData = data
    }
    
    // 해시태그
    func setHashTagView(hashTag data: [MainScreenDataHashTag]) {
        self.mainTipHashTag = data
        //        print(data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ATMainViewController: UICollectionViewDelegate {
    
}


//extension ATMainViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let model = models[indexPath.row]
//            asyncFetcher.fetchAsync(model.identifier)
//        }
//    }
//}

extension ATMainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainTipCollectionView  {
            return mainTipData?.data.count ?? 0
        } else if collectionView == self.hashTag {
            return mainTipHashTag?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.mainTipCollectionView  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTipCollectionViewCell", for: indexPath) as! MainTipCollectionViewCell
            //        cell.backgroundColor = .red
            
            if let hasData = mainTipData?.data {
                if hasData.count > 0 {
                    cell.data = hasData[indexPath.row]
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
            
            if let hasData = mainTipHashTag {
                if hasData.count > 0 {
                    cell.data = hasData[indexPath.row]
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.mainTipCollectionView  {
            return CGSize(width: mainTipCollectionView.frame.width / 2.1, height: mainTipCollectionView.frame.height / 2.1)
        } else {
            return CGSize(width: hashTag.frame.width / 2.1, height: hashTag.frame.height / 2.1)
            //            let text = mainTipHashTag?[indexPath.row].text ?? ""
            //            let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 17)).width
            //            return CGSize(width: width, height: 50.0)
            //
        }
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 300, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    
}

