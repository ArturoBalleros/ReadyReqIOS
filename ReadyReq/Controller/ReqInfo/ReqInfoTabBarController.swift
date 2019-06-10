//
//  ReqInfoTabBarController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 14/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReqInfoTabBarController: UITabBarController, CUDProtocol, IdProtocol, SaveDeleteObjectProtocol {
    
    // MARK: - Variables
    
    var idReqInfo : Int = 0
    var reqinfo = ReqInfo()
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Buttons
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqinfo_"
        if(idReqInfo != AppDelegate.NOTHING){
            urlPath += "update.php?a=\(reqinfo.id)&b=\(reqinfo.name)&c=\(reqinfo.version)&d=\(Utils.DateToString(date: reqinfo.date))&"
            urlPath += "e=\(reqinfo.descrip)&f=\(reqinfo.timeMed)&"
            urlPath += "g=\(reqinfo.timeMax)&h=\(reqinfo.ocuMed)&i=\(reqinfo.ocuMax)&j=\(reqinfo.prior)&"
            urlPath += "k=\(reqinfo.urge)&l=\(reqinfo.esta)&"
            if(reqinfo.state){ urlPath += "m=\(1)&" }else{ urlPath += "m=\(0)&" }
            urlPath += "n=\(reqinfo.category)&o=\(reqinfo.comentary)"
        }else{
            urlPath += "create.php?a=\(reqinfo.name)&b=\(reqinfo.version)&c=\(Utils.DateToString(date: reqinfo.date))&"
            urlPath += "d=\(reqinfo.descrip)&e=\(reqinfo.timeMed)&"
            urlPath += "f=\(reqinfo.timeMax)&g=\(reqinfo.ocuMed)&h=\(reqinfo.ocuMax)&i=\(reqinfo.prior)&"
            urlPath += "j=\(reqinfo.urge)&k=\(reqinfo.esta)&"
            if(reqinfo.state){ urlPath += "l=\(1)&" }else{ urlPath += "l=\(0)&" }
            urlPath += "m=\(reqinfo.category)&n=\(reqinfo.comentary)"
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
        print(reqinfo.description)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if(idReqInfo != AppDelegate.NOTHING){
            let controller = UIAlertController(title: NSLocalizedString("DELETE", comment: ""), message:NSLocalizedString("WANT_DELETE", comment: "")
                , preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: NSLocalizedString("DELETE", comment: ""), style: .default) { (action) in
            
                let urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqinfo_delete.php?a=\(self.reqinfo.id)"
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
        if (idReqInfo == AppDelegate.NOTHING){
            var urlPath = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqinfo_id.php?a=\(reqinfo.name)"
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
            for i in reqinfo.autors{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.AUTH, idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqinfo.sources{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.SOUR,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqinfo.objetives{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.OBJE,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqinfo.requeriments{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.REQU,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
            for i in reqinfo.datEspec{
                let item = i as! Generic
                let urlPath = Utils.getUrlSave(mode: AppDelegate.REQ_INFO, flagTab: AppDelegate.DAT_ESP,  idO: id, item: item)
                webService.save_deleteObject(url: URL(string: urlPath)!)
            }
        }
        self.dismiss(animated: true)
    }
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
}
