//
//  forgotPasswordController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 31.08.2021.
//

import UIKit
import Firebase


class ForgotPasswordController: UIViewController {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot your password?"
        label.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        label.textColor = .purpleApp
        return label
    }()
    private let sendMailButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset your password", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.addTarget(self, action: #selector(resetPassPressed), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Enter you Email", isSecureTextEntry: false)
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icon2"), textField: emailTextField)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.addShadow()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - HELPER FUNCTION
    func configureUI(){
        configureNavigationBar()
        view.backgroundColor = .bgApp
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20, height: 30)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 34
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        //stack.centerY(inView: view)
        view.addSubview(sendMailButton)
        sendMailButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 34, paddingLeft: 16, paddingRight: 16, width: Constants.screenSize.width-32, height: 56)
        sendMailButton.addShadow()
}
    func configureNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func resetPass(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ _errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else  {
                onError(error!.localizedDescription)
            }
        }
    }
    
    //MARK: - SELECTORS
    
    @objc func resetPassPressed() {
        guard let email = emailTextField.text, email != "" else {
            let alert = UIAlertController(title: "Error", message: "Enter your email", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
            return }
        resetPass(email: email, onSuccess: {
            let alert = UIAlertController(title: "Success", message: "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password.", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
              //self.dismiss(animated: true, completion: nil)
        }) { (errorMessage) in
            let alert = UIAlertController(title: "Error", message: "\(errorMessage)", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
        }

    }

}
