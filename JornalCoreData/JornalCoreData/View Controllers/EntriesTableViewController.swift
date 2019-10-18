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
    let entryController = EntryController()
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "mood", ascending: true),
        NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "mood", cacheName: nil)
        ftc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section].name else {return nil}
        return sectionInfo.title
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell() }
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
        }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.deletedEntry(entry: entry) { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
//              else if editingStyle == .insert {
//           Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
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
            vc.entry = fetchedResultsController.object(at: indexPath)
            vc.entryController = entryController
        } else if segue.identifier == "AddJournalEntry" {
            guard let vc = segue.destination as? EntryDetailViewController else { return }
                vc.entryController = entryController
            }
        }
    }
extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
     
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchedResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .right)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .left)
        default:
            break
        }
        
    }
            

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // newIndexPath is option because you'll only get it for insert and move

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update: guard let indexPath = indexPath else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
}
