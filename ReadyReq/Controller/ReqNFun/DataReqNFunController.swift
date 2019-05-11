//
//  DataReqNFunController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 14/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DataReqNFunController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ReqNFunProtocol {
    
    // MARK: - Variables
    
    var myTabBar: ReqNFunTabBarController! {
        return tabBarController as? ReqNFunTabBarController
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
    var reqnfun = ReqNFun()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reqnfun.delegate = self
        self.txtComen.delegate = self
        self.pickerPrior.dataSource = self
        self.pickerPrior.delegate = self
        self.pickerUrge.dataSource = self
        self.pickerUrge.delegate = self
        self.pickerEstab.dataSource = self
        self.pickerEstab.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        if(myTabBar.idReqNFun != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqnfun_search.php?a=\(myTabBar.idReqNFun)"
            reqnfun.getReqNFun(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            myTabBar.reqnfun = self.reqnfun
            self.pickerPrior.selectRow((self.reqnfun.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqnfun.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqnfun.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqnfun.state, animated: false)
        }
    }
    
    // MARK: - WebServices
    
    func gotReqNFun(reqnfun: ReqNFun, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.reqnfun = reqnfun
            myTabBar.reqnfun = self.reqnfun
            txtName.text = self.reqnfun.name
            txtDescrip.text = self.reqnfun.descrip
            self.pickerPrior.selectRow((self.reqnfun.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqnfun.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqnfun.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqnfun.state, animated: false)
            self.pickerCateg.selectRow((self.reqnfun.category-1), inComponent: 0, animated: false)
            txtComen.text = self.reqnfun.comentary
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
                    reqnfun.prior = i
                    break
                }
            }
        } else if(pickerView.tag == 2){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqnfun.urge = i
                    break
                }
            }
        } else if(pickerView.tag == 3){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqnfun.esta = i
                    break
                }
            }
        }else{
            reqnfun.category = AppDelegate.CATEGORY[row]
        }
    }
    
    // MARK: - Switch
    
    @IBAction func switchStateDidChange(_ sender: Any) {
        if (self.switchState.isOn){
            reqnfun.state = true
        }else{
            reqnfun.state = false
        }
    }
    
    // MARK: - Text
    
    func textViewDidChange(_ textView: UITextView) {
        reqnfun.comentary = txtComen.text!
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if(sender.tag == 4){
            reqnfun.name = txtName.text!
        }
        if(sender.tag == 5){
            reqnfun.descrip = txtDescrip.text!
        }
    }
    
}
