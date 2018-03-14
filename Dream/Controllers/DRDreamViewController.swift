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
    
    @IBOutlet weak var targetDateLabel    : UILabel!
    @IBOutlet weak var targetCreditsLabel : UILabel!
    @IBOutlet weak var percentageLabel    : UILabel!
    @IBOutlet weak var timeProgressView   : DRCircleProgressView!
    @IBOutlet weak var creditsProgressView: DRCircleProgressView!
    @IBOutlet weak var moneyTextField     : UITextField!
    
    private var creditsProgress: Double {
        get{
            return Double().progress(between: dream?.currentCredits, and: dream?.targetCredits)
        }
    }
    
    private var dateProgress: Double {
        get{
            return Double().progress(between: dream?.startDate, and: dream?.targetDate)
        }
    }
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        self.navigationItem.title = dream?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.timeProgressView.value = Float(self.dateProgress)
        updateCreditsProgress()
        
        updateDateProgress()
        updateCreditslabel()
        
        // Timer
        let targetDate   = dream?.targetDate ?? Date()
        let startDate    = dream?.startDate  ?? Date()
        var timeInterval = abs((targetDate.timeIntervalSince(startDate))/60)/100
        timeInterval = timeInterval < 0.00001 ? 0.00001 : timeInterval

        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateDateProgress), userInfo: nil, repeats: true)
    }
    
    // MARK: Methods
    
    @objc private func updateDateProgress() {
        DispatchQueue.main.async {
            self.timeProgressView.value = Float(self.dateProgress)
            self.targetDateLabel.text = Date().offset(to: self.dream?.targetDate ?? Date())
        }
        
        if dateProgress == 1 {
            timer?.invalidate()
            return
        }
    }
    
    private func updateCreditsProgress() {
        self.creditsProgressView.value = Float(self.creditsProgress)
        percentageLabel  .text      = " \(Int(self.creditsProgress * 100))%"
    }
    
    private func updateCreditslabel() {
        DispatchQueue.main.async {
            let credits = self.dream?.currentCredits ?? 0
            self.targetCreditsLabel.text = String(format: "%.f$", credits)
        }
    }
    
    // MARK: Actions
    
    @IBAction func minusTouchDown(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(minus), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func minusTouchUpInside(_ sender: UIButton) {
        minus()
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func plusTouchDown(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(plus), userInfo: nil, repeats: true)
    }

    @IBAction func plusTouchUpInside(_ sender: UIButton) {
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
        
        updateCreditsProgress()
        
        updateCreditslabel()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let controller = segue.destination as? DRHistoryTableViewController {
            controller.dream = dream
        }
        
        let destinationNavigationController = segue.destination as? UINavigationController
        let targetController = destinationNavigationController?.topViewController
        
        if let controller = targetController as? DRAddTableViewController {
            controller.dream = dream
        }
    }

}
