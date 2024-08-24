//
//  ListToProfileViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 2/8/24.
//

import UIKit
import AlamofireImage
import Kingfisher
import SETabView

class ListToProfileViewController: UIViewController, SETabItemProvider {
    
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: UIImage(named: "user"), tag: 0)
    }
    var userId: Int = Int(AppConstant.userId.asStringOrEmpty()) ?? 0
    var dataUserEvent: [Sukien] = []
    


    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var videoCollectionButton: UIButton!
    @IBOutlet weak var imageCollectionButton: UIButton!
    @IBOutlet weak var myEventButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var videoCollectionView: UIView!
    @IBOutlet weak var imageCollectionView: UIView!
    @IBOutlet weak var myEventView: UIView!



    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var goToProfileButton: UIButton!

    var listTemplateVideo : [ResultVideoModel] = [ResultVideoModel]()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        callApiProfile()
        callAPIUserEvent()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        menuLabel.font = .quickSandBold(size: 24)
        nameLabel.font = .quickSandBold(size: 18)
        videoCollectionButton.setCustomFontForAllState(name: quicksandSemiBold, size: 16)
        imageCollectionButton.setCustomFontForAllState(name: quicksandSemiBold, size: 16)
        myEventButton.setCustomFontForAllState(name: quicksandSemiBold, size: 16)
        logOutButton.setCustomFontForAllState(name: quicksandSemiBold, size: 16)


        
        infoView.layer.cornerRadius = 10
        infoView.layer.masksToBounds = true
        logoutView.layer.cornerRadius = 10
        logoutView.layer.masksToBounds = true
        
        searchButton.setTitle("", for: .normal)
        goToProfileButton.setTitle("", for: .normal)
        
        
        for index in 0...9 {
            APIService.shared.listAllVideoSwaped(page: index) { response, error in
                self.listTemplateVideo.append(contentsOf: response)
            }
        }

        
    }
    var allVideo : [ResultVideoModel] = [ResultVideoModel]()

    @IBAction func clickToVideo(_ sender: Any) {
//        if let parentVC = findParentViewController(of: UIViewController.self) {
//            let storyboard = UIStoryboard(name: "HomeStaboad", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "albumswaped") as! albumswaped
//            
//            vc.modalPresentationStyle = .fullScreen
//            
//            
//            APIService.shared.listAllVideoSwaped(page:1){response,error in
//                vc.listTemplateVideo = response
//                print("lisssss dataa: \(response)")
//                parentVC.present(vc, animated: true, completion: nil)
//                //self.cacluachon.reloadData()
//            }
//        }
        if let parentVC = findParentViewController(of: UIViewController.self) {
            let storyboard = UIStoryboard(name: "UserVideoViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserVideoViewController") as! UserVideoViewController
            
            vc.modalPresentationStyle = .fullScreen
            vc.listTemplateVideo = listTemplateVideo
            parentVC.present(vc, animated: true, completion: nil)
        }
        


    }
    
    @IBAction func clickToEvent(_ sender: Any) {
        let vc = UserEventViewController(nibName: "UserEventViewController", bundle: nil)
        vc.data = self.dataUserEvent
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func goToProfile(_ sender: Any) {
        let vc = ProfileSettingViewController(nibName: "ProfileSettingViewController", bundle: nil)
        
        vc.dataUserEvent = self.dataUserEvent

        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func LogOutBtn(_ sender: Any) {
         AppConstant.logout()
        //        self.navigationController?.pushViewController(loginView(nibName: "loginView", bundle: nil), animated: true)
        
        if AppConstant.userId == nil {
            let storyboard = UIStoryboard(name: "login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginView") as! loginView
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }


    func callApiProfile() {
        APIService.shared.getProfile(user: self.userId ) { result, error in
            if let success = result {
                if let idUser = success.id_user{
                    self.nameLabel.text = success.user_name ?? ""
                    let escapedString = success.link_avatar?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                    if let url = URL(string: escapedString ?? "") {
                        let processor = DownsamplingImageProcessor(size: self.avatarImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 20)
                        self.avatarImage.kf.indicatorType = .activity
                        self.avatarImage.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "placeholderImage"),
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                            ])
                        {
                            result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }else{
                    if let message = success.ketqua{
                        let alert = UIAlertController(title: "Error Get Data", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                AppConstant.logout()
                                self.navigationController?.pushViewController(loginView(nibName: "loginView", bundle: nil), animated: true)
                            case .cancel:
                                AppConstant.logout()
                                self.navigationController?.pushViewController(loginView(nibName: "loginView", bundle: nil), animated: true)
                            case .destructive:
                                AppConstant.logout()
                                self.navigationController?.pushViewController(loginView(nibName: "loginView", bundle: nil), animated: true)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func callAPIUserEvent() {
        APIService.shared.getUserEvent(user:  self.userId) { result, error in
            if let success = result {
                let data = success.list_sukien.compactMap {$0.sukien.first }
                self.dataUserEvent = data
                

//                self.eventCountLabel.text = String(data.count)
            }
        }
    }

}
