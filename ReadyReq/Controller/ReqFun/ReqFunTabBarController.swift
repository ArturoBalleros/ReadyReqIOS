//
//  ReqFunTabBarController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 14/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReqFunTabBarController: UITabBarController, CUDProtocol, IdProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var idReqFun : Int = 0
    var reqfun = ReqFun()
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/reqfun_"
        if(idReqFun != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(reqfun.id)&b=\(reqfun.name)&c=\(reqfun.descrip)&d=\(reqfun.package)&"
            urlPath += "e=\(reqfun.preCond)&f=\(reqfun.postCond)&g=\(reqfun.prior)&"
            urlPath += "h=\(reqfun.urge)&i=\(reqfun.esta)&"
            if(reqfun.state){ urlPath += "j=\(1)&" }else{ urlPath += "j=\(0)&" }
            urlPath += "k=\(reqfun.category)&l=\(reqfun.comentary)"
        }else{
            urlPath += "create.php?a=\(reqfun.name)&b=\(reqfun.descrip)&c=\(reqfun.package)&"
            urlPath += "d=\(reqfun.preCond)&e=\(reqfun.postCond)&f=\(reqfun.prior)&"
            urlPath += "g=\(reqfun.urge)&h=\(reqfun.esta)&"
            if(reqfun.state){ urlPath += "i=\(1)&" }else{ urlPath += "i=\(0)&" }
            urlPath += "j=\(reqfun.category)&k=\(reqfun.comentary)"
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
        if(idReqFun != AppDelegate.NOTHING){
            let urlPath = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/reqfun_delete.php?a=\(reqfun.id)"
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
        if (idReqFun == AppDelegate.NOTHING){
            var urlPath = "http://" + MyUserDefaults.readUDServerIp() + ":8080/readyreq/reqfun_id.php?a=\(reqfun.name)"
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
            for i in reqfun.autors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.AUTH, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.sources{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SOUR,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.objetives{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.OBJE,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.requeriments{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.REQU,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.actors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.ACTO,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.secNor{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SEC_NOR,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqfun.secExc{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.SEC_EXC,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
        }
        self.dismiss(animated: true)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
}
