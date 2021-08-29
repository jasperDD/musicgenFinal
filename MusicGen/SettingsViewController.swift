//
//  SettingsViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 02.08.2021.
//

import UIKit
import Firebase

protocol SettingsViewControllerDelegate: AnyObject {
    func logoutUserToMVC()
}

class SettingsViewController: UIViewController {
    
    //MARK: - PROPERTIES
    weak var delegate: SettingsViewControllerDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        label.textColor = .purpleApp
        return label
    }()
    
    private let closeBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close1X")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let logoutBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logOutBtnPressed), for: .touchUpInside)
        return button
    }()

                                                  
    private let privacyPoliceBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Privacy Police", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(privacyPolicePressed), for: .touchUpInside)
        return button
    }()
    
    private let tearmsOfUse: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Tearms of use", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tearmsOfUsePressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LIFECYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - HELPER FUNCTION
    func configure() {
        let headerView = HeaderView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 60)
        headerView.backgroundColor = UIColor.purpleApp
        self.view.addSubview(headerView)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: headerView.bottomAnchor, paddingTop: 10, height: 30 )
        titleLabel.centerX(inView: view)
        
        view.addSubview(closeBtn)
        closeBtn.anchor(top: headerView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20, width: 30, height: 30 )
        
        let stackBtn = UIStackView(arrangedSubviews: [privacyPoliceBtn,
                                                      tearmsOfUse,
                                                      logoutBtn])
        stackBtn.axis = .vertical
        stackBtn.distribution = .fillEqually
        stackBtn.spacing = 5
        view.addSubview(stackBtn)
        stackBtn.anchor(width: Constants.screenSize.width-40, height: 200)
        stackBtn.centerX(inView: view)
        stackBtn.centerY(inView: view)
    }
    
   
  
    
    //MARK: - SELECTORS
    @objc func closeBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func logOutBtnPressed() {
        
        delegate?.logoutUserToMVC()
        //logoutUser()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func privacyPolicePressed() {
        let alert = UIAlertController(title: "Privacy Police", message: "Privacy Policy of the Mobile Application \n\n The 'AI Investigate' mobile application (hereinafter referred to as the Application) was developed by Martin Grey LLC (hereinafter referred to as the Copyright Holder), whose office is located at 16192 Coastal Highway, Lewes, Delaware 19958, USA. The Copyright Holder reserves the right to make changes to the Application and, if necessary, adapt this Privacy Policy (hereinafter referred to as the Policy) to the changes made and notify the Users by posting a new version of the Policy in the Application. The responsibility of independently reviewing the current version of the Policy lies with the User.\n This Policy of the Application applies to the information that the Copyright Holder can receive from the User's device while using the Application. \n Using of the Application means the unconditional consent of the User with this Policy and the conditions specified therein for processing information received from the User's device. In case of disagreement with the Policy, the User should refrain from using the Application. \n This Policy applies only to the Application. The Copyright Holder does not control and is not responsible for the use of materials (consequences of its transfer) transferred by the User to a third party for commercial purposes, if such transfer was made on a third party resource to which the user could follow by clicking the links in the Application. Responsibility for the use of materials for commercial purposes lies with the User. \n The composition of information that can be obtained from the User's device when using the Application and the purpose of its obtainment (hereinafter referred to as the User Information): \n Information on the version of the operating system and device model obtained by the Copyright Holder in order to analyze possible errors in the operation of the Application and error recovery. For the purposes of analysis, the Copyright Holder may transfer information about the operating system and device model to third parties in anonymous form. \n Permission to make purchases of virtual goods inside the Application (or the Application itself) to identify the party in the framework of agreements in order to obtain all the paid features of the Application. \n Additionally, under this Policy, the Copyright Holder is entitled to use additional software tools (including partners of the Copyright Holder) and cookies to collect and process anonymized statistical information about the User's use of the Application and services within the Application for the purpose of improving the Application.\n\n User Information Processing Terms \n In accordance with this Policy, the Copyright Holder processes only that information and only for the purposes specified in the clause “The composition of information that can be obtained from the User's device when using the Application and the purpose of its obtainment”. \n The User agrees that all claims to the Copyright Holder caused by the rights of third parties can be addressed by the Copyright Holder to the User him- or herself, and the User also undertakes to compensate for losses associated with losses by the Copyright Holder due to disputes related to the rights of third parties. \n The User data can be used to send advertising information in the Application, and the Users agrees to this by using the Application. \n\n User Data Security \n Processing of user data occurs in the Application on their own devices without the participation of the Copyright Holder. Data security is ensured by standard means of the operating system; there are no additional security features in the Application itself. The Users use the Application as is and independently protect their data from security risks, including, but not limited to:\n- protect their device and the Application installed in it from theft or loss;\n- protect their device and the Application installed in it from unauthorized access. \n\n Contacts\n Concerning the operation of the mobile application, including for placing a request for processing the user's personal data and (or) withdrawing consent for such processing, you can contact us by e-mail psygrm@gmail.com.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tearmsOfUsePressed() {
        let alert = UIAlertController(title: "Terms of use", message: "Terms of use of the “AI Investigate” application \n\n The Administration of the Application offers the services of the ”AI Investigate” mobile application (hereinafter referred to as the Application) on the terms that are the subject of these Terms of use of the Application. In this regard, you need to carefully read these Terms of use, which are considered by the Administration of the Application as a public offer.\n\n 1. Status of the Terms of use of the Application\n 1.1. These Terms of use of the “AI Investigate”  application (hereinafter referred to as the Terms) are developed by the Administration of the Application and determine the arrangements for the use of the Application, as well as the rights and obligations of its Users and the Administration. The Terms also apply to relations related to the rights and interests of third parties that are not the Users of the Application, but whose rights and interests may be affected as a result of actions by Users of the Application.\n 1.2. These Terms are a legally binding agreement between the User and the Administration of the Application, the subject of which is the provision of services for using the Application by the Administration of the Application to the User.\n 1.3. The User is obliged to carefully read these Terms before starting to use the Application. As soon as the User starts to use the Application, the User completely and unconditionally accepts these Terms.\n 1.4. These Terms may be amended and / or supplemented by the Administration of the Application unilaterally without any special notice. These Terms are an open and public document. The current version of the Terms is located on the website: www.colorring.app. The Administration of the Application recommends that Users regularly check these Terms for amendments and / or supplements. If the User continues to use the Application after amendments and / or supplements made, the User accepts these amendments and / or supplements.\n\n 2. The Administration of the Mobile Application\n 2.1. The Administration of the “AI Investigate” Application (hereinafter referred to as the Administration of the Application, the Administration) in these Terms means Martin Grey LLC, a legal entity created under the laws of the United States of America and registered at 16192 Coastal Highway, Lewes, Delaware 19958.\n2.2. The Administration is governed by the laws of the United States of America, these Terms and other special documents that are developed or can be developed and adopted by the Administration of the Application in order to regulate the provision of certain services to the Users of the Application.\n 2.3. The provisions of these Terms do not provide the User with the right to use the company name, trademarks, domain names and other distinguishing marks of the Administration of the Application. The right to use the company name, trademarks, domain names and other distinguishing marks of the Administration of the Application may be granted only by written agreement with the Administration of the Application.\n\n 3. Registration in the Application and the status of the User\n 3.1. The use of the Content posted in the Application in the public domain does not require compulsory registration and / or authorization of the User.\n3.2. By installing, gaining access to the Application, you confirm that you are at least 16 years old and you have full legal capacity to conclude this agreement. If you are between 16 and 18 years old, you hereby confirm that your parent, or legal guardian, or other representative, in accordance with applicable law, has reviewed and agreed to the Terms and allows you to access and / or use this Application.\n 3.3. When using the Application, the User agrees with these Terms and assumes the rights and obligations indicated in the Terms related to the use and operation of the Application. The user acquires the right to use the Application Services after installing the Application. Full user rights are available in the premium version after purchasing a paid subscription to the Application.\n 3.4. The Administration of the Application processes the User’s personal data in order to provide the User with services. Research and analysis of such data allow to maintain and improve the services and sections of the Application, as well as to develop new services and sections of the Application. The Administration of the Application takes all necessary measures to protect the User’s personal data from unauthorized access, alteration, disclosure or destruction. The Administration provides access to the User’s personal data only to those employees, contractors and agents of the Administration who need this information to ensure the operation of the Application and the provision of Services to the User. The Administration of the Application has the right to use the information provided by the User, including personal data, in order to ensure compliance with applicable laws of the United States of America (including in order to prevent and / or suppress illegal actions of the Users). The data provided by the User may be disclosed only in accordance with applicable law at the request of the court, law enforcement agencies, as well as in other cases provided for by the laws of the United States of America. Since the Administration of the Application processes the User’s personal data in order to perform the concluded agreement between the Administration of the Application and the User to provide the Services, by virtue of the provisions of the legislation on personal data, the User’s consent to the processing of his / her personal data is not required.\n\n4. Purchases in the Application\n4.1. Some of the Application Services may be available by subscription. The subscription can be monthly and annual. Payments for such subscriptions will be debited from the User’s account upon confirmation of purchase. They can be processed by third parties acting on our behalf, or by the owner of the online store. The subscription will be automatically renewed for the same period of time and price as the previous subscription package of your choice, unless you turn off the automatic renewal. Your account will be charged for renewal within 24 hours before the end of the current subscription period (Apple App Store) at the cost of the selected package. You can manage your subscriptions and turn off automatic renewal by going to the user account settings after the purchase. You can cancel your subscription at any time and the cancellation will take effect after the end of the last day of this subscription period. Upon cancellation of the subscription, the paid funds are not automatically returned to the account. The User needs to place a request in the Apple Store.\n\n5. Links to the Third Parties\n5.1. Application Services may contain third-party advertising. The Administration of the Application is not responsible for the availability of such websites or third-party resources, and is not responsible for any content, advertising or services that they provide.\n5.2. Any content, advertising, or services of third parties is provided in accordance with the terms of service and privacy policies that can be found on the website of the relevant third party, and, where it is applicable. The Users should read and accept the terms of service and privacy policies of such third parties before using their services. The Users are responsible for any individual costs or obligations that they incur in relations with these third parties. The Administration of the Application is not responsible for any claims relating to any content, goods or services of third parties.\n\n6. The Terms for terminating the use of the Application\n6.1. These Terms come into force for the User from the moment he or she joins them and are valid for an indefinite period.\n6.2. The Users can stop using the Application at any time.\n6.3. The Administration of the Application may terminate or suspend, withdraw, restrict or delete all or any part of the Application Services at any time for business reasons, or if the Users violate any terms of this agreement (including the Privacy Policy or Terms of Use).\n\n7. Applicable law\n7.1. The provisions of the Application are governed by and construed in accordance with the laws of the United States of America.\n\n8. Dispute Resolution\n8.1. In the event of any disputes or disagreements related to the implementation of these Terms, the User and the Administration of the Application will make every effort to resolve them by negotiating. You can contact the Administration of the Application by e-mail psygrm@gmail.com. In the event that disputes are not resolved through negotiations, they shall be resolved in accordance with the applicable laws of the United States of America.\n\n9. Force Majeure\n9.1. In the event of force majeure circumstances beyond the control of the Users and the Administration, such as: natural disasters, military operations of any nature, the Administration is not responsible for the failure to fulfill any obligations in accordance with the Terms or providing access to the Services.\n\n10. Final Provisions\n10.1. These Terms constitute an agreement between the User and the Administration of the Application regarding the procedure for using the Application and its services.\n\n11. Contact information\n11.1. You can contact us by e-mail psygrm@gmail.com.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
