//
//  DRAddTableViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit
import AVKit
import Photos.PHPhotoLibrary

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
        
        imagePicker.delegate      = self
        imagePicker.allowsEditing = true
        
        datePicker.minimumDate = Date()
        
        targetDate = Date()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
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
        let actionSheet = UIAlertController(title: "Source Type", message: "Choose source type for picking image", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.presentCamera()
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.presentPhotoLibrary()
            }))
        }
        
        if actionSheet.actions.isEmpty {
            // Case that should never happen
            presentAlert(title: "Warning", message: "No available source type.")
            
            return
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func presentCamera() {
        imagePicker.sourceType = .camera
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .restricted:
            presentAlertWhenStatus(isDenied: false, sourceType: .camera)
        case .denied:
            presentAlertWhenStatus(isDenied: true, sourceType: .camera)
        case .authorized:
            present(imagePicker, animated: true)
        case .notDetermined:
            present(imagePicker, animated: true) {
                AVCaptureDevice.requestAccess(for: .video) {
                    guard !$0 else {
                        
                        return
                    }
                    DispatchQueue.main.async {
                       self.imagePicker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func presentPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary

        switch PHPhotoLibrary.authorizationStatus() {
        case .restricted:
            presentAlertWhenStatus(isDenied: false, sourceType: .photoLibrary)
        case .denied:
            presentAlertWhenStatus(isDenied: true, sourceType: .photoLibrary)
        case .authorized:
            present(imagePicker, animated: true)
        case .notDetermined:
            present(imagePicker, animated: true) {
                PHPhotoLibrary.requestAuthorization {
                    guard $0 != .authorized else {
                        
                        return
                    }
                    DispatchQueue.main.async {
                        self.imagePicker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    fileprivate func presentAlertWhenStatus(isDenied: Bool, sourceType: UIImagePickerControllerSourceType) {
        
        let info: (title: String, message: String)
        
        if sourceType == .camera {
            if isDenied {
                info = (
                    NSLocalizedString("Camera access is denied", comment: "Title for alert when camera access is denied by user"),
                    NSLocalizedString("The application needs access to the camera. Do you want to open the settings and allow the application to use the camera?", comment: "Message for alert when camera access is denied by user")
                )
            }
            else {
                info = (
                    NSLocalizedString("You are not allowed to access the camera", comment: "Title for alert when camera access is restricted for user"),
                    NSLocalizedString("The application needs access to the camera. Do you want to open the settings and allow the application to use the camera?", comment: "Message for alert when camera access is restricted for user")
                )
            }
        }
        else if isDenied {
            info = (
                NSLocalizedString("Photos access is denied", comment: "Title for alert when Photos access is denied by user"),
                NSLocalizedString("The application needs access to the Photos. Do you want to open the settings and allow the application to use the Photos?", comment: "Message for alert when Photos access is denied by user")
            )
        }
        else {
            info = (
                NSLocalizedString("You are not allowed to access the Photos", comment: "Title for alert when Photos access is restricted for user"),
                NSLocalizedString("The application needs access to the Photos. Do you want to open the settings and allow the application to use the Photos?", comment: "Message for alert when Photos access is restricted for user")
            )
        }
        
        let action = { (url: URL?) -> Swift.Void in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        presentAlert(
            title    : info.title,
            message  : info.message,
            yesAction: { action(URL(string: UIApplicationOpenSettingsURLString)) },
            noAction : { action(nil) }
        )
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

extension DRAddTableViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isDatePickerVisible { toggleDatePicker() }
        
        return true
    }
    
}

extension DRAddTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dreamImageView.image =  info[UIImagePickerControllerEditedImage] as? UIImage == nil ? info[UIImagePickerControllerOriginalImage] as? UIImage : info[UIImagePickerControllerEditedImage] as? UIImage
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
