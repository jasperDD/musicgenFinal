//
//  DonateViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 24.06.2021.
//

import UIKit


class DonateViewController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Methods"
        label.font = UIFont(name: "gilroy-semibold", size: 16)
        label.textColor = .black
        return label
    }()
    
    private let closeBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close1X")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let smallDonateBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("3.00$", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(smallDonateBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let mediumDonateBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("6.00$", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(mediumDonateBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let highDonateBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("10.00$", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(highDonateBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let nextBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Donate", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
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
    }
    
    //MARK: - HELPER FUNCTIONS
    func configure() {
        let headerView = HeaderView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 60)
        headerView.backgroundColor = UIColor.purpleApp
        self.view.addSubview(headerView)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: headerView.bottomAnchor, paddingTop: 20 )
        titleLabel.centerX(inView: view)
        
        view.addSubview(closeBtn)
        closeBtn.anchor(top: headerView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20, width: 30, height: 30 )
        
        let stackBtn = UIStackView(arrangedSubviews: [smallDonateBtn,
                                                      mediumDonateBtn,
                                                      highDonateBtn])
        stackBtn.axis = .horizontal
        stackBtn.distribution = .fillEqually
        stackBtn.spacing = 5
        view.addSubview(stackBtn)
        stackBtn.anchor(top: titleLabel.bottomAnchor, paddingTop: 50, width: Constants.screenSize.width-40, height: 60)
        stackBtn.centerX(inView: view)
        stackBtn.centerY(inView: view)
        
        smallDonateBtn.backgroundColor = .purpleLightApp
        mediumDonateBtn.backgroundColor = .purpleLightApp
        highDonateBtn.backgroundColor = .purpleLightApp
        
        view.addSubview(nextBtn)
        nextBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: Constants.screenSize.width-40, height: 60 )
 
    }
    
    func resetAllBtn() {
        smallDonateBtn.backgroundColor = .purpleLightApp
        mediumDonateBtn.backgroundColor = .purpleLightApp
        highDonateBtn.backgroundColor = .purpleLightApp
    }
    
    //MARK: - SELECTORS
    @objc func closeBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func smallDonateBtnPressed() {
        resetAllBtn()
        nextBtn.setTitle("Donate 3.00$", for: .normal)
        RazeFaceProducts.SwiftShopping  = "Donate"
        smallDonateBtn.backgroundColor = .purpleApp
        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
          guard self != nil else { return }
          if success {
               print("DEBUG: buy")
              
          } else {
              print("DEBUG: Not buy")
          }
          
        }
        
    }
    
    @objc func mediumDonateBtnPressed() {
        resetAllBtn()
        nextBtn.setTitle("Donate 6.00$", for: .normal)
        mediumDonateBtn.backgroundColor = .purpleApp
        
        RazeFaceProducts.SwiftShopping  = "DonateMedium"
        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
          guard self != nil else { return }
          if success {
               print("DEBUG: buy")
              
          } else {
              print("DEBUG: Not buy")
          }
          
        }
    }
    
    @objc func highDonateBtnPressed() {
        resetAllBtn()
        nextBtn.setTitle("Donate 10.00$", for: .normal)
        highDonateBtn.backgroundColor = .purpleApp
        
        RazeFaceProducts.SwiftShopping  = "DonateBig"
        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
          guard self != nil else { return }
          if success {
               print("DEBUG: buy")
              
          } else {
              print("DEBUG: Not buy")
          }
          
        }
    }
    
    @objc func nextBtnPressed() {
       
        //let myNavigationController = UINavigationController(rootViewController: donateScreen)
        //donateScreen.modalPresentationStyle = .fullScreen
      /*  let controller = PaymentDetailsViewController()
        controller.title = "Enter your payment details"
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.purpleApp
       
       
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)*/
    }
    
}
