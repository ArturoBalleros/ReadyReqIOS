//
//  Objetive.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 11/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Objetive : NSObject {
    
    // MARK: - Variables
    
    weak var delegate: ObjetiveProtocol!
    var id : Int
    var name : String
    var descrip : String
    var prior : Int
    var urge : Int
    var esta : Int
    var state : Bool
    var category : Int
    var comentary : String
    var autors : NSMutableArray
    var sources : NSMutableArray
    var objetives : NSMutableArray
    
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
        self.autors = NSMutableArray()
        self.sources = NSMutableArray()
        self.objetives = NSMutableArray()
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
        - Autores : \(autors)
        - Fuentes : \(sources)
        - Objetivos : \(objetives)
        """
    }
    
    func getObjetive(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let objetive = Objetive()
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
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                
                                objetive.id = Int(id)!
                                objetive.name = name
                                objetive.descrip = descrip
                                objetive.esta = Int(estab)!
                                objetive.prior = Int(prior)!
                                objetive.urge = Int(urgen)!
                                if(Int(state) == 0){
                                    objetive.state = false
                                }else{
                                    objetive.state = true
                                }
                                objetive.category = Int(category)!
                                objetive.comentary = comentary
                                
                                //Recorro autores
                                if let jsonElement = jsonResult["Resul2"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            objetive.autors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro fuentes
                                if let jsonElement = jsonResult["Resul3"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            objetive.sources.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro objetivos
                                if let jsonElement = jsonResult["Resul4"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            objetive.objetives.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotObjetive(objetive: objetive, codeError: codeError)
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
