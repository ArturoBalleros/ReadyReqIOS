//
//  Generic.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 02/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class Generic : NSObject {
    
    // MARK: - Variables
    
    weak var delegate: GenericProtocol!
    let id : Int
    @objc let name : String
    var tipoReq : Int
    var isSelected : Bool = false
    
    // MARK: - Methods
    
    override init() {
        self.id = AppDelegate.NOTHING
        self.name = ""
        self.tipoReq = AppDelegate.NOTHING
    }
    
    init(name: String) {
        self.id = AppDelegate.NOTHING
        self.name = name
        self.tipoReq  = AppDelegate.NOTHING
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.tipoReq  = AppDelegate.NOTHING
    }
    
    init(id: Int, name: String, tipoReq: Int) {
        self.id = id
        self.name = name
        self.tipoReq = tipoReq
    }
    
    init(id: Int, name: String, tipoReq: Int, isSelected: Bool) {
        self.id = id
        self.name = name
        self.tipoReq = tipoReq
        self.isSelected = isSelected
    }
    
    override var description : String {
        return """
        - Id : \(id)
        - Name : \(name)
        - Tipo Requisito : \(tipoReq)
        - isSelected : \(isSelected)
        """
    }
    
    func getItems(url : URL, activityIndicator : NVActivityIndicatorView) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
            } else {
                self.parseJSON(data!, activityIndicator: activityIndicator)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data, activityIndicator : NVActivityIndicatorView) {
        var jsonResult = NSDictionary()
        do{
            jsonResult =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            //print(jsonResult)
            var jsonElement = NSArray()
            var element = NSDictionary()
            jsonElement = jsonResult["Resul"] as! NSArray
            
            let items = NSMutableArray()
            var codeError : Int
            
            element = jsonElement[0] as! NSDictionary
            if let resul = element["a"] as? String
            {
                if resul.elementsEqual("No1"){
                    codeError = AppDelegate.ERROR_READ_FILE
                }else if resul.elementsEqual("No2"){
                    codeError = AppDelegate.ERROR_CONNECT
                } else if resul.elementsEqual("No3"){
                    codeError = AppDelegate.ERROR_QUERY
                } else {
                    codeError = AppDelegate.ERROR_EMPTY_QUERY
                }
            }else{
                for i in 0 ..< jsonElement.count{
                    element = jsonElement[i] as! NSDictionary
                    if let name = element["Nombre"] as? String, let id = element["Id"] as? String {
                        let elementGen = Generic(id: Int(id)!, name: name)
                        if let tipo = element["Tipo"] as? Int{
                            elementGen.tipoReq = tipo
                        }
                        items.add(elementGen)
                    }
                }
                codeError = AppDelegate.SUCCESS_DATA
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.gotItems(items: items, codeError: codeError)
            })
        } catch let error as NSError {
            print(error)
            ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        }
    }
    
}
