//
//  DetailEventsViewController.swift
//  FutureLove
//
//  Created by TTH on 28/07/2023.
//

import UIKit
import AlamofireImage
import SwiftKeychainWrapper
import Kingfisher

class DetailEventsViewController: UIViewController {
    var dataDetail: EventModel?
    var index: Int = -1
    var dataComment : [DataCommentEvent] = []
    var idToanBoSuKien : Int = 0
    var dataIp : [IPAddress] = []
    var fullscreenView: UIView?
    var downloadButton: UIButton?
    var ListIDUser_Block:[Int] = [Int]()
    @IBOutlet weak var buttonBack: UIButton!

    
    var imageURL: String = ""
    var usernNameString: String = ""
    //    var initialTransform: CGAffineTransform = .identity
    var initialImageScale: CGFloat = 1.0
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var countView: UIButton!
    @IBOutlet weak var countComment: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewDetailSuKien: UIView!
    var ToanBoSuKien_Trong1LanChay : [EventModel] = [EventModel]()
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var keyboardScroll: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var avartarImage: UIImageView!
    @IBOutlet weak var detailEventTableView: UITableView!
    @IBOutlet weak var buttonEnter: UIButton!
    @IBOutlet weak var commentView: UIView!
    
    init(data: Int ) {
        self.idToanBoSuKien = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callApiProfile()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameDetailLabel.textColor = UIColor.black
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = .quickSandBold(size: 20)
        self.descriptionLabel.textColor = UIColor.black
        self.commentTextField.textColor = UIColor.black
        setupUI()
        callApiIP()
        callApiDetailEvent()
        callApiComentEvent()
        keyboard()
        buttonEnter.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        commentTextField.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.ActionClickToSubSuKien))
        self.viewDetailSuKien.addGestureRecognizer(gesture)
        
