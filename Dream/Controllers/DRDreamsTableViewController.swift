//
//  DRDreamsTableViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRDreamsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    fileprivate var dreams           = [Dream]()
    fileprivate var filteredDreams   = [Dream]()
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        self.setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dreams         = CoreDataManager.sharedInstance.fetchDreams()
        self.filteredDreams = self.dreams
        self.tableView.reloadData()
    }
    
    // MARK: Methods
    
    fileprivate func isFiltering() -> Bool {
        
        return self.searchController.isActive && !self.searchBarIsEmpty()
    }
    
    fileprivate func searchBarIsEmpty() -> Bool {
        
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.searchController.searchResultsUpdater                 = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController            = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        self.definesPresentationContext = true
    }
    
    private func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let dream = self.dreams[sourceIndex]
        self.dreams.remove(at: sourceIndex)
        self.dreams.insert(dream, at: destinationIndex)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isFiltering() ? self.filteredDreams.count : self.dreams.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRDreamsTableViewControllerCell", for: indexPath)
        
        let dreams = self.isFiltering() ? self.filteredDreams : self.dreams
        cell.textLabel?.text = dreams[indexPath.row].name
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            var dream = Dream()
            
            if self.isFiltering() {
                dream = self.filteredDreams[indexPath.row]
                self.filteredDreams.remove(at: indexPath.row)
            } else {
                dream = self.dreams[indexPath.row]
            }
            
            guard let index = self.dreams.index(of: dream) else {
                return
            }
            
            self.dreams.remove(at: index)
            
            CoreDataManager.sharedInstance.deleteDream(dream)
            CoreDataManager.sharedInstance.saveContext()

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            guard let indexPath      = tableView.indexPath(for: cell)              else { return }
            guard let viewController = segue.destination as? DRDreamViewController else { return }
            
            let array = self.isFiltering() ? self.filteredDreams : self.dreams
            viewController.dream = array[indexPath.row]
        }
    }
    
}

extension DRDreamsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.filteredDreams = self.dreams.filter({( dream : Dream) -> Bool in
                
                return dream.name?.lowercased().contains((searchController.searchBar.text ?? String()).lowercased()) ?? false
            })
        }
        self.tableView.reloadData()
    }
    
}
