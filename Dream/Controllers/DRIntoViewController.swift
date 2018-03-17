//
//  DRIntoViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 28.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRIntoViewController: UIViewController {

    @IBAction func done(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isNeedToPresentIntro")
        self.dismiss(animated: true, completion: nil)
    }

}
