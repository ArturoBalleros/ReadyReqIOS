//
//  ReqNFunTabBarController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 14/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReqNFunTabBarController: UITabBarController, CUDProtocol, IdProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var idReqNFun : Int = 0
    var reqnfun = ReqNFun()
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {        
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqnfun_"
        if(idReqNFun != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(reqnfun.id)&b=\(reqnfun.name)&c=\(reqnfun.version)&d=\(Utils.DateToString(date: reqnfun.date))&"
            urlPath += "e=\(reqnfun.descrip)&f=\(reqnfun.prior)&"
                     urlPath += "g=\(reqnfun.urge)&h=\(reqnfun.esta)&"
            if(reqnfun.state){ urlPath += "i=\(1)&" }else{ urlPath += "i=\(0)&" }
            urlPath += "j=\(reqnfun.category)&k=\(reqnfun.comentary)"
        }else{
            urlPath += "create.php?a=\(reqnfun.name)&b=\(reqnfun.version)&c=\(Utils.DateToString(date: reqnfun.date))&"
            urlPath += "d=\(reqnfun.descrip)&e=\(reqnfun.prior)&"
                urlPath += "f=\(reqnfun.urge)&g=\(reqnfun.esta)&"
            if(reqnfun.state){ urlPath += "h=\(1)&" }else{ urlPath += "h=\(0)&" }
            urlPath += "i=\(reqnfun.category)&j=\(reqnfun.comentary)"
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
        print(reqnfun.description)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if(idReqNFun != AppDelegate.NOTHING){
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
            
                let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqnfun_delete.php?a=\(self.reqnfun.id)"
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
        if (idReqNFun == AppDelegate.NOTHING){
            var urlPath = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqnfun_id.php?a=\(reqnfun.name)"
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
            for i in reqnfun.autors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_NO_FUN, flagTab: AppDelegate.AUTH,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqnfun.sources{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_NO_FUN, flagTab: AppDelegate.SOUR, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqnfun.objetives{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_NO_FUN, flagTab: AppDelegate.OBJE, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqnfun.requeriments{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_NO_FUN, flagTab: AppDelegate.REQU, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
        }
        self.dismiss(animated: true)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
}
