//
//  LoginViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let screenSize: CGRect = UIScreen.main.bounds
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        label.textColor = .purpleApp
        return label
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
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icon2"), textField: passwordTextField)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.addShadow()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Get started", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPassTitleLabel: UIButton = {
        let btn = UIButton()
        
        //btn.textColor = .orangeApp
        btn.setTitle("Forgot password?", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        btn.addTarget(self, action: #selector(forgotPassPressed), for: .touchUpInside)
        btn.setTitleColor(UIColor.orangeApp, for: UIControl.State.normal)
        return btn
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don’t have account? ", attributes: [NSAttributedString.Key.font: UIFont(name: "Gilroy-SemiBold", size: 16), NSAttributedString.Key.foregroundColor: UIColor.purpleLightApp])
        attributedTitle.append(NSAttributedString(string: "Create Account", attributes: [NSAttributedString.Key.font: UIFont(name: "Gilroy-SemiBold", size: 16), NSAttributedString.Key.foregroundColor: UIColor.orangeApp]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }

    //MARK: - Selectors
    @objc func forgotPassPressed() {
        
        let forgotPassScreen = ForgotPasswordController()
        let myNavigationController = UINavigationController(rootViewController: forgotPassScreen)
      //  myNavigationController.modalPresentationStyle = .fullScreen
        self.present(myNavigationController, animated: true)
    }
    
    @objc func handleLogin(){
        
       // self.dismiss(animated: true, completion: nil)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to Log user in with error \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "Failed to Log user in with error There is no user record corresponding to this identifier. The user may have been deleted.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
               /* let vc = MainViewController()
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = vc
                window.makeKeyAndVisible()
                vc.view.backgroundColor = .purple
                //controller.configure()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)*/
                self.dismiss(animated: true, completion: nil)
                
            }
           
        }
        /*guard let controller = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else{
            return
        }*/
        
        
    }
    
    @objc func handleShowSignUp(){
        let controller = SignUpViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        //navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: - Helper function
    
    func configureUI(){
        configureNavigationBar()
        view.backgroundColor = .bgApp
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20, height: 30)
        titleLabel.centerX(inView: view)
        
        
        
        var logo = UIView()
        let image = UIImage(named: "Logo")
        logo = UIImageView(image: image)
        logo.frame = CGRect.init(x: 0, y: 0, width: 66, height: 95)
        view.addSubview(logo)
        logo.anchor(top: titleLabel.bottomAnchor, paddingTop: 30, width: 66, height: 95)
        logo.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 34
        
        view.addSubview(stack)
        stack.anchor(top: logo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        //stack.centerY(inView: view)
        view.addSubview(loginButton)
        loginButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 34, paddingLeft: 16, paddingRight: 16, width: screenSize.width-32, height: 56)
        loginButton.addShadow()
        
        view.addSubview(forgotPassTitleLabel)
        forgotPassTitleLabel.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
    }
    func configureNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func createSpinnerView() {
        let child = SpinnerLoaderView()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

}
extension LoginViewController: SignUpViewControllerDelegate {
    func dismisLoginController() {
        self.createSpinnerView()
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
