//
//  ChangePassController.swift
//  funnyface2222
//
//  Created by quocanhppp on 05/03/2024.
//

import UIKit
import SwiftKeychainWrapper
import Toast_Swift
class ChangePassController: BaseViewController {
    @IBOutlet weak var passs: UITextField!
    @IBOutlet weak var newpass: UITextField!
    @IBOutlet weak var newpassagain: UITextField!
    @IBOutlet weak var hienpass: UIButton!
    @IBOutlet weak var hienpassnew: UIButton!
    @IBOutlet weak var hienpassnewagain: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var oldPassView: UIView!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var reEnterPassView: UIView!
    
    @IBOutlet weak var oldPassLabel: UILabel!
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var reEnterPassLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!




    
    
    private func setupUIChangePas() {
        
        oldPassLabel.font = .quickSandBold(size: 20)
        oldPassLabel.text = "Old Pass"
        newPassLabel.font = .quickSandBold(size: 20)
        newPassLabel.text = "New Pass"
        reEnterPassLabel.font = .quickSandBold(size: 20)
        reEnterPassLabel.text = "New Pass Again"
        
        confirmButton.titleLabel?.font = .quickSandBold(size: 16)
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.masksToBounds = true
        
        backButton.titleLabel?.font = .quickSandBold(size: 14)
        backButton.layer.cornerRadius = 10
        backButton.layer.masksToBounds = true

        
        
        oldPassView.layer.borderWidth = 1
        oldPassView.layer.borderColor = UIColor.gray.cgColor
        oldPassView.layer.cornerRadius = 10
        
        newPassView.layer.borderWidth = 1
        newPassView.layer.borderColor = UIColor.gray.cgColor
        newPassView.layer.cornerRadius = 10
        
        reEnterPassView.layer.borderWidth = 1
        reEnterPassView.layer.borderColor = UIColor.gray.cgColor
        reEnterPassView.layer.cornerRadius = 10
        
        passs.attributedPlaceholder = NSAttributedString(
            string: "Enter old password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.quickSandSemiBold(size: 16)]
        )
        passs.textColor = .white
        passs.font = .quickSandSemiBold(size: 16)
        
        newpass.attributedPlaceholder = NSAttributedString(
            string: "Enter new password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.quickSandSemiBold(size: 16)]
        )
        newpass.textColor = .white
        newpass.font = .quickSandSemiBold(size: 16)
        
        newpassagain.attributedPlaceholder = NSAttributedString(
            string: "Enter new password again",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.quickSandSemiBold(size: 16)]
        )
        newpassagain.textColor = .white
        newpassagain.font = .quickSandSemiBold(size: 16)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true)
    }
    @IBAction func actionBtnHiden(_ sender: Any) {
      
        if passs.isSecureTextEntry == true {
            passs.isSecureTextEntry = false
        } else {
            passs.isSecureTextEntry = true
        }
    }
    @IBAction func actionBtnHiden2(_ sender: Any) {
      
        if newpass.isSecureTextEntry == true {
            newpass.isSecureTextEntry = false
        } else {
            newpass.isSecureTextEntry = true
        }
    }
    @IBAction func actionBtnHiden3(_ sender: Any) {
      
        if newpassagain.isSecureTextEntry == true {
            newpassagain.isSecureTextEntry = false
        } else {
            newpassagain.isSecureTextEntry = true
        }
    }
    @IBAction func btnChange(_ sender: Any) {
        guard passs.text != "" && newpass.text != "" && newpassagain.text != "" else {
            if passs.text == "" {
                self.view.makeToast("UserName or Email cannot be blank", position: .top)
            } else if newpass.text == "" {
                self.view.makeToast("Password cannot be left blank",position: .top)
            } else if newpassagain.text == "" {
                self.view.makeToast("Password cannot be left blank",position: .top)
            }
             return
        }
        showCustomeIndicator()
        print("pass : " + self.passs.text.asStringOrEmpty())
        print("new pass : " + self.newpass.text.asStringOrEmpty())
        APIService.shared.getProfile(user: Int(AppConstant.userId.asStringOrEmpty()) ?? 1 ) { result, error in
            if let success = result {
                let parameters2:[String: String] = [ "email_or_username": success.user_name!, "old_password": self.passs.text.asStringOrEmpty(), "new_password": self.newpass.text.asStringOrEmpty()]
                APIService.shared.ChangePassAPI(param: parameters2,userId: Int(AppConstant.userId.asStringOrEmpty()) ?? 1){result, error in
                    self.hideCustomeIndicator()
                    guard result?.id_user != nil else {
                        self.view.makeToast(result?.ketqua, position: .top)
                        self.errorMessageLabel.text =  "thong tin tai khoan or mk khong dung!"
                        if let messagePro = result?.ketqua{
                            self.showAlert(message: messagePro)
                            return
                        }
        //                self.showAlert(message: (result?.ketqua) ?? "qqqqqPassword Wrong Or Account Not Register Or Account Not Verify Email")
                        return
                    }
                    if let result = result{
                        AppConstant.saveUser(model: result)
                        if let number_user: Int = KeychainWrapper.standard.integer(forKey: "saved_login_account"){
                            let number_userPro = number_user + 1
                            KeychainWrapper.standard.set(number_userPro, forKey: "saved_login_account")
                            if let resultEmail = (result.email){
                                let idUserNumber = "email_login_" + String(number_userPro)
                                KeychainWrapper.standard.set(resultEmail, forKey: idUserNumber)
                                let idPassUser = "pass_login_" + String(number_userPro)
                                KeychainWrapper.standard.set(self.newpass.text.asStringOrEmpty(), forKey: idPassUser)
                                let idTimeUser = "time_login_" + String(number_userPro)
                                let timeNow = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
                                KeychainWrapper.standard.set(timeNow, forKey: idTimeUser)
                            }
                        }else{
                            KeychainWrapper.standard.set(1, forKey: "saved_login_account")
                            if let resultEmail = (result.email){
                                let idUserNumber = "email_login_" + String(1)
                                KeychainWrapper.standard.set(resultEmail, forKey: idUserNumber)
                                let idPassUser = "pass_login_" + String(1)
                                KeychainWrapper.standard.set(self.newpass.text.asStringOrEmpty(), forKey: idPassUser)
                                let timeNow = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
                                let idTimeUser = "time_login_" + String(1)
                                KeychainWrapper.standard.set( timeNow, forKey: idTimeUser)
                            }
                        }
                    }
//                    let storyboard = UIStoryboard(name: "mainpage", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "mhthunhat") as! mhthunhat
//                    vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//                    self.present(vc, animated: true, completion: nil)
                    
                    let vc = TabbarViewController()
                    vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    self.present(vc, animated: true, completion: nil)
                 
                }
            }}
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hienpass.setTitle("", for: .normal)
        hienpassnew.setTitle("", for: .normal)
        hienpassnewagain.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
        setupUIChangePas()
    }

  

    

}
