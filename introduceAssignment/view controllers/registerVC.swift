//
//  registerVC.swift
//  introduceAssignment
//
//  Created by madhur bansal on 5/11/21.
//

import UIKit

class registerVC: UIViewController
{
    @IBOutlet weak var scrollViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var homeTownTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var DOBTextField: UITextField!
    @IBOutlet weak var telephonicNumberTextField: UITextField!
    @IBOutlet weak var lastNametextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    var mfirebaseManager:firebaseManager!
    var numberArray:[Int] = []
    let datePicker = UIDatePicker()
    let dropPicker = UIPickerView()
    let genderOptions:[String] = ["Male","Female"]
    var selectedGender = "Male"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mfirebaseManager = firebaseManager()
        setUpController()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        getData()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getData()
    {
        mfirebaseManager.fetchUsers { (enrolledUsers) in
            var numberArray:[Int] = []
            for user in enrolledUsers
            {
                numberArray.append(user.phoneNumber)
            }
            self.numberArray = numberArray
        }
    }
    
    @IBAction func selectPhotoPressed(_ sender: Any)
    {
        let alert = UIAlertController(title: "SELECT A METHOD", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:{action in self.takePhotoHandler()}))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {action in self.choosePhotoHandler()}))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func addUserPressed(_ sender: Any)
    {
        if profileImageView.image == UIImage(systemName: "profile")
        {
            self.presentAlertController("MESSAGE", "please upload your profile photo")
        }
        else if phoneNumberTextField.text!.isEmpty || homeTownTextField.text!.isEmpty || stateTextField.text!.isEmpty || countryTextField.text!.isEmpty || genderTextField.text!.isEmpty || DOBTextField.text!.isEmpty || telephonicNumberTextField.text!.isEmpty || lastNametextField.text!.isEmpty || firstNameTextField.text!.isEmpty
        {
            self.presentAlertController("MESSAGE", "please fill all the details")
        }
        else if !FormUtilities.isPhoneNumberValid(phoneNumberTextField.text!)
        {
            self.presentAlertController("MESSAGE", "please enter a valid phone number")
        }
        else if !FormUtilities.isPhoneNumberValid(telephonicNumberTextField.text!)
        {
            self.presentAlertController("MESSAGE", "please enter a valid telephone number")
        }
        else
        {
            adduser()
        }
    }
}

extension registerVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else{return}
        profileImageView.image = image
    }
    
    func takePhotoHandler()
    {
        let invc = UIImagePickerController()
        invc.delegate = self
        invc.sourceType = .camera
        invc.allowsEditing = true
        invc.modalPresentationStyle = .fullScreen
        present(invc, animated: true, completion: nil)
    }
    
    func choosePhotoHandler()
    {
        let invc = UIImagePickerController()
        invc.delegate = self
        invc.sourceType = .photoLibrary
        invc.allowsEditing = true
        invc.modalPresentationStyle = .fullScreen
        present(invc, animated: true, completion: nil)
    }
    
    @objc func dropDonePressed()
    {
        genderTextField.text = selectedGender
        view.endEditing(true)
    }
    
    @objc func dismissMyKeyboard()
    {
        view.endEditing(true)
    }
    
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        DOBTextField.inputAccessoryView = toolbar
        DOBTextField.inputView = datePicker
    }
    
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        DOBTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func adduser()
    {
        let name = "\(firstNameTextField.text!) \(lastNametextField.text!)"
        let number = Int(phoneNumberTextField.text!)!
        let telephonicNumber = Int(telephonicNumberTextField.text!)!
        
        if numberArray.contains(number)
        {
            self.presentAlertController("MESSAGE", "this number is already registered")
        }
        else
        {
            self.startAtcivityIndicator()
            mfirebaseManager.enrollUser(profileImage: profileImageView.image!, name: name, number: number, telephoneNumber: telephonicNumber, gender: genderTextField.text!, country: countryTextField.text!, state: stateTextField.text!, homeTown: homeTownTextField.text!, dateOfbirth: DOBTextField.text!) { (message) in
                self.stopActivityIndicator()
                self.numberArray.append(number)
                self.presentAlertController("MESSAGE", message)
            }
        }
    }
    
    func setUpController()
    {
        dropPicker.delegate = self
        dropPicker.dataSource = self
        
        setTextField(textField:phoneNumberTextField)
        setTextField(textField:homeTownTextField)
        setTextField(textField:stateTextField)
        setTextField(textField:countryTextField)
        setTextField(textField:genderTextField)
        setTextField(textField:DOBTextField)
        setTextField(textField:telephonicNumberTextField)
        setTextField(textField:lastNametextField)
        setTextField(textField:firstNameTextField)
    }
    
    func setTextField(textField:UITextField)
    {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.cornerRadius = 5
        textField.setIndendation(left: 10, right: 10)
        if textField == DOBTextField
        {
            showDatePicker()
        }
        else
        {
            let bar = UIToolbar()
            var doneBtn:UIBarButtonItem!
            if textField == genderTextField
            {
                textField.inputView = dropPicker
                doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dropDonePressed))
            }
            else
            {
                doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
            }
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            bar.items = [flexSpace, flexSpace, doneBtn]
            bar.sizeToFit()
            textField.inputAccessoryView = bar
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollViewConstraint.constant = keyboardSize.height - 50
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollViewConstraint.constant = 10
    }
}


//   functions for dropdown
extension registerVC:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedGender = genderOptions[row]
    }
}
