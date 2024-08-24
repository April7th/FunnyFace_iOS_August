//
//  ReportViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 5/8/24.
//

import UIKit
import SwiftKeychainWrapper

class ReportViewController: UIViewController {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var report1Label:UILabel!
    @IBOutlet weak var report2Label:UILabel!
    @IBOutlet weak var report3Label:UILabel!
    @IBOutlet weak var report4Label:UILabel!
    @IBOutlet weak var otherLabel:UILabel!
    @IBOutlet weak var otherButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var okButton:UIButton!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var xButton:UIButton!

    var reportText1: String = ""
    var reportText2: String = ""
    var reportText3: String = ""
    var reportText4: String = ""

    
    var test: String = ""
    var id_comment: String = ""
    var id_userComment: String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.textColor = UIColor(hexString: "#FF0000")
        titleLabel.font = .quickSandBold(size: 20)
        report1Label.font = .quickSandBold(size: 16)
        report2Label.font = .quickSandBold(size: 16)
        report3Label.font = .quickSandBold(size: 16)
        report4Label.font = .quickSandBold(size: 16)
        otherLabel.font = .quickSandBold(size: 16)
        
        
        
        otherButton.setTitle("", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        okButton.setTitle("OK", for: .normal)
        xButton.setTitle("", for: .normal)

        
        cancelButton.setCustomFontForAllState(name: quicksandBold, size: 18)
        okButton.setCustomFontForAllState(name: quicksandBold, size: 18)
        


    }
    
    @IBAction func checkbox1Tapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            reportText1 = ""
        } else {
            sender.isSelected = true
            reportText1 = report1Label.text ?? ""
        }
    }
    
    @IBAction func checkbox2Tapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            reportText2 = ""
        } else {
            sender.isSelected = true
            reportText2 = report2Label.text ?? ""
        }
    }
    
    @IBAction func checkbox3Tapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            reportText3 = ""
        } else {
            sender.isSelected = true
            reportText3 = report3Label.text ?? ""
        }
    }
    
    @IBAction func checkbox4Tapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            reportText4 = ""
        } else {
            sender.isSelected = true
            reportText4 = report4Label.text ?? ""
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        if let id_user_report: Int = KeychainWrapper.standard.integer(forKey: "id_user"){
            let param = ["id_comment": self.id_comment,
                         "report_reason": "\(textFieldInput.text), \(reportText1), \(reportText2), \(reportText3), \(reportText4)",
                         "id_user_report": "\(id_user_report)",
                         "id_user_comment": id_userComment]
            print("Param is \(param)")
            APIService.shared.reportComment(param: param) {result, error in
                if let success = result {
                    print("result is: \(success)")
                    let alert = UIAlertController(title: "Send Report Ok", message: "Please Wait For Admin Check Your Report", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done Report", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            self.dismiss(animated: true)
                        case .cancel:
                            self.dismiss(animated: true)
                        case .destructive:
                            self.dismiss(animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                print("Success: \(result)")
            }
        }else{
            print("NO LOGIN")
            let alert = UIAlertController(title: "Alert", message: "Please Login Account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login To Report", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func otherButtonTapped(_ sender: UIButton) {
        print(reportText1)
        print(reportText2)
        print(reportText3)
        print(reportText4)

    }

   

}


class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let width = containerView.bounds.width - 16
        let height = containerView.bounds.height / 2
        let x = CGFloat(8)
        let y = (containerView.bounds.height - height) / 2
        
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        // Add a dimming view for a better user experience
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        // Remove the dimming view when the transition ends
        containerView?.backgroundColor = .clear
    }
}
