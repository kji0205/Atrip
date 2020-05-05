//
//  ATMainViewController.swift
//  Atrip
//
//  Created by jimmy on 2020/04/26.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit
import SafariServices

class ATMainViewController: ATControllerBase {
    
    // 메인메뉴
    @IBOutlet weak var mainMenuSurf: UIImageView!
    @IBOutlet weak var mainMenuBus: UIImageView!
    @IBOutlet weak var mainMenuBbq: UIImageView!
    @IBOutlet weak var mainMenuTent: UIImageView!
    @IBOutlet weak var mainMenuBed: UIImageView!
    @IBOutlet weak var mainMenuFood: UIImageView!
    
    @IBOutlet weak var mainSwiperScrollView: UIScrollView!
    @IBOutlet weak var mainTipView: UIView!
    @IBOutlet weak var mainTipTitle: UILabel!
    @IBOutlet weak var mainTipCollectionView: UICollectionView!
    @IBOutlet weak var hashTag: UICollectionView!
    @IBOutlet weak var mainBannerScrollView: UIScrollView!
    @IBOutlet weak var planshopCV: UICollectionView!
    @IBOutlet weak var planshopTitle: UILabel!
    
    fileprivate var mainTipData: MainTip? {
        didSet {
            self.mainTipTitle.text = mainTipData?.titlename
            self.mainTipCollectionView.reloadData()
        }
    }
    
    fileprivate var mainTipHashTag: [MainScreenDataHashTag]? {
        didSet {
            self.hashTag.reloadData()
        }
    }
    
    fileprivate var mainPlanshopData: MainPlan? {
        didSet {
            self.planshopTitle.text = mainPlanshopData?.titlename
            self.planshopCV.reloadData()
        }
    }
    
