//
//  ResetPassViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 3/8/24.
//

import UIKit

class ResetPassViewController: UIViewController {
    
    @IBOutlet weak var forgotPassLabel: UILabel!
    @IBOutlet weak var discLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var goBack: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }

    private func setupUI() {
        forgotPassLabel.font = .quickSandBold(size: 20)
        discLabel.font = .quickSandSemiBold(size: 14)
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.quickSandRegular(size: 16)]
        )
        
        continueButton.setTitle("Continue", for: .normal)
        goBack.setTitle("   Forgot Password", for: .normal)
        continueButton.setCustomFontForAllState(name: quicksandBold, size: 14)
        goBack.setCustomFontForAllState(name: quicksandSemiBold, size: 14)

        
        continueButton.layer.cornerRadius = 10
        continueButton.layer.masksToBounds = true
        
        
    }

    @IBAction func resetPass(sender: Any) {
        
    }
    
    @IBAction func goBack(sender: Any) {
        self.dismiss(animated: true)
    }
}
