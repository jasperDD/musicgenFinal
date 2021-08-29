//
//  instrumentsCollectionViewCell.swift
//  MusicGen
//
//  Created by Kartinin Studio on 21.07.2021.
//

import UIKit

class InstrumentsCollectionViewCell: UICollectionViewCell {
    
    var instrumentLabel: UILabel = {
        let label = UILabel()
        label.text = "Instruments"
        label.font = UIFont(name: "Helvetica", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // backgroundColor = UIColor.purpleApp
        layer.cornerRadius = 15
        addSubview(instrumentLabel)
        instrumentLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 30)
        instrumentLabel.centerY(inView: self)
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
