//
//  DRHistoryTableViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRHistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    public var dream: Dream?
    public var transactions: [Transaction] = [Transaction]()
    
    // MARK: - Lifecicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.transactions = [Transaction]()
        
        let array = self.dream?.transactions ?? []
        
        for item in array {
            if let transaction = item as? Transaction {
                self.transactions.append(transaction)
            }
        }
        
        self.transactions = self.transactions.sorted(by: {$0.date! > $1.date!})
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.transactions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRHistoryTableViewController", for: indexPath)
        
        let string = self.transactions[indexPath.row].credits > 0 ? ("+" + String(self.transactions[indexPath.row].credits)) : String(self.transactions[indexPath.row].credits)
        cell.textLabel?.text = string
        cell.textLabel?.textColor = self.transactions[indexPath.row].credits < 0 ? .thunderbird : .shamrock
        
        let date = self.transactions[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let result = formatter.string(from: date ?? Date())
        
        cell.detailTextLabel?.text = result

        return cell
    }
    
}
