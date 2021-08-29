//
//  PaymentDetailsViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 24.06.2021.
//

import UIKit

class PaymentDetailsViewController: UIViewController {
    
    //MARK: - PROPERTIES
    let size = CGSize(width: 20, height: 30)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your payment details"
        label.font = UIFont(name: "Gilroy", size: 16)
        label.textColor = .black
        return label
    }()
    
    private let nextBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Donate", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let backBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "purpleBack1X")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - HELPER FUNCTIONS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem?.title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    func configure() {
        let headerView = HeaderView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 60)
        headerView.backgroundColor = UIColor.purpleApp
        self.view.addSubview(headerView)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: headerView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20 )
     
        
        view.addSubview(backBtn)
        backBtn.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 20, width: 30, height: 30 )
        
        
        
        
        view.addSubview(nextBtn)
        nextBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: Constants.screenSize.width-40, height: 60 )
        nextBtn.dropShadow()
 
    }
    
    
    
    //MARK: - SELECTORS
    @objc func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnPressed() {
        let donateScreen = DonateViewController()
        let myNavigationController = UINavigationController(rootViewController: donateScreen)
        myNavigationController.modalPresentationStyle = .fullScreen
        self.present(myNavigationController, animated: true)
    }
    
}


extension UIView {

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.purpleApp.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
