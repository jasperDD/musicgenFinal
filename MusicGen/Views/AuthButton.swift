//
//  AuthButton.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        backgroundColor = .purpleApp
        layer.cornerRadius = 8
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
