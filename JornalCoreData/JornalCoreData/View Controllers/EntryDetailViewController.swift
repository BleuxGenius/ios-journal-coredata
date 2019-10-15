//
//  EntryDetailViewController.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    
    @IBOutlet weak var journaltitleEntry: UITextField!
    @IBOutlet weak var journalBodyEntry: UITextView!
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let entryController = entryController,
            let title = journaltitleEntry.text, !title.isEmpty,
            let body = journalBodyEntry.text
            else { return }
        
        if let entry = entry {
            entryController.updateEntry(entry: entry, newTitle: title, newBody: body)
        } else {
            entryController.createEntry(title: title, bodyText: body)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    var entryController: EntryController?
    var entry: Entry?
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Journal Entry"
        journaltitleEntry.text = entry?.title ?? ""
        journalBodyEntry.text = entry?.bodyText ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