    let columnLayout = FlowLayout(
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    
    private let planshopSectionInsets = UIEdgeInsets(top: 0.0,
    left: 0.0,
    bottom: 0.0,
    right: 0.0)
    private let planshopItemsPerRow: CGFloat = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Left Side Menu Button
        let buttonWidth = CGFloat(30)
        let buttonHeight = CGFloat(30)

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "hamburger"), for: .normal)
        button.addTarget(self, action: #selector(leftMenu), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        // MARK: Main Menu Tab
//        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedSurf(_:)))
//        mainMenuSurf.isUserInteractionEnabled = true
//        mainMenuSurf.addGestureRecognizer(tabGestureRecognizer)
        mainMenuSurf.onClick {
            guard let url = URL(string: "https://actrip.co.kr/surf") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        mainMenuBus.onClick {
            guard let url = URL(string: "https://actrip.co.kr/surfbus") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        mainMenuBbq.onClick {
            guard let url = URL(string: "https://actrip.co.kr/bbq") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        mainMenuTent.onClick {
            guard let url = URL(string: "https://actrip.co.kr/camp") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        mainMenuBed.onClick {
            guard let url = URL(string: "https://actrip.co.kr/staylist") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        mainMenuFood.onClick {
            guard let url = URL(string: "https://actrip.co.kr/eaylist") else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        
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
        
        hashTag?.collectionViewLayout = columnLayout
        hashTag?.contentInsetAdjustmentBehavior = .always
        
    }
    
    // API Call - 메인화면 데이터
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
                    // 기획전
                    self.setPlanshop(planshopData: mainScreenData.mainPlan)
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
        
        for i in 0..<data.count {
            let imageView = UIImageView()
            
            imageView.downloaded(from: data[i].imgurl, contentMode: .scaleAspectFill)
            imageView.onClick {
                guard let url = URL(string: data[i].link) else { return }
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true, completion: nil)
            }
            
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
        imageView.downloaded(from: bannerData.imgurl, contentMode: .scaleAspectFill)
        imageView.onClick {
            guard let url = URL(string: bannerData.link) else { return }
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        }
        
        let xPosition = self.view.frame.width * CGFloat(0)
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainBannerScrollView.frame.width, height: self.mainBannerScrollView.frame.height)
        
        mainBannerScrollView.contentSize.width = mainBannerScrollView.frame.width
        mainBannerScrollView.addSubview(imageView)
    }
    
    // 팁 영역
    func makeMainTipView(mainTip data: MainTip?) {
        mainTipData = data
    }
    
    // 해시태그
    func setHashTagView(hashTag data: [MainScreenDataHashTag]) {
        self.mainTipHashTag = data
    }
    
    // 기획전
    func setPlanshop(planshopData data: MainPlan?) {
        mainPlanshopData = data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        hashTag?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    @objc func leftMenu(_ sender: Any) {
        print("left menu")
//        self.navigationController?.pushViewController(LeftmenuViewController(), animated: false)
//        let lefeMenuController = LeftmenuViewController()
//        self.present(lefeMenuController, animated: true, completion: nil)
//        let vc: LeftmenuViewController = LeftmenuViewController()
//        self.present(vc, animated: true, completion: nil)

        performSegue(withIdentifier: "showLeftMenu", sender: nil)
        
        
//        guard let vc = self.storyboard?.instantiateViewController(identifier: "LeftmenuViewController") as? LeftmenuViewController else { return }
//
//        self.navigationController?.pushViewController(vc, animated: true)
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

extension ATMainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CollectionViewCellDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mainTipCollectionView  {
            return mainTipData?.data.count ?? 0
        } else if collectionView == self.hashTag {
            return mainTipHashTag?.count ?? 0
        } else if collectionView == self.planshopCV {
            return mainPlanshopData?.data.count ?? 0
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
            cell.delegate = self
            return cell
        } else if collectionView == self.planshopCV  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanshopCell", for: indexPath) as! PlanshopCell
            
            if let hasData = mainPlanshopData?.data {
                if hasData.count > 0 {
                   cell.data = hasData[indexPath.row]
                }
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
            
            if let hasData = mainTipHashTag {
                if hasData.count > 0 {
                    cell.data = hasData[indexPath.row]
                }
            }
            cell.delegate = self
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.mainTipCollectionView  {
            return CGSize(width: mainTipCollectionView.frame.width / 2.1, height: mainTipCollectionView.frame.height / 2.1)
            
        } else if collectionView == self.planshopCV  {
            
            return CGSize(width: planshopCV.frame.width, height: 120)
            
            // load cell from Xib
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanshopCell", for: indexPath) as! PlanshopCell
//
//            // configure cell with data in it
////            let data = self.mainPlanshopData?.data[indexPath.item]
//
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
//
//            let width = planshopCV.frame.width
//            let height: CGFloat = 100
//
//            let targetSize = CGSize(width: width, height: height)
//
//            // get size with width that you want and automatic height
//            let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
//            // if you want height and width both to be dynamic use below
////            let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//            return size
            
//            let paddingSpace = planshopSectionInsets.left * (planshopItemsPerRow + 1)
//            let availableWidth = planshopCV.frame.width - paddingSpace
//            let availableHeight = Int( planshopCV.frame.height) / Int(mainPlanshopData?.data.count ?? Int(0.1))
//            let widthPerItem = availableHeight
//
//            return CGSize(width: availableWidth, height: widthPerItem)
            
//            var rowCount = 0.0
//            if let hasData = mainPlanshopData {
////                rowCount = hasData.data.count
//            }
//            let planshopDataCount = NSNumber(value: mainPlanshopData?.data.count ?? Int(1.0))
//            return CGSize(width: planshopCV.frame.width / 1.0, height: planshopCV.frame.height / planshopDataCount)
        } else {
            return CGSize(width: hashTag.frame.width / 2.1, height: hashTag.frame.height / 2.1)
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
    
    func didTapCell(url link: URL) {
        let safariViewController = SFSafariViewController(url: link)
        present(safariViewController, animated: true, completion: nil)
    }
}
