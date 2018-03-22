//
//  DRDreamViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRDreamViewController: UIViewController {
    
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
    
    @IBOutlet weak var timerLabel: DRTimerLabel!
    @IBOutlet weak var targetCreditsLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var creditsTextField: UITextField!
    @IBOutlet weak var timerProgressView: DRTimerCircleProgressView!
    @IBOutlet weak var creditsProgressView: UICircleProgressView!
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = self.dream?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCreditslabel()
        self.updateCreditsProgress()
        
        if let startDate = self.dream?.startDate, let targetDate = self.dream?.targetDate  {
            self.timerProgressView.scheduleTimer(startDate: startDate, targetDate: targetDate)
            self.timerLabel.scheduleTimer(targetDate: targetDate)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timerProgressView.invalidateTimer()
        self.timerLabel.invalidateTimer()
    }
    
    // MARK: Methods

    private func updateCreditsProgress() {
        self.creditsProgressView.value = Float(self.creditsProgress)
        self.percentageLabel.text = " \(Int(self.creditsProgress * 100))%"
    }
    
    private func updateCreditslabel() {
        DispatchQueue.main.async {
            let credits = self.dream?.currentCredits ?? 0
            self.targetCreditsLabel.text = String(format: "%.f$", credits)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func minusTouchDown(_ sender: UIButton) {
        self.minus()
        self.setTimer(selector: #selector(self.minus))
    }
    
    @IBAction func minusTouchUpInside(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func minusTouchDragExit(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func plusTouchDown(_ sender: UIButton) {
        self.plus()
        self.setTimer(selector: #selector(self.plus))
    }

    @IBAction func plusTouchUpInside(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func plusDragExit(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func minus() {
        let money = Int(self.creditsTextField.text ?? "") ?? 0
        self.creditsTextField.text = String(money-1)
        self.setTimer(selector: #selector(self.minus))
    }
    
    @objc private func plus() {
        let money = Int(self.creditsTextField.text ?? "") ?? 0
        self.creditsTextField.text = String(money+1)
        self.setTimer(selector: #selector(self.plus))
    }
    
    private func setTimer(selector: Selector) {
        let timeInterval = (self.timer?.timeInterval ?? 1.0) < 0.01 ? 0.01 : (self.timer?.timeInterval ?? 1.0) * 2/3
        
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @IBAction func add(_ sender: UIButton) {
        guard let dream = self.dream, let creditsToAdd = Double(self.creditsTextField.text ?? String()) else {
            return
        }

        dream.add(credits: creditsToAdd)
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
