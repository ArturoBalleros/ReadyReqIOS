//
//  DataPackageController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 09/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DataPackageController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PackageProtocol, CUDProtocol {
    
    // MARK: - Variables
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    @IBOutlet weak var txtVer: UITextField!
    @IBOutlet weak var picketDate: UIDatePicker!
    var activityIndicator : NVActivityIndicatorView!
    var idPackage : Int = 0
    var package = Package()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        package.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        self.picketDate.datePickerMode = .date
        if(idPackage != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/paq_search.php?a=\(idPackage)"
            package.getPackage(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }
    }
    
    // MARK: - WebServices
    
    func gotPackage(package: Package, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.package = package
            txtName.text = self.package.name
            txtVer.text = String(self.package.version)
            picketDate.date  = self.package.date
            self.pickerCateg.selectRow((self.package.category-1), inComponent: 0, animated: false)
            txtComen.text = self.package.comentary
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    func gotResul(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        self.dismiss(animated: true)
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        package.name = txtName.text!
        package.version = Utils.StringToDouble(string: txtVer.text!)
        package.date = picketDate.date
        package.comentary = txtComen.text!
        savePackage()
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if(idPackage != AppDelegate.NOTHING){
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
                
                let urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/paq_delete.php?a=\(self.package.id)"
                self.activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
                let webServices = Utils()
                webServices.delegateCUD = self
                webServices.create_update_delete(url: URL(string: urlPath)!, activityIndicator: self.activityIndicator)
                
            }
            controller.addAction(action)
            controller.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil))
            self.present(controller, animated: true)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppDelegate.CATEGORY.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(AppDelegate.CATEGORY[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        package.category = AppDelegate.CATEGORY[row]
    }
    
    // MARK: - Methods
    
    func savePackage(){
        var urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/paq_"
        if(idPackage != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(package.id)&b=\(package.name)&c=\(package.version)&d=\(Utils.DateToString(date: package.date))&"
            urlPath += "e=\(package.category)&f=\(package.comentary)"
        }else{
            urlPath += "create.php?a=\(package.name)&b=\(package.version)&c=\(Utils.DateToString(date: package.date))&"
            urlPath += "d=\(package.category)&e=\(package.comentary)"
        }
        urlPath = Utils.convert_Url(url: urlPath)
        if(!urlPath.elementsEqual("ERROR")){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let webServices = Utils()
            webServices.delegateCUD = self
            webServices.create_update_delete(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            ToolsView.showToast(message: NSLocalizedString("ERROR_URL", comment: ""), controller: self)
        }
    }
}
