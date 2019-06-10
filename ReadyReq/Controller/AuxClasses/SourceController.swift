//
//  SourceObjetiveController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 12/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SourceController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SaveDeleteObjectProtocol {
    
    // MARK: Variables
    
    @IBOutlet weak var tableView: UITableView!
    var myTabBarActor: ActorTabBarController!
    var myTabBarObjetive: ObjetiveTabBarController!
    var myTabBarReqNFun: ReqNFunTabBarController!
    var myTabBarReqInfo: ReqInfoTabBarController!
    var myTabBarReqFun: ReqFunTabBarController!
    var activityIndicator : NVActivityIndicatorView!
    var mode = 0
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        myTabBarActor = tabBarController as? ActorTabBarController
        myTabBarObjetive = tabBarController as? ObjetiveTabBarController
        myTabBarReqNFun = tabBarController as? ReqNFunTabBarController
        myTabBarReqInfo = tabBarController as? ReqInfoTabBarController
        myTabBarReqFun = tabBarController as? ReqFunTabBarController
        
        do {
            guard let _ = myTabBarActor?.idActor else { throw MyError.FoundNil("Actor") }
            mode = AppDelegate.ACTORES
        } catch { }
        do {
            guard let _ = myTabBarObjetive?.idObjetive else { throw MyError.FoundNil("Objet") }
            mode = AppDelegate.OBJETIVOS
        } catch { }
        do {
            guard let _ = myTabBarReqNFun?.idReqNFun else { throw MyError.FoundNil("ReqNFun") }
            mode = AppDelegate.REQ_NO_FUN
        } catch { }
        do {
            guard let _ = myTabBarReqInfo?.idReqInfo else { throw MyError.FoundNil("ReqInfo") }
            mode = AppDelegate.REQ_INFO
        } catch { }
        do {
            guard let _ = myTabBarReqFun?.idReqFun else { throw MyError.FoundNil("ReqFun") }
            mode = AppDelegate.REQ_FUNC
        } catch { }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! AddItemsController
        if(segue.identifier == "showAddSources"){
            destinationVC.mode = mode
            destinationVC.flagTab = AppDelegate.SOUR
            if AppDelegate.ACTORES == mode {
                destinationVC.idObject = myTabBarActor.idActor
            } else if AppDelegate.OBJETIVOS == mode {
                destinationVC.idObject = myTabBarObjetive.idObjetive
            } else if AppDelegate.REQ_NO_FUN == mode {
                destinationVC.idObject = myTabBarReqNFun.idReqNFun
            } else if AppDelegate.REQ_INFO == mode {
                destinationVC.idObject = myTabBarReqInfo.idReqInfo
            } else {
                destinationVC.idObject = myTabBarReqFun.idReqFun
            }
        }
    }
    
    @IBAction func unwindSource(_ sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    // MARK: WebServices
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppDelegate.ACTORES == mode {
            return myTabBarActor.actor.sources.count
        } else if AppDelegate.OBJETIVOS == mode {
            return myTabBarObjetive.objetive.sources.count
        } else if AppDelegate.REQ_NO_FUN == mode {
            return myTabBarReqNFun.reqnfun.sources.count
        } else if AppDelegate.REQ_INFO == mode {
            return myTabBarReqInfo.reqinfo.sources.count
        } else {
            return myTabBarReqFun.reqfun.sources.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if AppDelegate.ACTORES == mode {
            cell.textLabel?.text = (myTabBarActor.actor.sources[indexPath.row] as! Generic).name
            if (myTabBarActor.actor.sources[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.OBJETIVOS == mode {
            cell.textLabel?.text = (myTabBarObjetive.objetive.sources[indexPath.row] as! Generic).name
            if (myTabBarObjetive.objetive.sources[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.REQ_NO_FUN == mode {
            cell.textLabel?.text = (myTabBarReqNFun.reqnfun.sources[indexPath.row] as! Generic).name
            if (myTabBarReqNFun.reqnfun.sources[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.REQ_INFO == mode {
            cell.textLabel?.text = (myTabBarReqInfo.reqinfo.sources[indexPath.row] as! Generic).name
            if (myTabBarReqInfo.reqinfo.sources[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else {
            cell.textLabel?.text = (myTabBarReqFun.reqfun.sources[indexPath.row] as! Generic).name
            if (myTabBarReqFun.reqfun.sources[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.ACTORES == mode {
                (myTabBarActor.actor.sources[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.OBJETIVOS == mode {
                (myTabBarObjetive.objetive.sources[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.sources[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.sources[indexPath.row] as! Generic).isSelected = true
            } else {
                (myTabBarReqFun.reqfun.sources[indexPath.row] as! Generic).isSelected = true
            }
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.ACTORES == mode {
                (myTabBarActor.actor.sources[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.OBJETIVOS == mode {
                (myTabBarObjetive.objetive.sources[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.sources[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.sources[indexPath.row] as! Generic).isSelected = false
            } else {
                (myTabBarReqFun.reqfun.sources[indexPath.row] as! Generic).isSelected = false
            }
            cell.accessoryType = .none
        }
    }
    
    // MARK: Buttons
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        if AppDelegate.ACTORES == mode {
            for i in myTabBarActor.actor.sources{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarActor.idActor != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.SOUR, id: myTabBarActor.idActor, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarActor.actor.sources.remove(item)
                }
            }
        } else if AppDelegate.OBJETIVOS == mode {
            for i in myTabBarObjetive.objetive.sources{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarObjetive.idObjetive != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.SOUR, id: myTabBarObjetive.idObjetive, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarObjetive.objetive.sources.remove(item)
                }
            }
        } else if AppDelegate.REQ_NO_FUN == mode {
            for i in myTabBarReqNFun.reqnfun.sources{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqNFun.idReqNFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.SOUR, id: myTabBarReqNFun.idReqNFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqNFun.reqnfun.sources.remove(item)
                }
            }
        } else if AppDelegate.REQ_INFO == mode {
            for i in myTabBarReqInfo.reqinfo.sources{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqInfo.idReqInfo != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.SOUR, id: myTabBarReqInfo.idReqInfo, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqInfo.reqinfo.sources.remove(item)
                }
            }
        } else {
            for i in myTabBarReqFun.reqfun.sources{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqFun.idReqFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.SOUR, id: myTabBarReqFun.idReqFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqFun.reqfun.sources.remove(item)
                }
            }
        }
        tableView.reloadData()
    }
    
}
