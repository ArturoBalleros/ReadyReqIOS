//
//  DataObjetiveController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 12/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DataObjetiveController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ObjetiveProtocol {
    
    // MARK: - Variables
    
    var myTabBar: ObjetiveTabBarController! {
        return tabBarController as? ObjetiveTabBarController
    }
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescrip: UITextField!
    @IBOutlet weak var pickerPrior: UIPickerView!
    @IBOutlet weak var pickerUrge: UIPickerView!
    @IBOutlet weak var pickerEstab: UIPickerView!
    @IBOutlet weak var switchState: UISwitch!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    var activityIndicator : NVActivityIndicatorView!
    var objetive = Objetive()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objetive.delegate = self
        self.txtComen.delegate = self
        self.pickerPrior.dataSource = self
        self.pickerPrior.delegate = self
        self.pickerUrge.dataSource = self
        self.pickerUrge.delegate = self
        self.pickerEstab.dataSource = self
        self.pickerEstab.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        if(myTabBar.idObjetive != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/objet_search.php?a=\(myTabBar.idObjetive)"
            objetive.getObjetive(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            myTabBar.objetive = self.objetive
            self.pickerPrior.selectRow((self.objetive.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.objetive.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.objetive.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.objetive.state, animated: false)
        }
    }
    
    // MARK: - WebServices
    
    func gotObjetive(objetive: Objetive, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.objetive = objetive
            myTabBar.objetive = self.objetive
            txtName.text = self.objetive.name
            txtDescrip.text = self.objetive.descrip
            self.pickerPrior.selectRow((self.objetive.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.objetive.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.objetive.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.objetive.state, animated: false)
            self.pickerCateg.selectRow((self.objetive.category-1), inComponent: 0, animated: false)
            txtComen.text = self.objetive.comentary
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag != 0){
            return AppDelegate.RANGE_VALUES.count
        }else{
            return AppDelegate.CATEGORY.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag != 0){
            return AppDelegate.RANGE_VALUES[row+1]
        }else{
            return String(AppDelegate.CATEGORY[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    objetive.prior = i
                    break
                }
            }
        } else if(pickerView.tag == 2){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    objetive.urge = i
                    break
                }
            }
        } else if(pickerView.tag == 3){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    objetive.esta = i
                    break
                }
            }
        }else{
            objetive.category = AppDelegate.CATEGORY[row]
        }
    }
    
    // MARK: - Switch
    
    @IBAction func switchStateDidChange(_ sender: Any) {
        if (self.switchState.isOn){
            objetive.state = true
        }else{
            objetive.state = false
        }
    }
    
    // MARK: - Text
    
    func textViewDidChange(_ textView: UITextView) {
        objetive.comentary = txtComen.text!
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if(sender.tag == 4){
            objetive.name = txtName.text!
        }
        if(sender.tag == 5){
            objetive.descrip = txtDescrip.text!
        }
    }
    
}
