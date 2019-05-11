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
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/reqnfun_"
        if(idReqNFun != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(reqnfun.id)&b=\(reqnfun.name)&c=\(reqnfun.descrip)&d=\(reqnfun.prior)&"
            urlPath += "e=\(reqnfun.urge)&f=\(reqnfun.esta)&"
            if(reqnfun.state){ urlPath += "g=\(1)&" }else{ urlPath += "g=\(0)&" }
            urlPath += "h=\(reqnfun.category)&i=\(reqnfun.comentary)"
        }else{
            urlPath += "create.php?a=\(reqnfun.name)&b=\(reqnfun.descrip)&c=\(reqnfun.prior)&"
            urlPath += "d=\(reqnfun.urge)&e=\(reqnfun.esta)&"
            if(reqnfun.state){ urlPath += "f=\(1)&" }else{ urlPath += "f=\(0)&" }
            urlPath += "g=\(reqnfun.category)&h=\(reqnfun.comentary)"
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
            let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/reqnfun_delete.php?a=\(reqnfun.id)"
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let webServices = Utils()
            webServices.delegateCUD = self
            webServices.create_update_delete(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - WebServices
    
    func gotResul(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        if (idReqNFun == AppDelegate.NOTHING){
            var urlPath = "http://" + MyUserDefaults.readUDServerIp() + ":8080/readyreq/reqnfun_id.php?a=\(reqnfun.name)"
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
