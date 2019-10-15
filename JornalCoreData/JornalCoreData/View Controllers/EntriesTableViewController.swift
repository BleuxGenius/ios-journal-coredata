//
//  EntriesTableViewController.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
//    constant
    let  entryController = EntryController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddJournalEntry", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        cell.entry = entryController.entries[indexPath.row]
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = entryController.entries[indexPath.row]
            entryController.deletedEntry(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
//                    } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowJournalEntry" {
            guard let vc = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else {
                    return
            }
            vc.entry = entryController.entries[indexPath.row]
            vc.entryController = entryController
        } else if segue.identifier == "AddJournalEntry" {
            guard let vc = segue.destination as? EntryDetailViewController
                else {return}
            vc.entryController = entryController
        }
    }
 

}
