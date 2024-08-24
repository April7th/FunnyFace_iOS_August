//
//  ProfileSettingViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 2/8/24.
//

import UIKit
import AlamofireImage
import Kingfisher
import SETabView

class ProfileSettingViewController: UIViewController{

//    var seTabBarItem: UITabBarItem? {
//        return UITabBarItem(title: "", image: UIImage(named: "user"), tag: 0)
//    }
    var userId: Int = Int(AppConstant.userId.asStringOrEmpty()) ?? 0

    var dataUserEvent: [Sukien] = []
    var dataRecentCommemt: [CommentUser] = []
    var data : [Sukien] = []

    
    @IBOutlet weak var userEventTableView: UITableView!

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTopLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameBotLabel: UILabel!
    @IBOutlet weak var eventCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var textDefaultLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        backgroundView.backgroundColor = .black
//        isSearchUser = false
        callApiProfile()
        callAPIUserEvent()
        callAPIRecentComment()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEventTableView.delegate = self
        userEventTableView.dataSource = self
        userEventTableView.register(cellType: Template1TBVCell.self)
        userEventTableView.register(cellType: Template2TBVCell.self)
        userEventTableView.register(cellType: Template3TBVCell.self)
        userEventTableView.register(cellType: Template4TBVCell.self)
        
        

        setupUI()
    }
    
    private func setupUI() {
        backButton.setTitle("", for: .normal)
        nameBotLabel.font = .quickSandBold(size: 16)
        nameTopLabel.font = .quickSandBold(size: 16)
        cameraButton.setTitle("", for: .normal)
        editButton.setTitle("   Edit profile", for: .normal)
        editButton.setCustomFontForAllState(name: quicksandBold, size: 14)
        editButton.layer.cornerRadius = 8
        editButton.layer.masksToBounds = true
        
        moreButton.setTitle("", for: .normal)
        moreButton.layer.cornerRadius = 8
        moreButton.layer.masksToBounds = true
        
        textDefaultLabel.font = .quickSandMedium(size: 14)
        eventCountLabel.font = .quickSandBold(size: 14)
        commentCountLabel.font = .quickSandBold(size: 14)
        viewCountLabel.font = .quickSandBold(size: 14)
        
        coverImage.image = UIImage(named: "background")
        coverImage.contentMode = .scaleAspectFill
        avatarImage.backgroundColor = .clear
        

    }
    
    @IBAction func backButton(_ sender: Any) {
//        self.navigationController?.popToRootViewController(animated: false)
//        self.dismiss(animated: true)
        self.dismiss(animated: true)
        
//        let vc = ListToProfileViewController(nibName: "ListToProfileViewController", bundle: nil)
//        vc.userId = self.userId
//        //vc.data = self.dataUserEvent
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        let vc = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        vc.userId = self.userId
        //vc.data = self.dataUserEvent
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func moreButton(_ sender: Any) {
        let vc = ChangePassController(nibName: "ChangePassController", bundle: nil)
        //vc.data = self.dataUserEvent
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func callApiProfile() {
        APIService.shared.getProfile(user: self.userId ) { result, error in
            if let success = result {
                if let idUser = success.id_user{
                    self.nameTopLabel.text = success.user_name ?? ""
                    self.nameBotLabel.text = success.user_name ?? ""
                    self.eventCountLabel.text = success.count_sukien?.toString()
                    self.commentCountLabel.text = success.count_comment?.toString()
                    self.viewCountLabel.text = (success.count_view ?? 0).toString()
                    let escapedString = success.link_avatar?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                    if let url = URL(string: escapedString ?? "") {
                        let processor = DownsamplingImageProcessor(size: self.avatarImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 50)
                        self.avatarImage.kf.indicatorType = .activity
                        self.avatarImage.backgroundColor = .clear
                        self.avatarImage.contentMode = .scaleAspectFill
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
    
    func callAPIRecentComment() {
        APIService.shared.getRecentComment(user: self.userId) { result, error in
            if let success = result {
                self.dataRecentCommemt = success.comment_user.reversed()
                
                if self.dataRecentCommemt.count == 0 {
//                    self.commentCountLabel.text = "0"
                } else {
//                    self.commentCountLabel.text = String(self.dataRecentCommemt.count)
                }
            }
        }
    }
    
   
    
}


extension ProfileSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("dataUserEvent: \(dataUserEvent.count)")

        return dataUserEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataUserEvent[indexPath.row]
        if item.id_template == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template4TBVCell", for: indexPath) as? Template4TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: dataUserEvent[indexPath.row])
            return cell
        } else if item.id_template == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template3TBVCell", for: indexPath) as? Template3TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: dataUserEvent[indexPath.row])
            return cell
        } else if item.id_template == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template2TBVCell", for: indexPath) as? Template2TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: dataUserEvent[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template1TBVCell", for: indexPath) as? Template1TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: dataUserEvent[indexPath.row])
            return cell
        }
        
    }
    
}

extension ProfileSettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.width * 200 / 390
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventViewController(data: dataUserEvent[indexPath.row].id_toan_bo_su_kien ?? 0 , idsukien: dataUserEvent[indexPath.row].id_toan_bo_su_kien ?? 0)
        vc.idToanBoSuKien = dataUserEvent[indexPath.row].id_toan_bo_su_kien ?? 0
        var dataDetail: [EventModel] = [EventModel]()
        var sothutu_sukien = 1
        for indexList in dataUserEvent{
            var itemAdd:EventModel = EventModel()
            itemAdd.link_da_swap = indexList.link_da_swap
            itemAdd.count_comment = 0
            itemAdd.count_view = 0
            itemAdd.id = indexList.id
            itemAdd.id_user = indexList.id_user
            let dateNow = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
            let dateString = dateFormatter.string(from:dateNow)
            itemAdd.real_time = dateString
            //                            itemAdd.id_template = indexList.id_template
            itemAdd.link_nam_chua_swap = indexList.link_nam_chua_swap
            itemAdd.link_nu_chua_swap = indexList.link_nu_chua_swap
            itemAdd.link_nu_goc = indexList.link_nu_goc
            itemAdd.link_nam_goc = indexList.link_nam_goc
            itemAdd.noi_dung_su_kien = indexList.noi_dung_su_kien
            itemAdd.so_thu_tu_su_kien = sothutu_sukien
            sothutu_sukien = sothutu_sukien + 1
            itemAdd.ten_su_kien = indexList.ten_su_kien
            dataDetail.append(itemAdd)
        }
        vc.dataDetail = dataDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
