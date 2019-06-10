//
//  DataActorController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DataActorController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ActorProtocol {
    
    // MARK: - Variables
    
    var myTabBar: ActorTabBarController! {
        return tabBarController as? ActorTabBarController
    }
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescrip: UITextView!
    @IBOutlet weak var pickerComple: UIPickerView!
    @IBOutlet weak var txtDescComple: UITextField!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    @IBOutlet weak var txtVer: UITextField!
    @IBOutlet weak var picketDate: UIDatePicker!
    var activityIndicator : NVActivityIndicatorView!
    var actor = Actor()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actor.delegate = self
        self.txtComen.delegate = self
        self.txtDescrip.delegate = self
        self.pickerComple.dataSource = self
        self.pickerComple.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        self.picketDate.datePickerMode = .date 
        if(myTabBar.idActor != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/actor_search.php?a=\(myTabBar.idActor)"
            actor.getActor(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            myTabBar.actor = self.actor
            self.pickerComple.selectRow((self.actor.comple-1), inComponent: 0, animated: false)
        }
    }
    
    // MARK: - WebServices
    
    func gotActor(actor: Actor, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.actor = actor
            myTabBar.actor = self.actor
            txtName.text = self.actor.name
            txtVer.text = String(self.actor.version)
            picketDate.date  = self.actor.date
            txtDescrip.text = self.actor.descrip
            txtDescComple.text = self.actor.descComple
            self.pickerCateg.selectRow((self.actor.category-1), inComponent: 0, animated: false)
            self.pickerComple.selectRow((self.actor.comple-1), inComponent: 0, animated: false)
            txtComen.text = self.actor.comentary
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return AppDelegate.COMPLEXITY.count
        }else{
            return AppDelegate.CATEGORY.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return AppDelegate.COMPLEXITY[row+1]
        }else{
            return String(AppDelegate.CATEGORY[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            for i in 1...AppDelegate.COMPLEXITY.count{
                if(AppDelegate.COMPLEXITY[row+1]!.elementsEqual(AppDelegate.COMPLEXITY[i]!)){
                    actor.comple = i
                    break
                }
            }
        }else{
            actor.category = AppDelegate.CATEGORY[row]
        }
    }
    
    // MARK: - Text
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.tag == 3){
            actor.descrip = txtDescrip.text!
        }
        if(textView.tag == 5){
            actor.comentary = txtComen.text!
        }
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if(sender.tag == 2){
            actor.name = txtName.text!
        }
        if(sender.tag == 4){
            actor.descComple = txtDescComple.text!
        }
        if(sender.tag == 6){
             actor.version = Utils.StringToDouble(string: txtVer.text!)
        }
    }
    
    // MARK: - DatePicker
    
    @IBAction func pickerChanged(_ sender: Any) {
         actor.date = picketDate.date
    }

}
