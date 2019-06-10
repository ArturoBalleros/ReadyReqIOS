//
//  MyUserDefaults.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 02/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation

class MyUserDefaults{
    
    // MARK: - Write
    
    public static func writeUDServerIp(serverIP: String) {
        let userD = UserDefaults.standard
        userD.set(serverIP , forKey: "serverIP")
    }
    
    public static func writeUDUser(user: String) {
        let userD = UserDefaults.standard
        userD.set(user , forKey: "user")
    }
    
    public static func writeUDPass(pass: String) {
        let userD = UserDefaults.standard
        userD.set(pass , forKey: "pass")
    }
    
    public static func writeUDDatabase(database: String) {
        let userD = UserDefaults.standard
        userD.set(database , forKey: "database")
    }
    
    public static func writeUDPort(port: Int) {
        let userD = UserDefaults.standard
        userD.set(port , forKey: "port")
    }
    
    public static func writeUDPortHTTP(portHTTP: Int) {
        let userD = UserDefaults.standard
        userD.set(portHTTP , forKey: "portHTTP")
    }
    
    public static func writeUDServerIpMySQL(serverIPMySQL: String) {
        let userD = UserDefaults.standard
        userD.set(serverIPMySQL , forKey: "serverIPMySQL")
    }
    
    public static func writeUDHTTP(HTTP: String) {
        let userD = UserDefaults.standard
        userD.set(HTTP , forKey: "HTTP")
    }
    
    // MARK: - Read
    
    public static func readUDServerIp() -> String {
        let userD = UserDefaults.standard
        if let serverIP = userD.string(forKey: "serverIP"){
            return serverIP
        }else{
            return "No"
        }
    }
    
    public static func readUDUser() -> String {
        let userD = UserDefaults.standard
        if let user = userD.string(forKey: "user"){
            return user
        }else{
            return "No"
        }
    }
    
    public static func readUDPass() -> String {
        let userD = UserDefaults.standard
        if let pass = userD.string(forKey: "pass"){
            return pass
        }else{
            return "No"
        }
    }
    
    public static func readUDDatabase() -> String {
        let userD = UserDefaults.standard
        if let database = userD.string(forKey: "database"){
            return database
        }else{
            return "No"
        }
    }
    
    public static func readUDPort() -> Int {
        let userD = UserDefaults.standard
        let port = userD.integer(forKey: "port")
        if port != 0{
            return port
        }else{
            return 3306
        }
    }
    
    public static func readUDPortHTTP() -> Int {
        let userD = UserDefaults.standard
        let portHTTP = userD.integer(forKey: "portHTTP")
        if portHTTP != 0{
            return portHTTP
        }else{
            return 8080
        }
    }
    
    public static func readUDServerIpMySQL() -> String {
        let userD = UserDefaults.standard
        if let serverIPMySQL = userD.string(forKey: "serverIPMySQL"){
            return serverIPMySQL
        }else{
            return "No"
        }
    }
    
    public static func readUDHTTP() -> String {
        let userD = UserDefaults.standard
        if let HTTP = userD.string(forKey: "HTTP"){
            return HTTP
        }else{
            return "No"
        }
    }
    
}