//        if let url = URL(string: imageURL ?? "") {
//            
//            let processor = DownsamplingImageProcessor(size: self.avatarImage.bounds.size)
//            |> RoundCornerImageProcessor(cornerRadius: 50)
//            self.avatarImage.kf.indicatorType = .activity
//            self.avatarImage.backgroundColor = .clear
//            self.avatarImage.contentMode = .scaleAspectFill
//            self.avatarImage.kf.setImage(
//                with: url,
//                placeholder: UIImage(named: "placeholderImage"),
//                options: [
//                    .processor(processor),
//                    .scaleFactor(UIScreen.main.scale),
//                    .transition(.fade(1)),
//                    .cacheOriginalImage
//                ])
//            {
//                result in
//                switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//                }
//            }
//        }
        
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "Comment",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5), NSAttributedString.Key.font: UIFont.quickSandRegular(size: 12)]
        )
        commentTextField.textColor = .white
        commentView.layer.cornerRadius = 12
        commentView.layer.masksToBounds = true
        
        
        print("user id: \(AppConstant.userId.asStringOrEmpty())")
        print("event user id: \(dataDetail?.id_user.asStringOrEmpty())")
        
    }
    @objc func ActionClickToSubSuKien(sender : UITapGestureRecognizer) {
        let vc = EventViewController(data:idToanBoSuKien, idsukien: idToanBoSuKien)
        vc.dataDetail = ToanBoSuKien_Trong1LanChay
        vc.idToanBoSuKien = idToanBoSuKien
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func reloadBlockAccount(DataXoa:String){
        ListIDUser_Block.removeAll()
        var dataNewComment : [DataCommentEvent] = dataComment
        if let number_user: Int = KeychainWrapper.standard.integer(forKey: "number_user"){
            for item in 0..<number_user{
                let idUserNumber = "id_user_" + String(item)
                if let idUser: String = KeychainWrapper.standard.string(forKey: idUserNumber){
                    var kiemtra = 0
                    for itemDataComment in dataNewComment{
                        if (itemDataComment.noi_dung_cmt)?.urlEncoded == idUser{
                            if kiemtra >= 0{
                                dataNewComment.remove(at: kiemtra)
                                kiemtra = kiemtra - 1
                            }
                        }else if itemDataComment.noi_dung_cmt == DataXoa{
                            if kiemtra >= 0{
                                dataNewComment.remove(at: kiemtra)
                                kiemtra = kiemtra - 1
                            }
                        }else{
                            kiemtra = kiemtra + 1
                        }
                    }
                }
            }
            dataComment = dataNewComment
            detailEventTableView.reloadData()
        }
    }
    
    func setupUI() {
        hideKeyboardWhenTappedAround()
        detailEventTableView.dataSource = self
        detailEventTableView.delegate = self
        detailEventTableView.register(cellType: DetailCommentTableViewCell.self)
        detailEventTableView.register(cellType: EventCommentTableViewCell.self)
        
        userNameLabel.text = usernNameString
        userNameLabel.font = .quickSandBold(size: 14)
        
//        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()){
//            avartarImage.af.setImage(withURL: url)
//        }
//        
        if let url = URL(string: imageURL ?? "") {
            
            let processor = DownsamplingImageProcessor(size: self.avartarImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 50)
            self.avartarImage.kf.indicatorType = .activity
            self.avartarImage.backgroundColor = .clear
            self.avartarImage.contentMode = .scaleAspectFill
            self.avartarImage.kf.setImage(
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

        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        detailImage.addGestureRecognizer(tapGesture)
        detailImage.isUserInteractionEnabled = true
        
        nameDetailLabel.font = .starBorn(size: 16)
        
        descriptionLabel.font = .quickSandBold(size: 14)
        
       
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func callApiDetailEvent() {
        APIService.shared.getDetailEvent(id: idToanBoSuKien){ result, error in
            if let success = result{
                self.ToanBoSuKien_Trong1LanChay = success.sukien
                if success.sukien.count > self.index - 1{
                    let data = success.sukien[self.index - 1 ]
                    self.titleLabel.text = data.ten_su_kien ?? ""
                    if let url = URL(string: data.link_da_swap ?? ""){
                        self.detailImage.af.setImage(withURL: url)
                    }
                    self.descriptionLabel.text = data.noi_dung_su_kien.asStringOrEmpty()
                    self.nameDetailLabel.text = data.ten_su_kien.asStringOrEmpty()
                    self.countComment.setTitle("\(data.count_comment ?? 0)", for: .normal)
                    self.countView.setTitle("\(data.count_view ?? 0)", for: .normal)
                    
                }
            }
        }
    }
    
    func callApiIP() {
        APIService.shared.getIP{ result, error in
            if let success = result {
                self.dataIp = [success]
                self.detailEventTableView.reloadData()
            }
        }
    }
    
    func callApiProfile() {
        APIService.shared.getProfile(user: self.dataDetail?.id_user ?? 1 ) { result, error in
            if let success = result {
                if let idUser = success.id_user{
                    self.userNameLabel.text = success.user_name ?? ""
                    
                    
                    let escapedString = success.link_avatar?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                    if let url = URL(string: escapedString ?? "") {
                        let processor = DownsamplingImageProcessor(size: self.avatarImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 50)
                        self.avatarImage.kf.indicatorType = .activity
                        self.avatarImage.backgroundColor = .clear
                        self.avatarImage.contentMode = .scaleAspectFill
                        self.avatarImage.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "noavatar_fill"),
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
                }
            }
        }
    }
    
    func callApiComentEvent() {
        APIService.shared.getCommentEvent(id: index, id_toan_bo_su_kien: "\(idToanBoSuKien)", idUser: String(AppConstant.userId ?? 0)) {result, error in
            if let success = result {
                self.dataComment = success.comment
                var dataNewComment : [DataCommentEvent] = self.dataComment
                if let number_user: Int = KeychainWrapper.standard.integer(forKey: "number_user"){
                    for item in 0..<number_user{
                        let idUserNumber = "id_user_" + String(item)
                        if let idUser: String = KeychainWrapper.standard.string(forKey: "idUserNumber"){
                            var kiemtra = 0
                            for itemDataComment in dataNewComment{
                                if (itemDataComment.noi_dung_cmt)?.urlEncoded == idUser{
                                    dataNewComment.remove(at: kiemtra)
                                    kiemtra = kiemtra - 1
                                }else{
                                    kiemtra = kiemtra + 1
                                }
                            }
                        }
                    }
                    self.dataComment = dataNewComment
                }
                self.detailEventTableView.reloadData()
            }
        }
    }
    @IBAction func enterCommentBtn(_ sender: Any) {
        enterComments()
    }
    
    
    @IBAction func postCommentBtn(_ sender: Any) {
        enterComments()
        buttonEnter.isHidden = false
        
    }
    
    private func enterComments() {
        guard commentTextField.text != "" else { return }
        let param = ["noi_dung_cmt": commentTextField.text.asStringOrEmpty(),
                     "id_toan_bo_su_kien": "\(idToanBoSuKien) ",
                     "device_cmt": AppConstant.modelName ?? "iphone",
                     "ipComment": dataIp.first?.ip ?? "",
                     "imageattach": "",
                     "id_user": "\(AppConstant.userId ?? 0)",
                     "so_thu_tu_su_kien": "\(index)",
                     "location": dataIp.first?.city ?? ""]
        APIService.shared.postComents(param: param) {result, error in
            if let success = result {
                self.callApiComentEvent()
                self.commentTextField.text = nil
                self.detailEventTableView.reloadData()
            }
        }
    }
    
    // MARK: - ZoomIn ZoomOut Image
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else {
            return
        }
        
        fullscreenView = UIView(frame: view.bounds)
        fullscreenView?.backgroundColor = .black
        fullscreenView?.alpha = 0
        
        let zoomedImageView = UIImageView(frame: tappedImageView.frame)
        zoomedImageView.image = tappedImageView.image
        zoomedImageView.contentMode = .scaleAspectFit
        fullscreenView?.addSubview(zoomedImageView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler))
        fullscreenView?.addGestureRecognizer(pinchGesture)
        
        downloadButton = UIButton(type: .custom)
        downloadButton?.setTitle("Download", for: .normal)
        downloadButton?.frame = CGRect(x: 20, y: 50, width: 100, height: 40)
        downloadButton?.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        fullscreenView?.addSubview(downloadButton!)
        
        let closeButton = UIButton(frame: CGRect(x: view.bounds.width - 120, y: 50, width: 100, height: 40))
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        fullscreenView?.addSubview(closeButton)
        
        if let fullscreenView = fullscreenView {
            view.addSubview(fullscreenView)
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.fullscreenView?.alpha = 1
            zoomedImageView.frame = UIScreen.main.bounds
        }
    }
    
    @objc func pinchGestureHandler(sender: UIPinchGestureRecognizer){
        if sender.state == .began {
            initialImageScale = fullscreenView!.transform.a
        }
        if sender.state == .changed {
            let scale = sender.scale
            let scaledValue = max(min(initialImageScale * scale, 2.0), initialImageScale)
            fullscreenView?.transform = CGAffineTransform(scaleX: scaledValue, y: scaledValue)
        }
        
        if sender.state == .ended {
            fullscreenView?.transform = CGAffineTransform(scaleX: initialImageScale, y: initialImageScale)
        }
    }
    @objc func closeButtonTapped() {
        // Đóng ảnh phóng to
        dismissFullscreenImage()
    }
    func dismissFullscreenImage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fullscreenView?.alpha = 0
        }) { _ in
            self.fullscreenView?.removeFromSuperview()
            self.fullscreenView = nil
        }
    }
    @objc func downloadButtonTapped() {
        let alert = UIAlertController(title: "Download", message: "Save For Images Library", preferredStyle: .alert)
        let oke = UIAlertAction(title: "Oke", style: .default) { result in
            if let image = self.detailImage.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            self.view.makeToast("Download Done")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(oke)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error Saved Images: \(error.localizedDescription)")
        } else {
            print("Download Images Done Okie")
        }
    }
    
    // MARK: - Keyboard Scroll
    func keyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - 30, right: 0)
        keyboardScroll.contentInset = contentInset
        keyboardScroll.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        keyboardScroll.contentInset = contentInset
        keyboardScroll.scrollIndicatorInsets = contentInset
    }
    
}
// MARK: - extension UITableView

