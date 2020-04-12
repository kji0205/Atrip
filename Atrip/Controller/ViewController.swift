//
//  ViewController.swift
//  Atrip
//
//  Created by jimmy on 2020/04/01.
//  Copyright © 2020 jimmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transition = SlideInTransition()
    var topView: UIView?
    var mainData: MainScreenModel?
    
    @IBOutlet weak var collectionViewFirst: UICollectionView!
    @IBOutlet weak var collectionViewSecond: UICollectionView!
    @IBOutlet weak var collectionViewThird: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        getApiData()
        
    }
    
    

    func getApiData() {
    
        let hasURL = URL(string:  "\(API_URL_MAIN)")!
        
        URLSession.shared.dataTask(with: hasURL) { (data, response, error) in
            
            guard let data = data else {
                let alert = UIAlertController.init(title: "정보가 없음", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.mainData = try decoder.decode(MainScreenModel.self, from: data)
                print("main ==> \(self.mainData!)")
            }
            catch DecodingError.keyNotFound(let key, let context) {
                print("Missing Key: \(key)")
                print("Debug description: \(context.debugDescription)")
            }
            catch {
                print("error ==> \(error)")
            }
            
            DispatchQueue.main.async {
//                let quizIndex = Int.random(in: 0...self.quiz.count-1)
//                self.questionText.text = self.quiz[quizIndex].question
//                self.questionText.sizeToFit()
//                self.currentAnswer = self.quiz[quizIndex].answer
//                self.collectionViewSecond.register(mainSwiperBannerCell.self, forCellWithReuseIdentifier: "mainSwiperBannerCell")
            }
        }.resume()
        
        
    }
    
    // MARK: setup
    fileprivate func setupNavigationBar() {
        let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        let rightButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: nil, action: nil)
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem]
        self.navigationItem.rightBarButtonItems = [rightButtonItem]
    }
    
    @objc func handleMenuToggle() {
//        show(LeftmenuViewController(), sender: self)
        guard let leftMenuController = storyboard?.instantiateViewController(identifier: "LeftmenuVC") as? LeftmenuViewController else {
            return
        }
        leftMenuController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        leftMenuController.modalPresentationStyle = .overCurrentContext
        leftMenuController.transitioningDelegate = self
        present(leftMenuController, animated: true, completion: nil)
    }
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .surf:
            let view = UIView()
            view.backgroundColor = .yellow
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        case .bus:
            let view = UIView()
            view.backgroundColor = .yellow
            view.frame = self.view.bounds
            self.view.addSubview(view)
            self.topView = view
        default:
            break
        }
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var collectionViewCellWithd = collectionView.frame.width
        let collectionViewCellHeight = collectionView.frame.height
        
        if (collectionView == self.collectionViewSecond) {
            collectionViewCellWithd = collectionView.frame.width
        }
        
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellHeight)
    }

    // 위아래 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

    // 옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.collectionViewFirst) {
            return 6
        } else if (collectionView == self.collectionViewSecond) {
            
            return 4
        } else if (collectionView == self.collectionViewThird) {
            return 4
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainSwiperBannerCell", for: indexPath) as! mainSwiperBannerCell
        cell.mainSwiperBannerCellImage.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}
