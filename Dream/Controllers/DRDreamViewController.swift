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
    
    private var creditsProgress: Double {
        get{
            return Double().progress(between: self.dream?.currentCredits, and: self.dream?.targetCredits)
        }
    }
    
    private var dateProgress: Double {
        get{
            return Double().progress(between: self.dream?.startDate, and: self.dream?.targetDate)
        }
    }

    // MARK: - Outlets    
    
    @IBOutlet weak var targetDateLabel: UILabel!
    @IBOutlet weak var targetCreditsLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var timerProgressView: DRTimerCircleProgressView!
    @IBOutlet weak var creditsProgressView: UICircleProgressView!
    @IBOutlet weak var moneyTextField: UITextField!
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = self.dream?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCreditsProgress()
        
        self.updateDateProgress()
        self.updateCreditslabel()

        
        guard let startDate = self.dream?.startDate, let targetDate = self.dream?.targetDate else {
                        return
                    }
        
        self.timerProgressView.startDate  = startDate
        self.timerProgressView.targetDate = targetDate
        
//        self.setTimer()
    }
    
    // MARK: Methods
//
//    private func setTimer() {
//
//        guard let startDate = self.dream?.startDate, let targetDate = self.dream?.targetDate else {
//            return
//        }
//
//        let timeInterval = abs(targetDate.timeIntervalSince(startDate))/360 // time interval for 1 degrees moving
//
//        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateDateProgress), userInfo: nil, repeats: true)
//    }
    
    @objc private func updateDateProgress() {
        DispatchQueue.main.async {
            self.timerProgressView.value = Float(self.dateProgress)
            self.targetDateLabel.text = Date().offset(to: self.dream?.targetDate ?? Date())
        }
        
        if self.dateProgress == 1 {
            self.timer?.invalidate()
            return
        }
    }
    
    private func updateCreditsProgress() {
        self.creditsProgressView.value = Float(self.creditsProgress)
        self.percentageLabel.text      = " \(Int(self.creditsProgress * 100))%"
    }
    
    private func updateCreditslabel() {
        DispatchQueue.main.async {
            let credits = self.dream?.currentCredits ?? 0
            self.targetCreditsLabel.text = String(format: "%.f$", credits)
        }
    }
    
    // MARK: Actions
    
    @IBAction func minusTouchDown(_ sender: UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func minusTouchUpInside(_ sender: UIButton) {
        self.minus()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func plusTouchDown(_ sender: UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.plus), userInfo: nil, repeats: true)
    }

    @IBAction func plusTouchUpInside(_ sender: UIButton) {
        self.plus()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func minus() {
        let money = Int(self.moneyTextField.text ?? "") ?? 0
        self.moneyTextField.text = String(money-1)
        
        let timeInterval = (self.timer?.timeInterval ?? 0) < 0.01 ? 0.01 : (self.timer?.timeInterval ?? 0)*2/3
        self.timer?.invalidate()
        self.timer = nil
        
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
    }
    
    @objc private func plus() {
        let money = Int(self.moneyTextField.text ?? "") ?? 0
        self.moneyTextField.text = String(money+1)
        
        let timeInterval = (self.timer?.timeInterval ?? 0) < 0.01 ? 0.01 : (self.timer?.timeInterval ?? 0)*2/3
        self.timer?.invalidate()
        self.timer = nil
        
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.plus), userInfo: nil, repeats: true)
    }
    
    @IBAction func add(_ sender: UIButton) {
        
        let userInput = Int(self.moneyTextField.text ?? "") ?? 0
        
        self.dream?.currentCredits = (self.dream?.currentCredits ?? 0.0) + (Double(userInput))
        CoreDataManager.sharedInstance.addTransaction(uuid: UUID().uuidString, dream: self.dream!, date: Date(), credits: Double(userInput))
        
        CoreDataManager.sharedInstance.saveContext()
        
        self.updateCreditsProgress()
        
        self.updateCreditslabel()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let controller = segue.destination as? DRHistoryTableViewController {
            controller.dream = self.dream
        }
        
        let destinationNavigationController = segue.destination as? UINavigationController
        let targetController = destinationNavigationController?.topViewController
        
        if let controller = targetController as? DRAddTableViewController {
            controller.dream = self.dream
        }
    }

}
