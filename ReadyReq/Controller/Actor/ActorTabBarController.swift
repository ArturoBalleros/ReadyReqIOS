//
//  ActorTabBarController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActorTabBarController: UITabBarController, CUDProtocol, IdProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var idActor : Int = 0
    var actor = Actor()
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/actor_"
        if(idActor != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(actor.id)&b=\(actor.name)&c=\(actor.version)&d=\(Utils.DateToString(date: actor.date))&"
            urlPath += "e=\(actor.descrip)&f=\(actor.comple)&"
            urlPath += "g=\(actor.descComple)&h=\(actor.category)&i=\(actor.comentary)"
        }else{
            urlPath += "create.php?a=\(actor.name)&b=\(actor.version)&c=\(Utils.DateToString(date: actor.date))&"
            urlPath += "d=\(actor.descrip)&e=\(actor.comple)&"
            urlPath += "f=\(actor.descComple)&g=\(actor.category)&h=\(actor.comentary)"
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
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if(idActor != AppDelegate.NOTHING){
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
                
                let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/actor_delete.php?a=\(self.actor.id)"
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
    
    // MARK: - WebServices
    
    func gotResul(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        if (idActor == AppDelegate.NOTHING){
            var urlPath = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/actor_id.php?a=\(actor.name)"
            urlPath = Utils.convert_Url(url: urlPath)
            if(!urlPath.elementsEqual("ERROR")){
                activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
                let webService = Utils()
                webService.delegateId = self
                webService.getId(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
            }else{
                ToolsView.showToast(message: NSLocalizedString("ERROR_URL", comment: ""), controller: self)
            }
        }else{
            self.dismiss(animated: true)
        }
    }
    
    func gotId(id: Int, codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        if(id != AppDelegate.NOTHING){
            let webService = Utils()
            webService.delegateSaveDeleteObject = self
            for i in actor.autors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.ACTORES, flagTab: AppDelegate.AUTH, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in actor.sources{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.ACTORES, flagTab: AppDelegate.SOUR, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
        }
        self.dismiss(animated: true)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
}