extension DetailEventsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentTableViewCell", for: indexPath) as? DetailCommentTableViewCell else {
//            return UITableViewCell()
//        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCommentTableViewCell", for: indexPath) as? EventCommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.commentLabel.text = dataComment[indexPath.row].noi_dung_cmt ?? ""
        cell.userNameLabel.text = dataComment[indexPath.row].user_name ?? ""
        cell.timeLabel.text = dataComment[indexPath.row].thoi_gian_release ?? ""
        
        let avatarString = dataComment[indexPath.row].avatar_user ?? ""
        if let url = URL(string: avatarString ?? "noavatar_fill") {
            let processor = DownsamplingImageProcessor(size: cell.avatarImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
            
            cell.avatarImage.kf.indicatorType = .activity
            cell.avatarImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "noavatar_fill"),
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
        cell.selectionStyle = .none
        
//        cell.id_comment = "\(dataComment[indexPath.row].id_comment)"
//        cell.id_user_comment = "\(dataComment[indexPath.row].id_user)"
//        cell.linkAvatar = dataComment[indexPath.row].avatar_user ?? ""
//        cell.descriptionMain = dataComment[indexPath.row].noi_dung_cmt ?? ""
//        cell.thoi_gian_release = dataComment[indexPath.row].thoi_gian_release ?? ""
//        cell.noi_dung_cmt = dataComment[indexPath.row].noi_dung_cmt ?? ""
//        cell.configCell(model: dataComment[indexPath.row])
        return cell
    }
}

extension DetailEventsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}

extension DetailEventsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard commentTextField.text != "" else { return false}
        let param = ["noi_dung_cmt": commentTextField.text.asStringOrEmpty(),
                     "id_toan_bo_su_kien": "\(idToanBoSuKien) ",
                     "device_cmt": AppConstant.modelName ?? "iphone",
                     "ipComment": dataIp.first?.ip ?? "",
                     "imageattach": "",
                     "id_user": "\(AppConstant.userId ?? 0)",
                     "so_thu_tu_su_kien": "\(index)",
                     "location": dataIp.first?.city ?? ""]
        APIService.shared.postComents(param: param) {result, error in
            if let success = result {
                self.callApiComentEvent()
                self.commentTextField.text = nil
                self.detailEventTableView.reloadData()
            }
        }
        return true
        
    }
}
