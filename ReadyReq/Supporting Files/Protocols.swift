//
//  Protocols.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import Foundation

protocol GenericProtocol: class {
    func gotItems(items: NSMutableArray, codeError: Int)
}

protocol IdObjectProtocol: class {
    func gotIdObject(idObject: Int, codeError: Int)
}

protocol ActorProtocol: class {
    func gotActor(actor: Actor, codeError: Int)
}
protocol IdProtocol: class {
    func gotId(id: Int, codeError: Int)
}

protocol ObjetiveProtocol: class {
    func gotObjetive(objetive: Objetive, codeError: Int)
}

protocol PackageProtocol: class {
    func gotPackage(package: Package, codeError: Int)
}

protocol ReqFunProtocol: class {
    func gotReqFun(reqfun: ReqFun, codeError: Int)
}

protocol ReqInfoProtocol: class {
    func gotReqInfo(reqinfo: ReqInfo, codeError: Int)
}

protocol ReqNFunProtocol: class {
    func gotReqNFun(reqnfun: ReqNFun, codeError: Int)
}

protocol WorkerProtocol: class {
    func gotWorker(worker: Worker, codeError: Int)
}

protocol CUDProtocol: class {
    func gotResul(codeError: Int)
}

protocol SaveDeleteObjectProtocol: class {
    func gotResulItem(codeError: Int)
}

enum MyError: Error {
    case FoundNil(String)
}
