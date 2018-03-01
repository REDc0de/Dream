//
//  DREmtyTableView.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 02.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DREmtyTableView: UIView {
    
    // MARK: - Properties
    
    private var imageView = UIImageView()
    private var headerLabel = UILabel()
    private var infoLabel = UILabel()
    
    // MARK: - Lifecicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        addImage()
        addHeaderLabel()
        addInfoLabel()
    }
    
    private func addImage() {
        
    }
    
    private func addHeaderLabel() {
        headerLabel.text = "Dreams"
        headerLabel.textColor = UIColor.lightGray
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraintLessThanOrEqualToSystemSpacingBelow(centerYAnchor, multiplier: 1),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
    }
    
    private func addInfoLabel() {
        infoLabel.text = "You dont have any dreams yet.\nAll Your dreams will show up here."
        infoLabel.textColor = UIColor.lightGray
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 18)
        
        addSubview(infoLabel)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: 300)
            ])
    }

}
