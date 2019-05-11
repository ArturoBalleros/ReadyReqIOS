//
//  Actor.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Actor : NSObject {
    
    // MARK: - Variables
    
    weak var delegate: ActorProtocol!
    var id : Int
    var name : String
    var descrip : String
    var comple : Int
    var descComple : String
    var category : Int
    var comentary : String
    var autors : NSMutableArray
    var sources : NSMutableArray
    
    // MARK: - Methods
    
    override init() {
        self.id = -1
        self.name = ""
        self.descrip = ""
        self.comple = 2
        self.descComple = ""
        self.category = 1
        self.comentary = ""
        self.autors = NSMutableArray()
        self.sources = NSMutableArray()
    }
    
    override var description : String {
        return """
        - Id : \(id)
        - Name : \(name)
        - Descripcion : \(descrip)
        - Complejidad : \(comple)
        - Descripcion de Complejidad : \(descComple)
        - Category : \(category)
        - Comentary : \(comentary)
        - Autores : \(autors)
        - Fuentes : \(sources)
        """
    }
    
    func getActor(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let actor = Actor()
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
                                let descComple = element["DescComple"] as? String,
                                let comple = element["Complejidad"] as? String,
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                
                                actor.id = Int(id)!
                                actor.name = name
                                actor.descrip = descrip
                                actor.descComple = descComple
                                actor.comple = Int(comple)!
                                actor.category = Int(category)!
                                actor.comentary = comentary
                                
                                //Recorro autores
                                if let jsonElement = jsonResult["Resul2"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            actor.autors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro fuentes
                                if let jsonElement = jsonResult["Resul3"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            actor.sources.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotActor(actor: actor, codeError: codeError)
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
