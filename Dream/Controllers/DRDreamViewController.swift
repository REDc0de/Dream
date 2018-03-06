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
    
    // MARK: - Internal Properties
    
    private var timer: Timer?

    // MARK: - Outlets    
    
    @IBOutlet weak var targetDateLabel   : UILabel!
    @IBOutlet weak var targetCreditsLabel: UILabel!
    @IBOutlet weak var progressView      : DRProgressView!
    @IBOutlet weak var moneyTextField    : UITextField!
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        self.navigationItem.title = dream?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressView.dream = dream
        
        updateDatelabel()
        updateCreditslabel()
        
        // Timer
        let targetDate   = dream?.targetDate ?? Date()
        let startDate    = dream?.startDate  ?? Date()
        let timeInterval = abs((targetDate.timeIntervalSince(startDate))/60)
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateDatelabel), userInfo: nil, repeats: true)
    }
    
    // MARK: Methods
    
    @objc func updateDatelabel() {
        DispatchQueue.main.async {
            self.targetDateLabel.text = Date().offset(to: self.dream?.targetDate ?? Date())
        }
    }
    
    private func updateCreditslabel() {
        DispatchQueue.main.async {
            let credits = self.dream?.currentCredits ?? 0
            self.targetCreditsLabel.text = String(format: "%.f$", credits)
        }
    }
    
    // MARK: Actions
    
    @IBAction func minusTouchDown(_ sender: DRButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(minus), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func minusTouchUpInside(_ sender: DRButton) {
        minus()
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func plusTouchDown(_ sender: DRButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(plus), userInfo: nil, repeats: true)
    }

    @IBAction func plusTouchUpInside(_ sender: DRButton) {
        plus()
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func minus() {
        let money = Int(moneyTextField.text ?? "") ?? 0
        moneyTextField.text = String(money-1)
        
        let timeInterval = (timer?.timeInterval ?? 0) < 0.01 ? 0.01 : (timer?.timeInterval ?? 0)*2/3
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(minus), userInfo: nil, repeats: true)
    }
    
    @objc private func plus() {
        let money = Int(moneyTextField.text ?? "") ?? 0
        moneyTextField.text = String(money+1)
        
        let timeInterval = (timer?.timeInterval ?? 0) < 0.01 ? 0.01 : (timer?.timeInterval ?? 0)*2/3
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(plus), userInfo: nil, repeats: true)
    }
    
    @IBAction func add(_ sender: UIButton) {
        
        let userInput = Int(moneyTextField.text ?? "") ?? 0
        
        self.dream?.currentCredits = (self.dream?.currentCredits ?? 0.0) + (Double(userInput))
        CoreDataManager.sharedInstance.addTransaction(uuid: UUID().uuidString, dream: self.dream!, date: Date(), credits: Double(userInput))
        
        CoreDataManager.sharedInstance.saveContext()
        
        self.progressView.dream = self.dream
        
        updateCreditslabel()
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
