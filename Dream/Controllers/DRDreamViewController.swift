//
//  DRDreamViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRDreamViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    public var dream: Dream?

    // MARK: - Outlets    
    
    @IBOutlet weak var targetDateLabel   : UILabel!
    @IBOutlet weak var targetCreditsLabel: UILabel!
    @IBOutlet weak var progressView      : DRProgressView!
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        self.navigationItem.title = dream?.name
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        let date = dream?.targetDate ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let result = formatter.string(from: date)
        
        progressView.dream = dream
        
        targetDateLabel.text = result
        
        let credits = dream?.targetCredits ?? 0
        targetCreditsLabel.text = String(format: "%.f$", credits)
    }
    
    // MARK: Actions
    
    
    @IBAction func minusTouchDown(_ sender: DRButton) {
        
    }
    
    @IBAction func minusTouchUpInside(_ sender: DRButton) {

    }
    
    @IBAction func plusTouchDown(_ sender: DRButton) {
        
    }

    @IBAction func plusTouchUpInside(_ sender: DRButton) {
        
    }
    
    
    
    @IBAction func add(_ sender: UIButton) {

//                self.dream?.currentCredits = (self.dream?.currentCredits ?? 0.0) + (Double(userInput) ?? 0.0)
//                CoreDataManager.sharedInstance.addTransaction(uuid: UUID().uuidString, dream: self.dream!, date: Date(), credits: Double(userInput)!)
//                
//                CoreDataManager.sharedInstance.saveContext()
//                
//                self.progressView.dream = self.dream
     
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
 
        
//        //        if segue.destination == DRHistoryTableViewController {
        let controller = segue.destination as? DRHistoryTableViewController
        controller?.dream = dream
        //        }
    }

}
