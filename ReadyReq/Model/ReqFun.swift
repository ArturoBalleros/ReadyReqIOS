//
// Autor: Arturo Balleros Albillo
//

import Foundation
import NVActivityIndicatorView

class ReqFun : ObjEstandar {
    
    // MARK: - Variables
    
    weak var delegate: ReqFunProtocol!
    var preCond : String
    var postCond : String
    var package : Int
    var comple : Int
    var requeriments : NSMutableArray
    var actors : NSMutableArray
    var secNor : NSMutableArray
    var secExc : NSMutableArray
    
    // MARK: - Methods
    
    override init() {
        self.preCond = ""
        self.postCond = ""
        self.package = 0
        self.comple = 2
        self.requeriments = NSMutableArray()
        self.actors = NSMutableArray()
        self.secNor = NSMutableArray()
        self.secExc = NSMutableArray()
    }
    
    override var description : String {
        return """
        - Id : \(id)
        - Name : \(name)
        - Descripcion : \(descrip)
        - Prioridad : \(prior)
        - Urgencia : \(urge)
        - Estabilidad : \(esta)
        - Complejidad : \(comple)
        - Estado : \(state)
        - Category : \(category)
        - Comentary : \(comentary)
        - Precondicion : \(preCond)
        - Postcondicion : \(postCond)
        - Package : \(package)
        - Autores : \(autors)
        - Fuentes : \(sources)
        - Objetivos : \(objetives)
        - Requisitos : \(requeriments)
        - Actores : \(actors)
        - Secuencia Normal : \(secNor)
        - Secuencia Excepcion : \(secExc)
        """
    }
    
    func getReqFun(url : URL, activityIndicator : NVActivityIndicatorView) {
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
                        
                        let reqfun = ReqFun()
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
                                let comple = element["Complejidad"] as? String,
                                let prior = element["Prioridad"] as? String,
                                let urgen = element["Urgencia"] as? String,
                                let state = element["Estado"] as? String,
                                let package = element["Paquete"] as? String,
                                let preCond = element["Precond"] as? String,
                                let postCond = element["Postcond"] as? String,
                                let category = element["Categoria"] as? String,
                                let comentary = element["Comentario"] as? String {
                                
                                reqfun.id = Int(id)!
                                reqfun.name = name
                                reqfun.version = Utils.StringToDouble(string: version)
                                reqfun.date = Utils.StringToDate(string: date, MySQL: true)
                                reqfun.descrip = descrip
                                reqfun.esta = Int(estab)!
                                reqfun.comple = Int(comple)!
                                reqfun.prior = Int(prior)!
                                reqfun.urge = Int(urgen)!
                                if(Int(state) == 0){
                                    reqfun.state = false
                                }else{
                                    reqfun.state = true
                                }
                                reqfun.preCond = preCond
                                reqfun.postCond = postCond
                                reqfun.package = Int(package)!
                                reqfun.category = Int(category)!
                                reqfun.comentary = comentary
                                
                                //Recorro autores
                                if let jsonElement = jsonResult["Resul2"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqfun.autors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro fuentes
                                if let jsonElement = jsonResult["Resul3"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqfun.sources.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro objetivos
                                if let jsonElement = jsonResult["Resul4"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqfun.objetives.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro actores
                                if let jsonElement = jsonResult["Resul5"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String{
                                            reqfun.actors.add(Generic(id: Int(id)!, name: name))
                                        }
                                    }
                                }
                                
                                //Recorro requisitos
                                if let jsonElement = jsonResult["Resul6"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if  let id = element["Id"] as? String,
                                            let name = element["Nombre"] as? String,
                                            let tipoReq = element["Tipo"] as? String {
                                            reqfun.requeriments.add(Generic(id: Int(id)!, name: name, tipoReq: Int(tipoReq)!))
                                        }
                                    }
                                }
                                
                                //Recorro secuencia normal
                                if let jsonElement = jsonResult["Resul7"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if let name = element["Descrip"] as? String{
                                            reqfun.secNor.add(Generic(name: name))
                                        }
                                    }
                                }
                                
                                //Recorro secuencia excepcion
                                if let jsonElement = jsonResult["Resul8"]{
                                    for e in jsonElement as! NSArray{
                                        let element = e as! NSDictionary
                                        if let name = element["Descrip"] as? String{
                                            reqfun.secExc.add(Generic(name: name))
                                        }
                                    }
                                }
                                
                                codeError = AppDelegate.SUCCESS_DATA
                            } else {
                                codeError = AppDelegate.ERROR_EMPTY_QUERY
                            }
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.gotReqFun(reqfun: reqfun, codeError: codeError)
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
