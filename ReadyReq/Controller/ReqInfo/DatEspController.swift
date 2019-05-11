//
//  ItemsDrag&DropController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 15/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DatEspController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    @IBOutlet weak var buttonSelect: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textItem: UITextField!
    var myTabBar: ReqInfoTabBarController!
    var activityIndicator : NVActivityIndicatorView!
    var flagSelect = true
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabBar = tabBarController as? ReqInfoTabBarController
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
        return myTabBar.reqinfo.datEspec.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (myTabBar.reqinfo.datEspec[indexPath.row] as! Generic).name
        if (myTabBar.reqinfo.datEspec[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
        }else{ cell.accessoryType = .none }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            (myTabBar.reqinfo.datEspec[indexPath.row] as! Generic).isSelected = true
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            (myTabBar.reqinfo.datEspec[indexPath.row] as! Generic).isSelected = false
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
        let movedObject = myTabBar.reqinfo.datEspec[sourceIndexPath.row]
        myTabBar.reqinfo.datEspec.remove(movedObject)
        myTabBar.reqinfo.datEspec.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    // MARK: - Buttons
    
    @IBAction func deletePressed(_ sender: Any) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        for i in myTabBar.reqinfo.datEspec{
            let item = i as! Generic
            if item.isSelected{
                if myTabBar.idReqInfo != AppDelegate.NOTHING{
                    let urlPath = Utils.getUrlDelete(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.DAT_ESP, id: myTabBar.idReqInfo, g: item)
                    webService.save_deleteObject(url: URL(string: urlPath)!)
                }
                myTabBar.reqinfo.datEspec.remove(item)
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
        if(myTabBar.idReqInfo != AppDelegate.NOTHING){
            let webService = Utils()
            webService.delegateSaveDeleteObject = self
            
            for i in myTabBar.reqinfo.datEspec{
                let item = i as! Generic
                let urlPath = Utils.getUrlDelete(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.DAT_ESP, id: myTabBar.idReqInfo, g: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            
            for i in myTabBar.reqinfo.datEspec{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.DAT_ESP, idO: myTabBar.idReqInfo, item: item)
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
            myTabBar.reqinfo.datEspec.add(Generic(id: AppDelegate.NOTHING, name: textItem.text!))
            textItem.text = ""
            tableView.reloadData()
        }
    }
    
}
