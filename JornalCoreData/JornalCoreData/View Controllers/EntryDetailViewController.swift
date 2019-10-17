//
//  EntryDetailViewController.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import UIKit

enum Moods: Int, CaseIterable {
    case sad = 0
    case happy = 1
    case crazy = 2
    
    var moodName: String {
        switch self {
        case .sad:
            return "😞"
        case .happy:
            return "😃"
        case .crazy:
            return "🙃"
        }
    }
}

class EntryDetailViewController: UIViewController {
    
//    MARK: - Properties
    
    var selectedMood: Moods?
    var entryController: EntryController?
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
//    MARK: - Outlets
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var journaltitleEntry: UITextField!
    @IBOutlet weak var journalBodyEntry: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //    MARK: - Actions
    
    @IBAction func moodValueChanged(_ sender: Any) {
        updateMood()
    }
    
    
    @IBAction func textEditingDidChange(_ sender: Any) {
        if let name = journaltitleEntry.text, !name.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    @IBAction func saveTapped(_ sender: Any) {
         guard let title = journaltitleEntry.text,
            let bodyText = journalBodyEntry.text,
            let mood = selectedMood,
            !title.isEmpty else { return }
        
        if let entry = entry {
            entryController?.updateEntry(title: title, bodyText: bodyText, mood: mood.moodName, entry: entry)
        } else {
            entryController?.createEntry(title: title, bodyText: bodyText, mood: mood.moodName)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
// MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
//    MARK: - Private Functions
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        guard let entry = entry else {
        title = "Create Journal Entry"
        moodSegmentedControl.selectedSegmentIndex = 1
        selectedMood = .happy
            saveButton.isEnabled = false
            return
        }
        
        title = entry.title
        journaltitleEntry.text = entry.title
        journalBodyEntry.text = entry.bodyText
        
        switch entry.mood {
            
        case "😞":
            selectedMood = .sad
            moodSegmentedControl.selectedSegmentIndex = 0
        case "😃":
            selectedMood = .happy
            moodSegmentedControl.selectedSegmentIndex = 1
        case "🙃":
            selectedMood = .crazy
            moodSegmentedControl.selectedSegmentIndex = 2
        default:
            selectedMood = .happy
            moodSegmentedControl.selectedSegmentIndex = 1
        }
    }

    
    
    private func updateMood() {
        
        switch moodSegmentedControl.selectedSegmentIndex {
            
        case 0:
        selectedMood = .sad
        case 1:
        selectedMood = .happy
        case 2:
        selectedMood = .crazy
            
        default:
            selectedMood = .happy
        }
    }
    
}
