//
//  SettingsVC.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/25/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    //MARL: - OUTLES
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: - VARIABLES
    private let languages = [Constants.ENGLISH_LANGUAGE, Constants.ARABIC_LANGUAGE]
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let choosenLanguage = UserDefaults.standard.string(forKey: Constants.LANGUAGE_KEY) {
            switch choosenLanguage {
            case Constants.ENGLISH_LANGUAGE:
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                changeLanguage(toLanguage: "en")
            case Constants.ARABIC_LANGUAGE:
                self.pickerView.selectRow(1, inComponent: 0, animated: true)
                changeLanguage(toLanguage: "ar")
            default:
                return
            }
        }
    }
    
    //CHANGE LANGUAGE OF SAVE BUTTON
    private func changeLanguage(toLanguage language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        saveButton.title = bundle?.localizedString(forKey: "saveButton", value: nil, table: nil)
    }
    
    //SAVE SELECTED LANGUAGE
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        saveLanguage()
    }
    
    //SAVE SELECTED LANGUAGE
    private func saveLanguage() {
        let choosenLanguage = languages[pickerView.selectedRow(inComponent: 0)]
        UserDefaults.standard.setValue(choosenLanguage, forKey: Constants.LANGUAGE_KEY)
        navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - EXTENSIONS
//MARK: - PICKER VIEW DATA SOURCE EXTENSION
extension SettingsVC: UIPickerViewDataSource {
    
    //NUMBER OF COMPONENTS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //NUMBER OF ROWS
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    //ROW HEIGHT
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    //ROW TITLE
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
}

//MARK: - PICKER VIEW DELEGATE EXTENSION
extension SettingsVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
