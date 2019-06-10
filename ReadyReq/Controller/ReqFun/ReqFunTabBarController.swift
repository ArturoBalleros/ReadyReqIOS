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
        var urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqfun_"
        if(idReqFun != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(reqfun.id)&b=\(reqfun.name)&c=\(reqfun.version)&d=\(Utils.DateToString(date: reqfun.date))&"
            urlPath += "e=\(reqfun.descrip)&f=\(reqfun.package)&"
            urlPath += "g=\(reqfun.preCond)&h=\(reqfun.postCond)&i=\(reqfun.comple)&j=\(reqfun.prior)&"
            urlPath += "k=\(reqfun.urge)&l=\(reqfun.esta)&"
            if(reqfun.state){ urlPath += "m=\(1)&" }else{ urlPath += "m=\(0)&" }
            urlPath += "n=\(reqfun.category)&o=\(reqfun.comentary)"
        }else{
            urlPath += "create.php?a=\(reqfun.name)&b=\(reqfun.version)&c=\(Utils.DateToString(date: reqfun.date))&"
            urlPath += "d=\(reqfun.descrip)&e=\(reqfun.package)&"
            urlPath += "f=\(reqfun.preCond)&g=\(reqfun.postCond)&h=\(reqfun.comple)&i=\(reqfun.prior)&"
            urlPath += "j=\(reqfun.urge)&k=\(reqfun.esta)&"
            if(reqfun.state){ urlPath += "l=\(1)&" }else{ urlPath += "l=\(0)&" }
            urlPath += "m=\(reqfun.category)&n=\(reqfun.comentary)"
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
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
                let urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqfun_delete.php?a=\(self.reqfun.id)"
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
        if (idReqFun == AppDelegate.NOTHING){
            var urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqfun_id.php?a=\(reqfun.name)"
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
