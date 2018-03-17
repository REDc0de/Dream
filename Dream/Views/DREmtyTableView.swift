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
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.addImage()
        self.addHeaderLabel()
        self.addInfoLabel()
    }
    
    private func addImage() {
        
    }
    
    private func addHeaderLabel() {
        self.headerLabel.text = "Dreams"
        self.headerLabel.textColor = UIColor.lightGray
        self.headerLabel.textAlignment = .center
        self.headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        self.addSubview(self.headerLabel)
        
        self.headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerLabel.centerYAnchor.constraintLessThanOrEqualToSystemSpacingBelow(self.centerYAnchor, multiplier: 1),
            self.headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ])
    }
    
    private func addInfoLabel() {
        self.infoLabel.text = "You dont have any dreams yet.\nAll Your dreams will show up here."
        self.infoLabel.textColor = UIColor.lightGray
        self.infoLabel.numberOfLines = 0
        self.infoLabel.textAlignment = .center
        self.infoLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.addSubview(self.infoLabel)
        
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.infoLabel.widthAnchor.constraint(equalToConstant: 300)
            ])
    }

}
