//
// Autor: Arturo Balleros Albillo
//

import Foundation
import NVActivityIndicatorView

class ReqNFun : ObjEstandar {
    
    // MARK: - Variables
    
    weak var delegate: ReqNFunProtocol!
    var requeriments : NSMutableArray
    
    // MARK: - Methods
    
    override init() {
        self.requeriments = NSMutableArray()
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
        - Requisitos : \(requeriments)
        """
    }
    
    func getReqNFun(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let reqnfun = ReqNFun()
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
                                let version = element["Version"] as? String,
                                let date = element["Fecha"] as? String,
                                let descrip = element["Descripcion"] as? String,
                                let estab = element["Estabilidad"] as? String,
                                let prior = element["Prioridad"] as? String,
                                let urgen = element["Urgencia"] as? String,
                                let state = element["Estado"] as? String,
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                
                                reqnfun.id = Int(id)!
                                reqnfun.name = name
                                reqnfun.version = Utils.StringToDouble(string: version)
                                reqnfun.date = Utils.StringToDate(string: date, MySQL: true)
                                reqnfun.descrip = descrip
                                reqnfun.esta = Int(estab)!
                                reqnfun.prior = Int(prior)!
                                reqnfun.urge = Int(urgen)!
                                if(Int(state) == 0){
                                    reqnfun.state = false
                                }else{
                                    reqnfun.state = true
                                }
                                reqnfun.category = Int(category)!
                                reqnfun.comentary = comentary
                                
                                //Recorro autores
                                if let jsonElement = jsonResult["Resul2"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqnfun.autors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro fuentes
                                if let jsonElement = jsonResult["Resul3"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqnfun.sources.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro objetivos
                                if let jsonElement = jsonResult["Resul4"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqnfun.objetives.add(Generic(id: Int(id)!, name: name))
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
                                            reqnfun.requeriments.add(Generic(id: Int(id)!, name: name, tipoReq: Int(tipoReq)!))
                                        }
                                    }
                                }
                                
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                            
                            
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotReqNFun(reqnfun: reqnfun, codeError: codeError)
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
