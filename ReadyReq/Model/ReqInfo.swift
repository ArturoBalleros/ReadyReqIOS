//
//  ReqInfo.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 11/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ReqInfo : NSObject {
    
    // MARK: - Variables
    
    weak var delegate: ReqInfoProtocol!
    var id : Int
    var name : String
    var descrip : String
    var prior : Int
    var urge : Int
    var esta : Int
    var state : Bool
    var category : Int
    var comentary : String
    var timeMed : Int
    var timeMax : Int
    var ocuMed : Int
    var ocuMax : Int
    var autors : NSMutableArray
    var sources : NSMutableArray
    var objetives : NSMutableArray
    var requeriments : NSMutableArray
    var datEspec : NSMutableArray
    
    // MARK: - Methods
    
    override init() {
        self.id = -1
        self.name = ""
        self.descrip = ""
        self.prior = 3
        self.urge = 3
        self.esta = 3
        self.state = false
        self.category = 1
        self.comentary = ""
        self.timeMed = 0
        self.timeMax = 0
        self.ocuMed = 0
        self.ocuMax = 0
        self.autors = NSMutableArray()
        self.sources = NSMutableArray()
        self.objetives = NSMutableArray()
        self.requeriments = NSMutableArray()
        self.datEspec = NSMutableArray()
    }
    
    override var description : String {
        return """
        - Id : \(id)
        - Name : \(name)
        - Descripcion : \(descrip)
        - Prioridad : \(prior)
        - Urgencia : \(urge)
        - Estabilidad : \(esta)
        - Estado : \(state)
        - Category : \(category)
        - Comentary : \(comentary)
        - Tiempo Medio : \(timeMed)
        - Tiempo Máximo : \(timeMax)
        - Ocurrencia Media : \(ocuMed)
        - Ocurrencia Máxima : \(ocuMax)
        - Autores : \(autors)
        - Fuentes : \(sources)
        - Objetivos : \(objetives)
        - Requisitos : \(requeriments)
        - Datos Específicos : \(datEspec)
        """
    }
    
    func getReqInfo(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let reqinfo = ReqInfo()
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
                            if  let id = element["Id"] as? String,
                                let name = element["Nombre"] as? String,
                                let descrip = element["Descripcion"] as? String,
                                let estab = element["Estabilidad"] as? String,
                                let prior = element["Prioridad"] as? String,
                                let urgen = element["Urgencia"] as? String,
                                let state = element["Estado"] as? String,
                                let ocuMax = element["OcuMax"] as? String,
                                let ocuMed = element["OcuMed"] as? String,
                                let timeMax = element["TiemMax"] as? String,
                                let timeMed = element["TiemMed"] as? String,
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                
                                reqinfo.id = Int(id)!
                                reqinfo.name = name
                                reqinfo.descrip = descrip
                                reqinfo.esta = Int(estab)!
                                reqinfo.prior = Int(prior)!
                                reqinfo.urge = Int(urgen)!
                                if(Int(state) == 0){
                                    reqinfo.state = false
                                }else{
                                    reqinfo.state = true
                                }
                                reqinfo.timeMax = Int(timeMax)!
                                reqinfo.timeMed = Int(timeMed)!
                                reqinfo.ocuMax = Int(ocuMax)!
                                reqinfo.ocuMed = Int(ocuMed)!
                                reqinfo.category = Int(category)!
                                reqinfo.comentary = comentary
                                
                                //Recorro autores
                                if let jsonElement = jsonResult["Resul2"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqinfo.autors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro fuentes
                                if let jsonElement = jsonResult["Resul3"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqinfo.sources.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro objetivos
                                if let jsonElement = jsonResult["Resul4"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqinfo.objetives.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro requisitos
                                if let jsonElement = jsonResult["Resul5"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String,
                                            let tipoReq = element["Tipo"] as? String {
                                            reqinfo.requeriments.add(Generic(id: Int(id)!, name: name, tipoReq: Int(tipoReq)!))
                                        }
                                    }
                                }
                                
                                //Recorro datos especificos
                                if let jsonElement = jsonResult["Resul6"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if let name = element["Descrip"] as? String{
                                            reqinfo.datEspec.add(Generic(name: name))
                                        }
                                    }
                                }
                                
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                            
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotReqInfo(reqinfo: reqinfo, codeError: codeError)
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
