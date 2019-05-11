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
    var activityIndicator : NVActivityIndicatorView!
    var idWorker : Int = 0
    var worker = Worker()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worker.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        
        if(idWorker != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = "http://" + MyUserDefaults.readUDServerIp() + ":8080/readyreq/group_search.php?a=\(idWorker)"
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
            let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/group_delete.php?a=\(worker.id)"
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let webServices = Utils()
            webServices.delegateCUD = self
            webServices.create_update_delete(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        worker.name = txtName.text!
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
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/group_"
        if(idWorker != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(worker.id)&b=\(worker.name)&c=\(worker.organization)&d=\(worker.role)&"
            if(worker.developer){ urlPath += "e=\(1)&" }else{ urlPath += "e=\(0)&" }
            urlPath += "f=\(worker.category)&g=\(worker.comentary)"
        }else{
            urlPath += "create.php?a=\(worker.name)&b=\(worker.organization)&c=\(worker.role)&"
            if(worker.developer){ urlPath += "d=\(1)&" }else{ urlPath += "d=\(0)&" }
            urlPath += "e=\(worker.category)&f=\(worker.comentary)"
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
