//
//  ConfigurationController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 27/11/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView 

class ConfigurationController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var txtIPServer: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtDatabase: UITextField!
    @IBOutlet weak var txtPort: UITextField!
    @IBOutlet weak var txtPortHttp: UITextField!
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUser.delegate = self
        txtPassword.delegate = self
        txtDatabase.delegate = self
        initValueText()
    }
    
    // MARK: - TextFields
    //Funcion para detectar cuando en el teclado se le da al intro
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == self.txtUser) {
            if(!self.txtUser.text!.isEmpty){
                self.txtPassword.becomeFirstResponder()
            }else{
                ToolsView.showToast(message: NSLocalizedString("TXT_EMPTY", comment: ""), controller: self)
            }
        }
        if (textField == self.txtPassword) {
            if(!self.txtPassword.text!.isEmpty){
                self.txtDatabase.becomeFirstResponder()
            }else{
                ToolsView.showToast(message: NSLocalizedString("TXT_EMPTY", comment: ""), controller: self)
            }
        }
        if (textField == self.txtDatabase) {
            if(!self.txtDatabase.text!.isEmpty){
                self.txtUser.becomeFirstResponder()
            }else{
                ToolsView.showToast(message: NSLocalizedString("TXT_EMPTY", comment: ""), controller: self)
            }
        }
        return true
    }
    
    // MARK: - Buttons
    
    @IBAction func But_Connect(_ sender: UIButton) {
        if  let serverIP = self.txtIPServer.text,
            let user = self.txtUser.text,
            let pass = self.txtPassword.text,
            let database = self.txtDatabase.text,
            let port = self.txtPort.text,
            let portHTTP = self.txtPortHttp.text {
            
            MyUserDefaults.writeUDServerIp(serverIP: serverIP)
            MyUserDefaults.writeUDUser(user: user)
            MyUserDefaults.writeUDPass(pass: pass)
            MyUserDefaults.writeUDDatabase(database: database)
            MyUserDefaults.writeUDPort(port: Int(port)!)
            MyUserDefaults.writeUDPortHTTP(portHTTP: Int(portHTTP)!)
            
            var urlPath: String = "http://" + serverIP + ":" + portHTTP + "/readyreq/conf_frag_connection_mac.php?"
            urlPath += "a=" + serverIP + "&"
            urlPath += "b=" + user + "&"
            urlPath += "c=" + encriptarPass(pass: pass) + "&"
            urlPath += "d=" + database + "&"
            urlPath += "e=" + port
            urlPath = Utils.convert_Url(url: urlPath)
            if(!urlPath.elementsEqual("ERROR")){
                connectServer(url: URL(string: urlPath)!)
            }else{
                ToolsView.showToast(message: NSLocalizedString("ERROR_URL", comment: ""), controller: self)
            }
        }
    }
    
    // MARK: - Functions
    
    func initValueText() {
        let serverIp = MyUserDefaults.readUDServerIp()
        let user = MyUserDefaults.readUDUser()
        let pass = MyUserDefaults.readUDPass()
        let database = MyUserDefaults.readUDDatabase()
        let port = String(MyUserDefaults.readUDPort())
        let portHTTP = String(MyUserDefaults.readUDPortHTTP())
        
        if(!serverIp.elementsEqual("No")){
            txtIPServer.text = serverIp
        }
        if(!user.elementsEqual("No")){
            txtUser.text = user
        }
        if(!pass.elementsEqual("No")){
            txtPassword.text = pass
        }
        if(!database.elementsEqual("No")){
            txtDatabase.text = database
        }
        if(!port.elementsEqual("0")){
            txtPort.text = port
        }
        if(!portHTTP.elementsEqual("0")){
            txtPortHttp.text = portHTTP
        }
    }
    
    func encriptarPass (pass: String) -> String {
        let valoresAleatorios = ["a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var claveEncriptada = ""
        var contador = 0
        for char in pass{
            claveEncriptada += String(char)
            contador += 1
            for _ in 1...contador{
                claveEncriptada += valoresAleatorios.randomElement()!
            }
        }
        return claveEncriptada
    }
    
    // MARK: - WebServices
    
    func connectServer(url : URL) {
        activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                ToolsView.hideActivityIndicator(activityIndicator: self.activityIndicator)
            } else {
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        //Json entero
        var jsonResult = NSDictionary()
        do{
            jsonResult =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            //Distintas colecciones de resultados (Resul en mis casos)
            var jsonElement = NSArray()
            //Dicionario con todos los elementos de la peticion
            var element = NSDictionary()
            jsonElement = jsonResult["Resul"] as! NSArray
            element = jsonElement[0] as! NSDictionary
            if let resul = element["a"] as? String
            {
                ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
                var codeError : Int
                if resul.elementsEqual("Si"){
                    codeError = AppDelegate.SUCCESS
                }else if resul.elementsEqual("No1"){
                    codeError = AppDelegate.ERROR_EMPTY_PARAM
                }else if resul.elementsEqual("No2"){
                    codeError = AppDelegate.ERROR_CONNECT
                } else {
                    codeError = AppDelegate.CONF_FRAG_ERROR_1
                }
                Utils.showError(codeError: codeError, controller: self)
            }
        } catch let error as NSError {
            print(error)
            ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        }
    }
}
