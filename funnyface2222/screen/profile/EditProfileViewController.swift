//
//  EditProfileViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 2/8/24.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    
    
    var IsStopBoyAnimation = true
    var selectedImage:UIImage!
    var image_Data_Nam:UIImage = UIImage()
    var linkImageVideoSwap:String = ""
    var linkImagePro:String = ""
    
    var userId: Int = Int(AppConstant.userId.asStringOrEmpty()) ?? 0
    var dataUserEvent: [Sukien] = []

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var boyImage: UIImageView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var yourNameTextField: UITextField!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        backgroundView.backgroundColor = .black
//        isSearchUser = false
        callApiProfile()
        callAPIUserEvent()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageBoyTapped(_:)))
        boyImage.addGestureRecognizer(tapGesture)
        boyImage.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        backButton.setTitle("", for: .normal)
        saveButton.titleLabel?.font = .quickSandSemiBold(size: 14)
        titleLabel.font = .quickSandBold(size: 20)
        uploadLabel.font = .quickSandSemiBold(size: 14)
        yourNameLabel.font = .quickSandBold(size: 16)
        
        
        yourNameTextField.attributedPlaceholder = NSAttributedString(
            string: "@trunghieu",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.quickSandSemiBold(size: 16)]
        )
//        yourNameTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
//        let vc = ProfileSettingViewController(nibName: "ProfileSettingViewController", bundle: nil)
//        vc.userId = self.userId
//        vc.dataUserEvent = self.dataUserEvent
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(vc, animated: true, completion: nil)
        self.dismiss(animated: true)
    }

    @IBAction func saveAction(_ sender: Any) {
        showCustomeIndicator()
        
        
        
        let parameters2:[String: String] = [ "link_img": self.linkImagePro, "check_img": "uuuuuuu"]
        APIService.shared.ChangeAvater(param: parameters2,userId: Int(AppConstant.userId.asStringOrEmpty()) ?? 1){result, error in
                    self.hideCustomeIndicator()
                    guard result?.link_img != nil else {
                        
                        print("saiiiii")
                        
                        return
                    }
                    if let result = result{
//                        let vc = ListToProfileViewController(nibName: "ListToProfileViewController", bundle: nil)
//                        //vc.data = self.dataUserEvent
//                        vc.userId = Int(AppConstant.userId.asStringOrEmpty()) ?? 0
//                        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//                        self.present(vc, animated: true, completion: nil)
//                            print("dungg")
                        
                        self.dismiss(animated: true)
//
//                        let vc = TabbarViewController()
//                        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                }
    }
    
    
    func uploadGenVideoByImages(completion: @escaping ApiCompletion){
        APIService.shared.UploadImagesToGenRieng("https://api.funface.online/upload-gensk/" + String(AppConstant.userId ?? 0) + "?type=src_vid", ImageUpload: self.image_Data_Nam,method: .POST, loading: true){data,error in
            completion(data, nil)
        }
    }
    
    @objc func imageBoyTapped(_ sender: UITapGestureRecognizer) {
        let refreshAlert = UIAlertController(title: "Use Old Images Uploaded", message: "Do You Want Select Old Images For AI Generate Images", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Load Old Images", style: .default, handler: { (action: UIAlertAction!) in
            let vc = ListImageOldVC(nibName: "ListImageOldVC", bundle: nil)
            vc.type = "video"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Upload Image New", style: .cancel, handler: { (action: UIAlertAction!) in
            var alertStyle = UIAlertController.Style.actionSheet
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                alertStyle = UIAlertController.Style.alert
            }
            let ac = UIAlertController(title: "Select Image", message: "Select image from", preferredStyle: alertStyle)
            let cameraBtn = UIAlertAction(title: "Camera", style: .default) {_ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .camera)
            }
            let libaryBtn = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
           
            let cancel = UIAlertAction(title: "Cancel", style: .cancel){ _ in
                self.dismiss(animated: true)
            }
            ac.addAction(cameraBtn)
            ac.addAction(libaryBtn)
          
            ac.addAction(cancel)
            
            self.present(ac, animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @objc func Send_OLD_Images_Click(notification: NSNotification) {
        if let imageLink = notification.userInfo?["image"] as? String {
            self.linkImageVideoSwap = imageLink
            
            let url = URL(string: imageLink)
            let processor = DownsamplingImageProcessor(size: self.boyImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 50)
            self.boyImage.kf.indicatorType = .activity
            self.boyImage.kf.setImage(
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
    }
       
    
    func callApiProfile() {
        APIService.shared.getProfile(user: self.userId ) { result, error in
            if let success = result {
                if let idUser = success.id_user{
                    self.titleLabel.text = success.user_name ?? ""
//                    self.nameBotLabel.text = success.user_name ?? ""
//                    self.countEventLabel.text = success.count_sukien?.toString()
//                    self.countCommentLabel.text = success.count_comment?.toString()
//                    self.countViewLabel.text = (success.count_view ?? 0).toString()
//                    self.ipRegisterLabel.text = "Ip Register: " + (success.ip_register ?? "")
//                    self.deviceRegisterLabel.text = "Device Register: " + (success.device_register ?? "")
//                    self.emailLabel.text = success.email ?? ""
                    let escapedString = success.link_avatar?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                    if let url = URL(string: escapedString ?? "") {
                        let processor = DownsamplingImageProcessor(size: self.boyImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 50)
                        self.boyImage.kf.indicatorType = .activity
                        self.boyImage.backgroundColor = .clear
                        self.boyImage.kf.setImage(
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

extension EditProfileViewController : UIPickerViewDelegate,
                               UINavigationControllerDelegate,
                               UIImagePickerControllerDelegate {
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            picker.dismiss(animated: true)
            self.boyImage.image = UIImage(named: "icon-upload")
            self.image_Data_Nam = selectedImage
            self.uploadGenVideoByImages(){data,error in
                if let data = data as? String{
                    print(data)
                    self.linkImageVideoSwap = data
                    let removeSuot = self.linkImageVideoSwap.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
                    let linkImagePro = removeSuot.replacingOccurrences(of: "/var/www/build_futurelove", with: "https://photo.gachmen.org", options: .literal, range: nil)
                    self.linkImagePro = linkImagePro
                    if let url = URL(string: self.linkImagePro){
                        self.boyImage.af.setImage(withURL: url)
                    }
                    
                }
                //self.detectFaces(in: selectedImage)
            }
        }else {
            print("Image not found")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
