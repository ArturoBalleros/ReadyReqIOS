//
//  DataGroupController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 07/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DataGroupController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, WorkerProtocol, CUDProtocol {
    
    // MARK: - Variables
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtOrg: UITextField!
    @IBOutlet weak var txtRol: UITextField!
    @IBOutlet weak var switchDevel: UISwitch!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    @IBOutlet weak var txtVer: UITextField!
    @IBOutlet weak var picketDate: UIDatePicker!
    var activityIndicator : NVActivityIndicatorView!
    var idWorker : Int = 0
    var worker = Worker()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worker.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        self.picketDate.datePickerMode = .date
        if(idWorker != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/group_search.php?a=\(idWorker)"
            worker.getWorker(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }
    }
    
    // MARK: - WebServices
    
    func gotWorker(worker: Worker, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.worker = worker
            txtName.text = self.worker.name
            txtOrg.text = self.worker.organization
            txtRol.text = self.worker.role
            txtVer.text = String(self.worker.version)
            picketDate.date  = self.worker.date
            self.pickerCateg.selectRow((self.worker.category-1), inComponent: 0, animated: false)
            self.switchDevel.setOn(self.worker.developer, animated: false)
            txtComen.text = self.worker.comentary
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
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if(idWorker != AppDelegate.NOTHING){
            
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
                
                let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/group_delete.php?a=\(self.worker.id)"
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
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        worker.name = txtName.text!
        worker.version = Utils.StringToDouble(string: txtVer.text!)
        worker.date = picketDate.date
        worker.organization = txtOrg.text!
        worker.role = txtRol.text!
        worker.comentary = txtComen.text!
        saveWorker()
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
        worker.category = AppDelegate.CATEGORY[row]
    }
    
    // MARK: - Switch
    
    @IBAction func switchStateDidChange(_ sender: Any) {
        if (self.switchDevel.isOn){
            worker.developer = true
        }else{
            worker.developer = false
        }
    }
    
    // MARK: - Methods
    
    func saveWorker(){
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/group_"
        if(idWorker != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(worker.id)&b=\(worker.name)&c=\(worker.version)&d=\(Utils.DateToString(date: worker.date))&"
            urlPath += "e=\(worker.organization)&f=\(worker.role)&"
            if(worker.developer){ urlPath += "g=\(1)&" }else{ urlPath += "g=\(0)&" }
            urlPath += "h=\(worker.category)&i=\(worker.comentary)"
        }else{
            urlPath += "create.php?a=\(worker.name)&b=\(worker.version)&c=\(Utils.DateToString(date: worker.date))&"
            urlPath += "d=\(worker.organization)&e=\(worker.role)&"
            if(worker.developer){ urlPath += "f=\(1)&" }else{ urlPath += "f=\(0)&" }
            urlPath += "g=\(worker.category)&h=\(worker.comentary)"
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
