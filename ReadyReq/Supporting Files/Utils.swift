//
//  Utils.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 09/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Utils{
    
    // MARK: - Variables
    
    weak var delegateCUD: CUDProtocol!
    weak var delegateSaveDeleteObject: SaveDeleteObjectProtocol!
    weak var delegateId: IdProtocol!
    
    // MARK: - Methods
    
    public static func convert_Url (url : String) -> String{
        if  let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return encodedURL
        } else {
            return "ERROR"
        }
    }
    
    public static func deterTipoReq (TipoReq: Int) -> String {
        if(TipoReq == AppDelegate.TIPO_REQ_NFUN){
            return "(N) "
        } else if (TipoReq == AppDelegate.TIPO_REQ_FUN){
            return "(F) "
        } else {
            return "(I) "
        }
    }
    
    public static func showError(codeError : Int, controller : UIViewController){
        if (codeError == AppDelegate.ERROR_EMPTY_PARAM){
            ToolsView.showToast(message: NSLocalizedString("ERROR_EMPTY_PARAM", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.ERROR_READ_FILE){
            ToolsView.showToast(message: NSLocalizedString("ERROR_READ_FILE", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.ERROR_CONNECT){
            ToolsView.showToast(message: NSLocalizedString("ERROR_CONNECT", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.ERROR_QUERY){
            ToolsView.showToast(message: NSLocalizedString("ERROR_QUERY", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.ERROR_EMPTY_QUERY){
            ToolsView.showToast(message: NSLocalizedString("ERROR_EMPTY_QUERY", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.SUCCESS){
            ToolsView.showToast(message: NSLocalizedString("SUCCESS", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.ERROR_URL){
            ToolsView.showToast(message: NSLocalizedString("ERROR_URL", comment: ""), controller: controller)
        }
        if (codeError == AppDelegate.CONF_FRAG_ERROR_1){
            ToolsView.showToast(message: NSLocalizedString("CONF_FRAG_ERROR_1", comment: ""), controller: controller)
        }
    }
    
    // MARK: - Urls
    
    public static func getUrlSave(mode: Int, flagTab: Int, idO: Int, item: Generic) -> String{
        
        let id = item.id
        let descrip = item.name
        let tipoReq = item.tipoReq
        
        var url : String = "http://" + MyUserDefaults.readUDServerIp()  + ":8080/readyreq/rel_create.php?"
        let paramB : String = "b=\(id),\(idO)"
        if mode == AppDelegate.ACTORES {
            if flagTab == AppDelegate.AUTH {
                url += "a=actauto(idautor,idact)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=actfuen(idfuen,idact)&"
                url += paramB
            }
        }
        if mode == AppDelegate.OBJETIVOS {
            if flagTab == AppDelegate.AUTH {
                url += "a=objauto(idautor,idobj)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=objfuen(idfuen,idobj)&";
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=objsubobj(idsubobj,idobj)&"
                url += paramB
            }
        }
        if mode == AppDelegate.REQ_FUNC {
            if flagTab == AppDelegate.AUTH {
                url += "a=reqauto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=reqfuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=reqobj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=reqreqr(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
            if flagTab == AppDelegate.ACTO {
                url += "a=reqact(idact,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SEC_NOR {
                url += "a=reqsecnor(idreq,descrip)&"
                url += "b=\(idO),'\(descrip)'"
            }
            if flagTab == AppDelegate.SEC_EXC {
                url += "a=reqsecexc(idreq,descrip)&"
                url += "b=\(idO),'\(descrip)'"
            }
        }
        if mode == AppDelegate.REQ_NO_FUN {
            if flagTab == AppDelegate.AUTH {
                url += "a=reqnauto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=reqnfuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=reqnobj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=reqnreqr(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
        }
        if mode == AppDelegate.REQ_INFO {
            if flagTab == AppDelegate.AUTH {
                url += "a=reqiauto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=reqifuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=reqiobj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=reqireqr(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
            if flagTab == AppDelegate.DAT_ESP {
                url += "a=reqidatesp(idreq,descrip)&"
                url += "b=\(idO),'\(descrip)'"
            }
        }
        
        url = Utils.convert_Url(url: url)
        if(!url.elementsEqual("ERROR")){
            return url
        }else{
            return ""
        }
        
    }
    
    public static func getUrlDelete(mode: Int, flagTab: Int, id: Int, g: Generic) -> String{
        var url : String = "http://" + MyUserDefaults.readUDServerIp() + ":8080/readyreq/rel_delete.php?a="
        
        let idO = g.id
        let tipoReq = g.tipoReq
        let descrip = g.name
        
        if mode == AppDelegate.ACTORES {
            if flagTab == AppDelegate.AUTH {
                url += "actauto where idact = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "actfuen where idact = \(id) and idfuen = \(idO)"
            }
        }
        if mode == AppDelegate.OBJETIVOS {
            if flagTab == AppDelegate.AUTH {
                url += "objauto where idobj = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "objfuen where idobj = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "objsubobj where idobj = \(id) and idsubobj = \(idO)"
            }
        }
        if mode == AppDelegate.REQ_FUNC {
            if flagTab == AppDelegate.AUTH {
                url += "reqauto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "reqfuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "reqobj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "reqreqr where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
            if flagTab == AppDelegate.ACTO {
                url += "reqact where idreq = \(id) and idact = \(idO)"
            }
            if flagTab == AppDelegate.SEC_NOR {
                url += "reqsecnor where idreq = \(id) and descrip = '\(descrip)'"
            }
            if flagTab == AppDelegate.SEC_EXC {
                url += "reqsecexc where idreq = \(id) and descrip = '\(descrip)'"
            }
        }
        if mode == AppDelegate.REQ_NO_FUN {
            if flagTab == AppDelegate.AUTH {
                url += "reqnauto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "reqnfuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "reqnobj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "reqnreqr where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
        }
        if mode == AppDelegate.REQ_INFO {
            if flagTab == AppDelegate.AUTH {
                url += "reqiauto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "reqifuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "reqiobj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "reqireqr where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
            if flagTab == AppDelegate.DAT_ESP {
                url += "reqidatesp where idreq = \(id) and descrip = '\(descrip)'"
            }
        }
        url = Utils.convert_Url(url: url)
        if(!url.elementsEqual("ERROR")){
            return url
        }else{
            return ""
        }
    }
    
    // MARK: - WebServices
    
    public func create_update_delete (url : URL, activityIndicator : NVActivityIndicatorView) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
            } else {
                func parseJSON(_ data:Data, _ activityIndicator : NVActivityIndicatorView){
                    
                    var jsonResult = NSDictionary()
                    do{
                        jsonResult =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                        var jsonElement = NSArray()
                        var element = NSDictionary()
                        jsonElement = jsonResult["Resul"] as! NSArray
                        var codeError : Int
                        
                        element = jsonElement[0] as! NSDictionary
                        if let resul = element["a"] as? String
                        {
                            if resul.elementsEqual("No1"){
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }else if resul.elementsEqual("No2"){
                                codeError = AppDelegate.ERROR_READ_FILE
                            }else if resul.elementsEqual("No3"){
                                codeError = AppDelegate.ERROR_CONNECT
                            }else if resul.elementsEqual("No4"){
                                codeError = AppDelegate.ERROR_QUERY
                            } else {
                                codeError = AppDelegate.SUCCESS
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.delegateCUD?.gotResul(codeError: codeError)
                            })
                        }else{
                            ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
                        }
                    } catch let error as NSError {
                        print(error)
                        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
                    }
                }
                parseJSON(data!, activityIndicator)
            }
        }
        task.resume()
    }
    
    public func save_deleteObject (url : URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                func parseJSON(_ data:Data){
                    
                    var jsonResult = NSDictionary()
                    do{
                        jsonResult =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                        var jsonElement = NSArray()
                        var element = NSDictionary()
                        jsonElement = jsonResult["Resul"] as! NSArray
                        //En este caso tambien se utilizar para confirmar que se ha guardo sin que salga el mensaje
                        var codeError : Int = AppDelegate.SUCCESS_DATA
                        
                        element = jsonElement[0] as! NSDictionary
                        if let resul = element["a"] as? String
                        {
                            if resul.elementsEqual("No1"){
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }else if resul.elementsEqual("No2"){
                                codeError = AppDelegate.ERROR_READ_FILE
                            }else if resul.elementsEqual("No3"){
                                codeError = AppDelegate.ERROR_CONNECT
                            }else if resul.elementsEqual("No4"){
                                codeError = AppDelegate.ERROR_QUERY
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.delegateSaveDeleteObject?.gotResulItem(codeError: codeError)
                            })
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func getId(url : URL, activityIndicator : NVActivityIndicatorView) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
            } else {
                func parseJSON(_ data:Data, _ activityIndicator : NVActivityIndicatorView){
                    
                    var jsonResult = NSDictionary()
                    do{
                        jsonResult =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                        //print(jsonResult)
                        var jsonElement = NSArray()
                        var element = NSDictionary()
                        jsonElement = jsonResult["Resul"] as! NSArray
                        
                        var idObject = AppDelegate.NOTHING
                        var codeError : Int
                        element = jsonElement[0] as! NSDictionary
                        if let resul = element["a"] as? String
                        {
                            if resul.elementsEqual("No1"){
                                codeError = AppDelegate.ERROR_EMPTY_PARAM
                            }else if resul.elementsEqual("No2"){
                                codeError = AppDelegate.ERROR_READ_FILE
                            }else if resul.elementsEqual("No3"){
                                codeError = AppDelegate.ERROR_CONNECT
                            }else if resul.elementsEqual("No4"){
                                codeError = AppDelegate.ERROR_QUERY
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_PARAM
                            }
                        }else{
                            element = jsonElement[0] as! NSDictionary
                            if  let id = element["Id"] as? String
                            {
                                idObject = Int(id)!
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegateId?.gotId(id: idObject, codeError: codeError)
                        })
                    } catch let error as NSError {
                        print(error)
                        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
                    }
                }
                parseJSON(data!, activityIndicator)
            }
        }
        task.resume()
    }
    
}
