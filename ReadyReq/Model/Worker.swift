//
//  Worker.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 09/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Worker : NSObject{
    
    // MARK: - Variables
    
    weak var delegate: WorkerProtocol!
    var id : Int
    var name : String
    var organization : String
    var role : String
    var developer : Bool
    var category : Int
    var comentary : String
    
    // MARK: - Methods
    
    override init() {
        self.id = -1
        self.name = ""
        self.organization = ""
        self.role = ""
        self.developer = false
        self.category = 1
        self.comentary = ""
    }
    
    override var description : String {
        return """
        - Id : \(id)
        - Name : \(name)
        - Organization : \(organization)
        - Role : \(role)
        - Developer : \(developer)
        - Category : \(category)
        - Comentary : \(comentary)
        """
    }
    
    func getWorker(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let worker = Worker()
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
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }else{
                            element = jsonElement[0] as! NSDictionary
                            
                            if  let id = element["Id"] as? String,
                                let name = element["Nombre"] as? String,
                                let organization = element["Organizacion"] as? String,
                                let role = element["Rol"] as? String,
                                let developer = element["Desarrollador"] as? String,
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                worker.id = Int(id)!
                                worker.name = name
                                worker.organization = organization
                                worker.role = role
                                if(Int(developer) == 0){
                                    worker.developer = false
                                }else{
                                    worker.developer = true
                                }
                                worker.category = Int(category)!
                                worker.comentary = comentary
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotWorker(worker: worker, codeError: codeError)
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
