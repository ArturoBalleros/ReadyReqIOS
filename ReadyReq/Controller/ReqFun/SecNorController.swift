//
//  SecNorController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 15/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SecNorController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    @IBOutlet weak var buttonSelect: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textItem: UITextField!
    var myTabBar: ReqFunTabBarController!
    var activityIndicator : NVActivityIndicatorView!
    var flagSelect = true
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabBar = tabBarController as? ReqFunTabBarController
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - WebServices
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTabBar.reqfun.secNor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (myTabBar.reqfun.secNor[indexPath.row] as! Generic).name
        if (myTabBar.reqfun.secNor[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
        }else{ cell.accessoryType = .none }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            (myTabBar.reqfun.secNor[indexPath.row] as! Generic).isSelected = true
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            (myTabBar.reqfun.secNor[indexPath.row] as! Generic).isSelected = false
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = myTabBar.reqfun.secNor[sourceIndexPath.row]
        myTabBar.reqfun.secNor.remove(movedObject)
        myTabBar.reqfun.secNor.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    // MARK: - Buttons
    
    @IBAction func deletePressed(_ sender: Any) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        for i in myTabBar.reqfun.secNor{
            let item = i as! Generic
            if item.isSelected{
                if myTabBar.idReqFun != AppDelegate.NOTHING{
                    let urlPath = Utils.getUrlDelete(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SEC_NOR, id: myTabBar.idReqFun, g: item)
                    webService.save_deleteObject(url: URL(string: urlPath)!)
                }
                myTabBar.reqfun.secNor.remove(item)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func selectPressed(_ sender: Any) {
        if flagSelect {
            tableView.isEditing = true
            flagSelect = false
            buttonSelect.title = NSLocalizedString("SELECT", comment: "")
        } else {
            tableView.isEditing = false
            flagSelect = true
            buttonSelect.title = NSLocalizedString("ORDER", comment: "")
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if(myTabBar.idReqFun != AppDelegate.NOTHING){
            let webService = Utils()
            webService.delegateSaveDeleteObject = self
            
            for i in myTabBar.reqfun.secNor{
                let item = i as! Generic
                let urlPath = Utils.getUrlDelete(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SEC_NOR, id: myTabBar.idReqFun, g: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            
            for i in myTabBar.reqfun.secNor{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SEC_NOR, idO: myTabBar.idReqFun, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
                sleep(UInt32(1))
            }
        }
        
    }
    
    @IBAction func clearTextPressed(_ sender: Any) {
        textItem.text = ""
    }
    
    @IBAction func saveTextPressed(_ sender: Any) {
        if !(textItem.text?.elementsEqual(""))!{
            myTabBar.reqfun.secNor.add(Generic(id: AppDelegate.NOTHING, name: textItem.text!))
            textItem.text = ""
            tableView.reloadData()
        }
    }
    
}
