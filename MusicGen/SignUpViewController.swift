//
//  SignUpViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//

import UIKit
import Firebase
import AuthenticationServices
import CryptoKit
import GoogleSignIn

protocol SignUpViewControllerDelegate: AnyObject {
    func dismisLoginController()
}

class SignUpViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: SignUpViewControllerDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
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
    
      private lazy var fullnameContainerView: UIView = {
          let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icon2"), textField: fullnameTextField)
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
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
       private let passwordTextField: UITextField = {
           return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
       }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let signUpWithAppleButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("CONTINUE WITH APPLE", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 20)
        button.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        return button
    }()
    
    private let signUpWithGoogleButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("CONTINUE WITH GOOGLE", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 20)
        button.addTarget(self, action: #selector(handleSignUpWithGoogleButton), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Have you account yet? ", attributes: [NSAttributedString.Key.font: UIFont(name: "Gilroy-SemiBold", size: 16), NSAttributedString.Key.foregroundColor: UIColor.purpleApp])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font: UIFont(name: "Gilroy-SemiBold", size: 16), NSAttributedString.Key.foregroundColor: UIColor.orangeApp]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
       
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    var buttons = [UIButton]()
      
    // MARK: - Lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        appleButton.isHidden = true
        
      /*  let controller = MainViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)*/
    }
    
   
    // MARK: - helper function
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
           /*  guard let controller = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else{
                 return
             }*/
            
            
            self.dismiss(animated: true, completion: nil)
            self.delegate?.dismisLoginController()
           //let vc = MainViewController()
          //  controller.modalPresentationStyle = .fullScreen
         //   self.present(controller, animated: true, completion: nil)
           // self.dismiss(animated: true, completion: nil)
            // controller.configure()
            print("success yeee")
           //  self.dismiss(animated: true, completion: nil)
         })
    }
    
    func configureUI(){
        view.backgroundColor = .bgApp
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        // create button1
        //let button1 = UIButton(frame: CGRect(x: 0, y: 55, width: 24, height: 24))
        let checkBtn = UIButton()
        checkBtn.setTitleColor(UIColor.white, for: .normal)
        checkBtn.setTitle("Terms and Conditions       s", for: .normal)
        checkBtn.setImage(UIImage(named: "icon1X.png")!, for: .normal)
        checkBtn.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        // if the selected button cannot be reclick again, you can use .Disabled state
        checkBtn.setImage(UIImage(named: "icon1X.png")!, for: .selected)
        checkBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        checkBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        //view.addSubview(button1)
        
        buttons.append(checkBtn)
        
        
        
        let stack = UIStackView(arrangedSubviews: [fullnameContainerView,
                                                   emailContainerView,
                                                   passwordContainerView,
                                                   signUpButton,
                                                   checkBtn,
                                                   signUpWithAppleButton,
                                                   signUpWithGoogleButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 30
        
        view.addSubview(stack)
       // stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        stack.centerY(inView: view)
        signUpWithGoogleButton.isHidden = true
        
        let checkBtnTitle = UIButton()
        checkBtnTitle.setTitleColor(UIColor.purpleApp, for: .normal)
        checkBtnTitle.setTitle("Terms and Conditions", for: .normal)

        checkBtnTitle.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        // if the selected button cannot be reclick again, you can use .Disabled state
        checkBtnTitle.addTarget(self, action: #selector(termsAction), for: .touchUpInside)
        checkBtnTitle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkBtnTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.addSubview(checkBtnTitle)
        checkBtnTitle.anchor(top: checkBtn.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 10, width: 150, height: 24)
        checkBtnTitle.centerX(inView: view)
        
        
        signUpWithAppleButton.backgroundColor = .black
        signUpWithGoogleButton.backgroundColor = .red
        var googleLeftIcon = UIView()
        let image = UIImage(named: "googleIcon1X")
        googleLeftIcon = UIImageView(image: image)
        googleLeftIcon.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 86)
        signUpWithGoogleButton.addSubview(googleLeftIcon)
        googleLeftIcon.anchor(left: signUpWithGoogleButton.leftAnchor, paddingLeft: 10, width: 39, height: 30)
        googleLeftIcon.centerY(inView: signUpWithGoogleButton)
        
        
        var appleLogoLeftIcon = UIView()
        let image2 = UIImage(named: "appleLogo")
        appleLogoLeftIcon = UIImageView(image: image2)
        appleLogoLeftIcon.frame = CGRect.init(x: 0, y: 0, width: 30, height: 86)
        signUpWithAppleButton.addSubview(appleLogoLeftIcon)
        appleLogoLeftIcon.anchor(left: signUpWithAppleButton.leftAnchor, paddingLeft: 10, width: 30, height: 30)
        appleLogoLeftIcon.centerY(inView: signUpWithAppleButton)
        
        signUpButton.addShadow()
        signUpWithAppleButton.addShadowBlack()
        signUpWithGoogleButton.addShadowRed()
        
        //Create line button
        // create path

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 10))
        path.addLine(to: CGPoint(x: 50, y: 45))

        // Create a `CAShapeLayer` that uses that `UIBezierPath`:

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1

        // Add that `CAShapeLayer` to your view's layer:

        signUpWithGoogleButton.layer.addSublayer(shapeLayer)
        
        // create path

        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 50, y: 10))
        path2.addLine(to: CGPoint(x: 50, y: 45))

        // Create a `CAShapeLayer` that uses that `UIBezierPath`:

        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path.cgPath
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 1

        // Add that `CAShapeLayer` to your view's layer:

        signUpWithAppleButton.layer.addSublayer(shapeLayer2)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
        /*view.addSubview(appleButton)
        appleButton.cornerRadius = 12
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)*/
        
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
    }
    
    
    //MARK: - APPLE AUTH
        
    // Unhashed nonce.
       fileprivate var currentNonce: String?
       
        @available(iOS 13, *)
       @objc func startSignInWithAppleFlow() {
           let nonce = randomNonceString()
           currentNonce = nonce
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           request.nonce = sha256(nonce)
           
           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }
       
       @available(iOS 13, *)
       private func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
               return String(format: "%02x", $0)
           }.joined()
           
           return hashString
       }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    
    
    //MARK: - SELECTORS
    @objc func handleSignUp(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
            if let error = error {
                print("Failed to register user with error \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "Failed to register user with error \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let uid = result?.user.uid else { return }
            let api = API()
            api.getUserId({ res in
                //callback(MusicModel.initForm(json: JSON(rawValue: res.midi) ?? ""))
                // print("Success")
                if res.userID == "" {
                    print("success")
                    print("success = \(res.userID)")
                    let values = ["fullname": fullname,
                                  "email": email,
                                  "userID": res.userID]
                        as [String : Any]
                    self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                    
                }
                else {
                    print("error")
                }
                })
             
        }
    }
    
    @objc func handleShowLogin(){
       // navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUpWithGoogleButton() {
              
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func buttonAction(sender: UIButton!){
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        // you may need to know which button to trigger some action
        // let buttonIndex = buttons.indexOf(sender)
    }
    
    @objc func termsAction() {
        let alert = UIAlertController(title: "Terms of use", message: "Terms of use of the “AI Investigate” application \n\n The Administration of the Application offers the services of the ”AI Investigate” mobile application (hereinafter referred to as the Application) on the terms that are the subject of these Terms of use of the Application. In this regard, you need to carefully read these Terms of use, which are considered by the Administration of the Application as a public offer.\n\n 1. Status of the Terms of use of the Application\n 1.1. These Terms of use of the “AI Investigate”  application (hereinafter referred to as the Terms) are developed by the Administration of the Application and determine the arrangements for the use of the Application, as well as the rights and obligations of its Users and the Administration. The Terms also apply to relations related to the rights and interests of third parties that are not the Users of the Application, but whose rights and interests may be affected as a result of actions by Users of the Application.\n 1.2. These Terms are a legally binding agreement between the User and the Administration of the Application, the subject of which is the provision of services for using the Application by the Administration of the Application to the User.\n 1.3. The User is obliged to carefully read these Terms before starting to use the Application. As soon as the User starts to use the Application, the User completely and unconditionally accepts these Terms.\n 1.4. These Terms may be amended and / or supplemented by the Administration of the Application unilaterally without any special notice. These Terms are an open and public document. The current version of the Terms is located on the website: www.colorring.app. The Administration of the Application recommends that Users regularly check these Terms for amendments and / or supplements. If the User continues to use the Application after amendments and / or supplements made, the User accepts these amendments and / or supplements.\n\n 2. The Administration of the Mobile Application\n 2.1. The Administration of the “AI Investigate” Application (hereinafter referred to as the Administration of the Application, the Administration) in these Terms means Martin Grey LLC, a legal entity created under the laws of the United States of America and registered at 16192 Coastal Highway, Lewes, Delaware 19958.\n2.2. The Administration is governed by the laws of the United States of America, these Terms and other special documents that are developed or can be developed and adopted by the Administration of the Application in order to regulate the provision of certain services to the Users of the Application.\n 2.3. The provisions of these Terms do not provide the User with the right to use the company name, trademarks, domain names and other distinguishing marks of the Administration of the Application. The right to use the company name, trademarks, domain names and other distinguishing marks of the Administration of the Application may be granted only by written agreement with the Administration of the Application.\n\n 3. Registration in the Application and the status of the User\n 3.1. The use of the Content posted in the Application in the public domain does not require compulsory registration and / or authorization of the User.\n3.2. By installing, gaining access to the Application, you confirm that you are at least 16 years old and you have full legal capacity to conclude this agreement. If you are between 16 and 18 years old, you hereby confirm that your parent, or legal guardian, or other representative, in accordance with applicable law, has reviewed and agreed to the Terms and allows you to access and / or use this Application.\n 3.3. When using the Application, the User agrees with these Terms and assumes the rights and obligations indicated in the Terms related to the use and operation of the Application. The user acquires the right to use the Application Services after installing the Application. Full user rights are available in the premium version after purchasing a paid subscription to the Application.\n 3.4. The Administration of the Application processes the User’s personal data in order to provide the User with services. Research and analysis of such data allow to maintain and improve the services and sections of the Application, as well as to develop new services and sections of the Application. The Administration of the Application takes all necessary measures to protect the User’s personal data from unauthorized access, alteration, disclosure or destruction. The Administration provides access to the User’s personal data only to those employees, contractors and agents of the Administration who need this information to ensure the operation of the Application and the provision of Services to the User. The Administration of the Application has the right to use the information provided by the User, including personal data, in order to ensure compliance with applicable laws of the United States of America (including in order to prevent and / or suppress illegal actions of the Users). The data provided by the User may be disclosed only in accordance with applicable law at the request of the court, law enforcement agencies, as well as in other cases provided for by the laws of the United States of America. Since the Administration of the Application processes the User’s personal data in order to perform the concluded agreement between the Administration of the Application and the User to provide the Services, by virtue of the provisions of the legislation on personal data, the User’s consent to the processing of his / her personal data is not required.\n\n4. Purchases in the Application\n4.1. Some of the Application Services may be available by subscription. The subscription can be monthly and annual. Payments for such subscriptions will be debited from the User’s account upon confirmation of purchase. They can be processed by third parties acting on our behalf, or by the owner of the online store. The subscription will be automatically renewed for the same period of time and price as the previous subscription package of your choice, unless you turn off the automatic renewal. Your account will be charged for renewal within 24 hours before the end of the current subscription period (Apple App Store) at the cost of the selected package. You can manage your subscriptions and turn off automatic renewal by going to the user account settings after the purchase. You can cancel your subscription at any time and the cancellation will take effect after the end of the last day of this subscription period. Upon cancellation of the subscription, the paid funds are not automatically returned to the account. The User needs to place a request in the Apple Store.\n\n5. Links to the Third Parties\n5.1. Application Services may contain third-party advertising. The Administration of the Application is not responsible for the availability of such websites or third-party resources, and is not responsible for any content, advertising or services that they provide.\n5.2. Any content, advertising, or services of third parties is provided in accordance with the terms of service and privacy policies that can be found on the website of the relevant third party, and, where it is applicable. The Users should read and accept the terms of service and privacy policies of such third parties before using their services. The Users are responsible for any individual costs or obligations that they incur in relations with these third parties. The Administration of the Application is not responsible for any claims relating to any content, goods or services of third parties.\n\n6. The Terms for terminating the use of the Application\n6.1. These Terms come into force for the User from the moment he or she joins them and are valid for an indefinite period.\n6.2. The Users can stop using the Application at any time.\n6.3. The Administration of the Application may terminate or suspend, withdraw, restrict or delete all or any part of the Application Services at any time for business reasons, or if the Users violate any terms of this agreement (including the Privacy Policy or Terms of Use).\n\n7. Applicable law\n7.1. The provisions of the Application are governed by and construed in accordance with the laws of the United States of America.\n\n8. Dispute Resolution\n8.1. In the event of any disputes or disagreements related to the implementation of these Terms, the User and the Administration of the Application will make every effort to resolve them by negotiating. You can contact the Administration of the Application by e-mail psygrm@gmail.com. In the event that disputes are not resolved through negotiations, they shall be resolved in accordance with the applicable laws of the United States of America.\n\n9. Force Majeure\n9.1. In the event of force majeure circumstances beyond the control of the Users and the Administration, such as: natural disasters, military operations of any nature, the Administration is not responsible for the failure to fulfill any obligations in accordance with the Terms or providing access to the Services.\n\n10. Final Provisions\n10.1. These Terms constitute an agreement between the User and the Administration of the Application regarding the procedure for using the Application and its services.\n\n11. Contact information\n11.1. You can contact us by e-mail psygrm@gmail.com.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


@available(iOS 13.0, *)
extension SignUpViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["fullname": displayName,
                              "email": email,
                              "userID": uid]
                    as [String : Any]
                self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                
              /*  let db = Firestore.firestore()
                db.collection("User").document(uid).setData([
                    "email": email,
                    "displayName": displayName,
                    "uid": uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("the user has sign up or is logged in")
                        
                    }
                    
                }*/
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension SignUpViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
