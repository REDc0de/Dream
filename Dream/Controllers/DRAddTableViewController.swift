//
//  DRAddTableViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRAddTableViewController: UITableViewController {
    
    // MARK: - Constants
    
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    
    private var isDatePickerVisible: Bool = false
    
    private var currentAmount: Int?
    private var targetAmount : Int?
    private var image        : UIImage?
    private var name         : String?
    private var info         : String?
    
    private var startDate    : Date?
    private var targetDate   : Date = Date() {
        didSet {
            targetDateLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .short)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetAmountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var targetDateLabel: UILabel!
    @IBOutlet weak var dreamImageView: UIImageView!
    @IBOutlet weak var infoView: UITextView!

    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        datePicker.minimumDate = Date()
        
        targetDate = Date()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dissmissKeyboard()
    }
    
    // MARK: - Methods
    
    private func toggleDatePicker() {
        isDatePickerVisible = !isDatePickerVisible
        
        datePicker.date = targetDate
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType    = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        imagePicker.sourceType    = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func dissmissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        // For tests
        CoreDataManager.sharedInstance.addDream(uuid          : UUID().uuidString,
                                                name          : nameTextField.text ?? "Dream",
                                                startDate     : Date(),
                                                targetDate    : targetDate,
                                                currentCredits: 0,
                                                targetCredits : Double(targetAmountTextField.text!)!,
                                                image         : UIImagePNGRepresentation(dreamImageView.image ?? UIImage())!,
                                                info          : infoView.text ?? "")
        CoreDataManager.sharedInstance.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if !isDatePickerVisible { datePicker = UIDatePicker()
            return }
        targetDate = datePicker.date
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            showImagePickerActionSheet()
        case 3:
            toggleDatePicker()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isDatePickerVisible && indexPath.row == 4 {
            
            return 0
        } else {
            
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
}

extension DRAddTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isDatePickerVisible { toggleDatePicker() }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dissmissKeyboard()
        
        return true
    }
    
}

extension DRAddTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dreamImageView.image =  info[UIImagePickerControllerEditedImage] as? UIImage == nil ? info[UIImagePickerControllerOriginalImage] as? UIImage : info[UIImagePickerControllerEditedImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
