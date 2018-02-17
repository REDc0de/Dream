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
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        progressView.dream = dream
        
        targetDateLabel.text = result
        
        let credits = dream?.targetCredits ?? 0
        targetCreditsLabel.text = String(format: "%.f$", credits)
    }
    
    // MARK: Actions

    @IBAction func add(_ sender: UIButton) {
        
        var amountTextField: UITextField?
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Add money", message: "Please enter amount of money you want to add.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let userInput = amountTextField!.text {
                
                self.dream?.currentCredits = (self.dream?.currentCredits ?? 0.0) + (Double(userInput) ?? 0.0)
                CoreDataManager.sharedInstance.addTransaction(uuid: UUID().uuidString, dream: self.dream!, date: Date(), credits: Double(userInput)!)
                
                CoreDataManager.sharedInstance.saveContext()
                
                self.progressView.dream = self.dream
                
                print("User entered \(userInput)")
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Add Input TextField to dialog message
        dialogMessage.addTextField { (textField) -> Void in
            
            amountTextField = textField
            amountTextField?.keyboardType = .numberPad
            amountTextField?.placeholder  = "Money amount"
        }
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //        if segue.destination == DRHistoryTableViewController {
        let controller = segue.destination as? DRHistoryTableViewController
        controller?.dream = self.dream
        //        }
    }

}
