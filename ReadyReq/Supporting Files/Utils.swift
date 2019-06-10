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
        
        var url : String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp()  + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/rel_create.php?"
        let paramB : String = "b=\(id),\(idO)"
        if mode == AppDelegate.ACTORES {
            if flagTab == AppDelegate.AUTH {
                url += "a=ActAuto(idautor,idact)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=ActFuen(idfuen,idact)&"
                url += paramB
            }
        }
        if mode == AppDelegate.OBJETIVOS {
            if flagTab == AppDelegate.AUTH {
                url += "a=ObjAuto(idautor,idobj)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=ObjFuen(idfuen,idobj)&";
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=ObjSubobj(idsubobj,idobj)&"
                url += paramB
            }
        }
        if mode == AppDelegate.REQ_FUNC {
            if flagTab == AppDelegate.AUTH {
                url += "a=ReqAuto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=ReqFuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=ReqObj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=ReqReqR(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
            if flagTab == AppDelegate.ACTO {
                url += "a=ReqAct(idact,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SEC_NOR {
                url += "a=ReqSecNor(idreq,descrip)&"
                url += "b=\(idO),'\(descrip)'"
            }
            if flagTab == AppDelegate.SEC_EXC {
                url += "a=ReqSecExc(idreq,descrip)&"
                url += "b=\(idO),'\(descrip)'"
            }
        }
        if mode == AppDelegate.REQ_NO_FUN {
            if flagTab == AppDelegate.AUTH {
                url += "a=ReqNAuto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=ReqNFuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=ReqNObj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=ReqNReqR(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
        }
        if mode == AppDelegate.REQ_INFO {
            if flagTab == AppDelegate.AUTH {
                url += "a=ReqIAuto(idautor,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.SOUR {
                url += "a=ReqIFuen(idfuen,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.OBJE {
                url += "a=ReqIObj(idobj,idreq)&"
                url += paramB
            }
            if flagTab == AppDelegate.REQU {
                url += "a=ReqIReqR(idreqr,tiporeq,idreq)&"
                url += "b=\(id),\(tipoReq),\(idO)"
            }
            if flagTab == AppDelegate.DAT_ESP {
                url += "a=ReqIDatEsp(idreq,descrip)&"
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
        var url : String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/rel_delete.php?a="
        
        let idO = g.id
        let tipoReq = g.tipoReq
        let descrip = g.name
        
        if mode == AppDelegate.ACTORES {
            if flagTab == AppDelegate.AUTH {
                url += "ActAuto where idact = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "ActFuen where idact = \(id) and idfuen = \(idO)"
            }
        }
        if mode == AppDelegate.OBJETIVOS {
            if flagTab == AppDelegate.AUTH {
                url += "ObjAuto where idobj = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "ObjFuen where idobj = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "ObjSubobj where idobj = \(id) and idsubobj = \(idO)"
            }
        }
        if mode == AppDelegate.REQ_FUNC {
            if flagTab == AppDelegate.AUTH {
                url += "ReqAuto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "ReqFuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "ReqObj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "ReqReqR where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
            if flagTab == AppDelegate.ACTO {
                url += "ReqAct where idreq = \(id) and idact = \(idO)"
            }
            if flagTab == AppDelegate.SEC_NOR {
                url += "ReqSecNor where idreq = \(id) and descrip = '\(descrip)'"
            }
            if flagTab == AppDelegate.SEC_EXC {
                url += "ReqSecExc where idreq = \(id) and descrip = '\(descrip)'"
            }
        }
        if mode == AppDelegate.REQ_NO_FUN {
            if flagTab == AppDelegate.AUTH {
                url += "ReqNAuto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "ReqNFuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "ReqNObj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "ReqNReqR where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
        }
        if mode == AppDelegate.REQ_INFO {
            if flagTab == AppDelegate.AUTH {
                url += "ReqIAuto where idreq = \(id) and idautor = \(idO)"
            }
            if flagTab == AppDelegate.SOUR {
                url += "ReqIFuen where idreq = \(id) and idfuen = \(idO)"
            }
            if flagTab == AppDelegate.OBJE {
                url += "ReqIObj where idreq = \(id) and idobj = \(idO)"
            }
            if flagTab == AppDelegate.REQU {
                url += "ReqIReqR where idreq = \(id) and idreqr = \(idO) and tiporeq = \(tipoReq)"
            }
            if flagTab == AppDelegate.DAT_ESP {
                url += "ReqIDatEsp where idreq = \(id) and descrip = '\(descrip)'"
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
    
    public static func StringToDouble (string: String) -> Double {
        if let resul = Double(string) {
            if let round = Double(String(format: "%.2f", Double(round(1000*resul)/1000))){
                return round
            }else{
                return 1.0
            }
        } else {
            return 1.0
        }
    }
    
    public static func StringToDate (string: String, MySQL: Bool) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (MySQL) ? "yyyy-MM-dd" : "dd-MM-yyyy"
        if let date = dateFormatter.date(from:string){
            return date
        }else{
            return Date()
        }
    }
    
    public static func DateToString (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" //yyyy
        return formatter.string(from: date)
    }
}
