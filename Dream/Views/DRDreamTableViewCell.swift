//
//  DRDreamTableViewCell.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 11.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRDreamTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var dream: Dream? {
        didSet {
            setup()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var timerLabel: DRTimerLabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Methods
    
    private func setup() {
        guard let dream = self.dream else {
            return
        }
        
        self.nameLabel.text = dream.name
        self.creditsLabel.text = String(format: "%.f$", dream.currentCredits) + "/" + String(format: "%.f$", dream.targetCredits)
        self.timerLabel.scheduleTimer(targetDate: dream.targetDate!)
        self.backgroundImageView.image = UIImage(data: dream.image ?? Data())
    }
    
}
