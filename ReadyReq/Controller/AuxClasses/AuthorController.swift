//
// Autor: Arturo Balleros Albillo
//

import UIKit
import NVActivityIndicatorView

class AuthorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SaveDeleteObjectProtocol {
    
    // MARK: Variables
    
    @IBOutlet weak var tableView: UITableView!
    var myTabBarActor: ActorTabBarController!
    var myTabBarObjetive: ObjetiveTabBarController!
    var myTabBarReqNFun: ReqNFunTabBarController!
    var myTabBarReqInfo: ReqInfoTabBarController!
    var myTabBarReqFun: ReqFunTabBarController!
    var activityIndicator : NVActivityIndicatorView!
    var mode = 0
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        myTabBarActor = tabBarController as? ActorTabBarController
        myTabBarObjetive = tabBarController as? ObjetiveTabBarController
        myTabBarReqNFun = tabBarController as? ReqNFunTabBarController
        myTabBarReqInfo = tabBarController as? ReqInfoTabBarController
        myTabBarReqFun = tabBarController as? ReqFunTabBarController
        
        do {
            guard let _ = myTabBarActor?.idActor else { throw MyError.FoundNil("Actor") }
            mode = AppDelegate.ACTORES
        } catch { }
        do {
            guard let _ = myTabBarObjetive?.idObjetive else { throw MyError.FoundNil("Objet") }
            mode = AppDelegate.OBJETIVOS
        } catch { }
        do {
            guard let _ = myTabBarReqNFun?.idReqNFun else { throw MyError.FoundNil("ReqNFun") }
            mode = AppDelegate.REQ_NO_FUN
        } catch { }
        do {
            guard let _ = myTabBarReqInfo?.idReqInfo else { throw MyError.FoundNil("ReqInfo") }
            mode = AppDelegate.REQ_INFO
        } catch { }
        do {
            guard let _ = myTabBarReqFun?.idReqFun else { throw MyError.FoundNil("ReqFun") }
            mode = AppDelegate.REQ_FUNC
        } catch { }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! AddItemsController
        if(segue.identifier == "showAddAuthors"){
            destinationVC.mode = mode
            destinationVC.flagTab = AppDelegate.AUTH
            if AppDelegate.ACTORES == mode {
                destinationVC.idObject = myTabBarActor.idActor
            } else if AppDelegate.OBJETIVOS == mode {
                destinationVC.idObject = myTabBarObjetive.idObjetive
            } else if AppDelegate.REQ_NO_FUN == mode {
                destinationVC.idObject = myTabBarReqNFun.idReqNFun
            } else if AppDelegate.REQ_INFO == mode {
                destinationVC.idObject = myTabBarReqInfo.idReqInfo
            } else {
                destinationVC.idObject = myTabBarReqFun.idReqFun
            }
        }
    }
    
    @IBAction func unwindAuthor(_ sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    // MARK: WebServices
    
    func gotResulItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppDelegate.ACTORES == mode {
            return myTabBarActor.actor.autors.count
        } else if AppDelegate.OBJETIVOS == mode {
            return myTabBarObjetive.objetive.autors.count
        } else if AppDelegate.REQ_NO_FUN == mode {
            return myTabBarReqNFun.reqnfun.autors.count
        } else if AppDelegate.REQ_INFO == mode {
            return myTabBarReqInfo.reqinfo.autors.count
        } else {
            return myTabBarReqFun.reqfun.autors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if AppDelegate.ACTORES == mode {
            cell.textLabel?.text = (myTabBarActor.actor.autors[indexPath.row] as! Generic).name
            if (myTabBarActor.actor.autors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.OBJETIVOS == mode {
            cell.textLabel?.text = (myTabBarObjetive.objetive.autors[indexPath.row] as! Generic).name
            if (myTabBarObjetive.objetive.autors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.REQ_NO_FUN == mode {
            cell.textLabel?.text = (myTabBarReqNFun.reqnfun.autors[indexPath.row] as! Generic).name
            if (myTabBarReqNFun.reqnfun.autors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.REQ_INFO == mode {
            cell.textLabel?.text = (myTabBarReqInfo.reqinfo.autors[indexPath.row] as! Generic).name
            if (myTabBarReqInfo.reqinfo.autors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else {
            cell.textLabel?.text = (myTabBarReqFun.reqfun.autors[indexPath.row] as! Generic).name
            if (myTabBarReqFun.reqfun.autors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.ACTORES == mode {
                (myTabBarActor.actor.autors[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.OBJETIVOS == mode {
                (myTabBarObjetive.objetive.autors[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.autors[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.autors[indexPath.row] as! Generic).isSelected = true
            } else {
                (myTabBarReqFun.reqfun.autors[indexPath.row] as! Generic).isSelected = true
            }
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.ACTORES == mode {
                (myTabBarActor.actor.autors[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.OBJETIVOS == mode {
                (myTabBarObjetive.objetive.autors[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.autors[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.autors[indexPath.row] as! Generic).isSelected = false
            } else {
                (myTabBarReqFun.reqfun.autors[indexPath.row] as! Generic).isSelected = false
            }
            cell.accessoryType = .none
        }
    }
    
    // MARK: Buttons
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        if AppDelegate.ACTORES == mode {
            for i in myTabBarActor.actor.autors{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarActor.idActor != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.AUTH, id: myTabBarActor.idActor, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarActor.actor.autors.remove(item)
                }
            }
        } else if AppDelegate.OBJETIVOS == mode {
            for i in myTabBarObjetive.objetive.autors{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarObjetive.idObjetive != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.AUTH, id: myTabBarObjetive.idObjetive, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarObjetive.objetive.autors.remove(item)
                }
            }
        } else if AppDelegate.REQ_NO_FUN == mode {
            for i in myTabBarReqNFun.reqnfun.autors{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqNFun.idReqNFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.AUTH, id: myTabBarReqNFun.idReqNFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqNFun.reqnfun.autors.remove(item)
                }
            }
        } else if AppDelegate.REQ_INFO == mode {
            for i in myTabBarReqInfo.reqinfo.autors{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqInfo.idReqInfo != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.AUTH, id: myTabBarReqInfo.idReqInfo, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqInfo.reqinfo.autors.remove(item)
                }
            }
        } else {
            for i in myTabBarReqFun.reqfun.autors{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqFun.idReqFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.AUTH, id: myTabBarReqFun.idReqFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqFun.reqfun.autors.remove(item)
                }
            }
        }
        
        tableView.reloadData()
    }
    
}
