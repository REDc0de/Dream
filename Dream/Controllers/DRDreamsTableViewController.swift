//
//  DRDreamsTableViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRDreamsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    fileprivate var dreams           = [Dream]()
    fileprivate var filteredDreams   = [Dream]()
    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
        
        clearsSelectionOnViewWillAppear = true
        tableView.backgroundView = DREmtyTableView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isNeedToPresentIntro = UserDefaults.standard.bool(forKey: "isNeedToPresentIntro")
        
        if !isNeedToPresentIntro {
            performSegue(withIdentifier: "DRIntoViewController", sender: self)
        }
    }
    
    // MARK: - Methods
    
    fileprivate func isFiltering() -> Bool {
        
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    fileprivate func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater                 = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController            = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        self.definesPresentationContext = true
    }
    
    fileprivate func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let dream = dreams[sourceIndex]
        dreams.remove(at: sourceIndex)
        dreams.insert(dream, at: destinationIndex)
    }
    
    @objc fileprivate func update() {
        dreams         = CoreDataManager.sharedInstance.fetchDreams()
        filteredDreams = dreams
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.refreshControl?.endRefreshing()
        })
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = dreams.count != 0
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFiltering() ? filteredDreams.count : dreams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRDreamsTableViewControllerCell", for: indexPath)
        
        let dreamsArray = isFiltering() ? filteredDreams : dreams
        
        if let cell = cell as? DRDreamTableViewCell {
            cell.nameLabel.text = dreamsArray[indexPath.row].name
            cell.creditsLabel.text = String(format: "%.f$", dreamsArray[indexPath.row].currentCredits) + "/" + String(format: "%.f$", dreamsArray[indexPath.row].targetCredits)
            cell.dateLabel.text = Date().offset(to: dreamsArray[indexPath.row].targetDate ?? Date())
            cell.backgroundImageView.image = UIImage(data: dreamsArray[indexPath.row].image ?? Data())
        }

        
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
            
            if isFiltering() {
                dream = filteredDreams[indexPath.row]
                filteredDreams.remove(at: indexPath.row)
            } else {
                dream = dreams[indexPath.row]
            }
            
            guard let index = dreams.index(of: dream) else {
                return
            }
            
            dreams.remove(at: index)
            
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
        if let cell = sender as? DRDreamTableViewCell {
            guard let indexPath      = tableView.indexPath(for: cell)              else { return }
            guard let viewController = segue.destination as? DRDreamViewController else { return }
            
            let array = isFiltering() ? filteredDreams : dreams
            viewController.dream = array[indexPath.row]
        }
    }
    
}

extension DRDreamsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            filteredDreams = dreams.filter({( dream : Dream) -> Bool in
                
                return dream.name?.lowercased().contains((searchController.searchBar.text ?? String()).lowercased()) ?? false
            })
        }
        self.tableView.reloadData()
    }
    
}
