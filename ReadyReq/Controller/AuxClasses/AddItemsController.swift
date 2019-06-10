//
//  AuthorActorAddController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 12/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddItemsController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GenericProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var mode : Int = 0
    var flagTab : Int = 0
    var idObject : Int = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator : NVActivityIndicatorView!
    var searching = false
    var items: NSMutableArray = NSMutableArray()
    let itemsSearch: NSMutableArray = NSMutableArray()
    var urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/rel_list.php?"
    let generic = Generic()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        urlPath += "a=\(mode)&"
        urlPath += "b=\(flagTab)&"
        urlPath += "c=\(idObject)"
        print(urlPath)
        generic.delegate = self
        activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
        generic.getItems(url: URL(string: urlPath)!, activityIndicator : activityIndicator)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if searching {
            return false
        }else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(mode == AppDelegate.ACTORES){
            if flagTab == AppDelegate.AUTH {
                let destVC = segue.destination as! AuthorController
                addObject(arrayDest: destVC.myTabBarActor.actor.autors)
            }
            if flagTab == AppDelegate.SOUR {
                let destVC = segue.destination as! SourceController
                addObject(arrayDest: destVC.myTabBarActor.actor.sources)
            }
        }
        if(mode == AppDelegate.OBJETIVOS){
            if flagTab == AppDelegate.AUTH {
                let destVC = segue.destination as! AuthorController
                addObject(arrayDest: destVC.myTabBarObjetive.objetive.autors)
            }
            if flagTab == AppDelegate.SOUR {
                let destVC = segue.destination as! SourceController
                addObject(arrayDest: destVC.myTabBarObjetive.objetive.sources)
            }
            if flagTab == AppDelegate.OBJE {
                let destVC = segue.destination as! ObjetiveController
                addObject(arrayDest: destVC.myTabBarObjetive.objetive.objetives)
            }
        }
        if(mode == AppDelegate.REQ_NO_FUN){
            if flagTab == AppDelegate.AUTH {
                let destVC = segue.destination as! AuthorController
                addObject(arrayDest: destVC.myTabBarReqNFun.reqnfun.autors)
            }
            if flagTab == AppDelegate.SOUR {
                let destVC = segue.destination as! SourceController
                addObject(arrayDest: destVC.myTabBarReqNFun.reqnfun.sources)
            }
            if flagTab == AppDelegate.OBJE {
                let destVC = segue.destination as! ObjetiveController
                addObject(arrayDest: destVC.myTabBarReqNFun.reqnfun.objetives)
            }
            if flagTab == AppDelegate.REQU {
                let destVC = segue.destination as! RequerimentController
                addObject(arrayDest: destVC.myTabBarReqNFun.reqnfun.requeriments)
            }
        }
        if(mode == AppDelegate.REQ_INFO){
            if flagTab == AppDelegate.AUTH {
                let destVC = segue.destination as! AuthorController
                addObject(arrayDest: destVC.myTabBarReqInfo.reqinfo.autors)
            }
            if flagTab == AppDelegate.SOUR {
                let destVC = segue.destination as! SourceController
                addObject(arrayDest: destVC.myTabBarReqInfo.reqinfo.sources)
            }
            if flagTab == AppDelegate.OBJE {
                let destVC = segue.destination as! ObjetiveController
                addObject(arrayDest: destVC.myTabBarReqInfo.reqinfo.objetives)
            }
            if flagTab == AppDelegate.REQU {
                let destVC = segue.destination as! RequerimentController
                addObject(arrayDest: destVC.myTabBarReqInfo.reqinfo.requeriments)
            }
        }
        if(mode == AppDelegate.REQ_FUNC){
            if flagTab == AppDelegate.AUTH {
                let destVC = segue.destination as! AuthorController
                addObject(arrayDest: destVC.myTabBarReqFun.reqfun.autors)
            }
            if flagTab == AppDelegate.SOUR {
                let destVC = segue.destination as! SourceController
                addObject(arrayDest: destVC.myTabBarReqFun.reqfun.sources)
            }
            if flagTab == AppDelegate.OBJE {
                let destVC = segue.destination as! ObjetiveController
                addObject(arrayDest: destVC.myTabBarReqFun.reqfun.objetives)
            }
            if flagTab == AppDelegate.REQU {
                let destVC = segue.destination as! RequerimentController
                addObject(arrayDest: destVC.myTabBarReqFun.reqfun.requeriments)
            }
            if flagTab == AppDelegate.ACTO {
                let destVC = segue.destination as! ActorController
                addObject(arrayDest: destVC.myTabBar.reqfun.actors)
            }
        }
    }
    
    // MARK: - WebServices
    
    func gotItems(items: NSMutableArray, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.items = items
            tableView.reloadData()
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let resultPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        let resul = items.filtered(using: resultPredicate)
        itemsSearch.removeAllObjects()
        for i in 0 ..< resul.count{
            let item = resul[i] as! Generic
            itemsSearch.add(Generic(id: item.id, name: item.name, tipoReq: item.tipoReq, isSelected: item.isSelected))
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        for item in items{
            for itemS in itemsSearch{
                if ((item as! Generic).id == (itemS as! Generic).id) && ((item as! Generic).tipoReq == (itemS as! Generic).tipoReq) {
                    (item as! Generic).isSelected = (itemS as! Generic).isSelected
                    break
                }
            }
        }
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return itemsSearch.count
        }else{
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if searching {
            if flagTab == AppDelegate.REQU {
                cell.textLabel?.text = Utils.deterTipoReq(TipoReq: (itemsSearch[indexPath.row] as! Generic).tipoReq) +  (itemsSearch[indexPath.row] as! Generic).name
            } else {
                cell.textLabel?.text = (itemsSearch[indexPath.row] as! Generic).name
            }
            if (itemsSearch[indexPath.row] as! Generic).isSelected {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
        }else{
            if flagTab == AppDelegate.REQU {
                cell.textLabel?.text = Utils.deterTipoReq(TipoReq: (items[indexPath.row] as! Generic).tipoReq) +  (items[indexPath.row] as! Generic).name
            } else {
                cell.textLabel?.text = (items[indexPath.row] as! Generic).name
            }
            if (items[indexPath.row] as! Generic).isSelected {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if searching {
                (itemsSearch[indexPath.row] as! Generic).isSelected = true
            }else{
                (items[indexPath.row] as! Generic).isSelected = true
            }
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if searching {
                (itemsSearch[indexPath.row] as! Generic).isSelected = false
            }else{
                (items[indexPath.row] as! Generic).isSelected = false
            }
            cell.accessoryType = .none
        }
    }
    
    // MARK: - Buttons
    
    @IBAction func undoPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Methods
    
    func addObject (arrayDest: NSMutableArray){
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        for o in items{
            let item = o as! Generic
            if(item.isSelected){
                arrayDest.add(Generic(id: item.id, name: item.name, tipoReq: item.tipoReq, isSelected: false))
                if(idObject != AppDelegate.NOTHING){
                    let url = Utils.getUrlSave(mode: mode, flagTab: flagTab, idO: idObject, item: item)
                    webService.save_deleteObject(url: URL(string: url)!)
                }
            }
        }
    }
    
}
