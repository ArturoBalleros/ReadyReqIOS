//
//  ObjetiveTabBarController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 12/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ObjetiveTabBarController: UITabBarController, CUDProtocol, IdProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var idObjetive : Int = 0
    var objetive = Objetive()
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {        
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/objet_"
        if(idObjetive != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(objetive.id)&b=\(objetive.name)&c=\(objetive.version)&d=\(Utils.DateToString(date: objetive.date))&"
             urlPath += "e=\(objetive.descrip)&f=\(objetive.prior)&"
            urlPath += "g=\(objetive.urge)&h=\(objetive.esta)&"
            if(objetive.state){ urlPath += "i=\(1)&" }else{ urlPath += "i=\(0)&" }
            urlPath += "j=\(objetive.category)&k=\(objetive.comentary)"
        }else{
            urlPath += "create.php?a=\(objetive.name)&b=\(objetive.version)&c=\(Utils.DateToString(date: objetive.date))&"
               urlPath += "d=\(objetive.descrip)&e=\(objetive.prior)&"
            urlPath += "f=\(objetive.urge)&g=\(objetive.esta)&"
            if(objetive.state){ urlPath += "h=\(1)&" }else{ urlPath += "h=\(0)&" }
            urlPath += "i=\(objetive.category)&j=\(objetive.comentary)"
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
        if(idObjetive != AppDelegate.NOTHING){
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
            
                let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/objet_delete.php?a=\(self.objetive.id)"
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
        if (idObjetive == AppDelegate.NOTHING){
            var urlPath = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/objet_id.php?a=\(objetive.name)"
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
            for i in objetive.autors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.OBJETIVOS, flagTab: AppDelegate.AUTH,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in objetive.sources{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.OBJETIVOS, flagTab: AppDelegate.SOUR, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in objetive.objetives{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.OBJETIVOS, flagTab: AppDelegate.OBJE, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
        }
        self.dismiss(animated: true)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
}
