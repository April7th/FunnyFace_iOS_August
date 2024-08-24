//
//  testViewController.swift
//  funnyface2222
//
//  Created by quocanhppp on 15/01/2024.
//

import UIKit
import SETabView
import SwiftKeychainWrapper

class testViewController: UIViewController,SETabItemProvider {
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "haha", image: UIImage(named: "notification"), tag: 0)
    }
    var dataList_All: [Sukien] = []
    var dataDetail: [EventModel] = []
    var dataComment : [DataComment] = []
    var userId: Int = Int(AppConstant.userId.asStringOrEmpty()) ?? 0

    var dataUserEvent: [Sukien] = []

    
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var commentNotiTableView: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        callAPIUserEvent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callAllComment()
        setupUI()
        
    }
    
    private func setupUI() {
        notiLabel.font = .quickSandBold(size: 24)
        searchButton.setTitle("", for: .normal)
        commentNotiTableView.backgroundColor = .clear
        commentNotiTableView.register(cellType: CommentNotificationTableViewCell.self)
        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()) {
//            profileImage.af.setImage(withURL: url)
        }
        
    }
    
    func callAPIgetdataComment(page: Int) {
        APIService.shared.getPageComment(page: page, idUser: String(AppConstant.userId ?? 0)) { result, error in
            if let success = result{
                self.dataComment = success.comment
//                self.maxPage = 1
                var dataNewComment : [DataComment] = self.dataComment
                if let number_user: Int = KeychainWrapper.standard.integer(forKey: "number_user"){
                    for item in 0..<number_user{
                        let idUserNumber = "id_user_" + String(item)
                        if let idUser: String = KeychainWrapper.standard.string(forKey: idUserNumber){
                            var kiemtra = 0
                            for itemDataComment in dataNewComment{
                                if kiemtra >= 0 {
                                    if (itemDataComment.noi_dung_cmt)?.urlEncoded == idUser{
                                        dataNewComment.remove(at: kiemtra)
                                        kiemtra = kiemtra - 1
                                    }else{
                                        kiemtra = kiemtra + 1
                                    }
                                }
                                
                            }
                        }
                    }

                    self.dataComment.append(contentsOf: dataNewComment)
                    print("data: \(self.dataComment.count)")
                    print("data new: \(dataNewComment.count)")

                }
                self.commentNotiTableView.reloadData()
                
            }
        }
    }
    
    private func callAllComment() {
//        for i in 1...2 {
//            callAPIgetdataComment(page: i)
//        }
        callAPIgetdataComment(page: 1)
    }
    
    func callAPIUserEvent() {
        APIService.shared.getUserEvent(user:  self.userId) { result, error in
            if let success = result {
                let data = success.list_sukien.compactMap {$0.sukien.first }
                self.dataUserEvent = data
                
            }
        }
    }
    
    func reportItem(at indexPath: IndexPath) {
        // Ví dụ: Hiển thị cảnh báo xác nhận
        let alert = UIAlertController(title: "Report", message: "Are you sure you want to report this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { action in
            // Xử lý báo cáo ở đây, ví dụ như gửi dữ liệu lên server
            print("Item at \(indexPath.row) reported.")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
   

}

extension testViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Data comment count: \(dataComment.count)")
        return dataComment.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentNotificationTableViewCell", for: indexPath) as? CommentNotificationTableViewCell else {
            return UITableViewCell()
        }
        
        let linkImagePro = dataComment[indexPath.row].avatar_user?.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://photo.gachmen.org", options: .literal, range: nil)
        cell.id_comment = "\(dataComment[indexPath.row].id_comment)"
        cell.id_user_comment = "\(dataComment[indexPath.row].id_user)"
        cell.thoi_gian_release = dataComment[indexPath.row].thoi_gian_release ?? ""
        cell.linkAvatar = linkImagePro ?? ""
        cell.configCellComment(model: dataComment[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reportAction = UITableViewRowAction(style: .normal, title: "Report") { (action, indexPath) in
            // Xử lý hành động khi người dùng nhấn nút "Report"
            self.reportItem(at: indexPath)
        }
        
        reportAction.backgroundColor = UIColor(hexString: "#02AD44") // Đổi màu nếu muốn
        
        return [reportAction]
    }
    
   
    
}

extension testViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
    
}
