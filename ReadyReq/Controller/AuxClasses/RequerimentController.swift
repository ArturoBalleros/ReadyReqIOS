//
// Autor: Arturo Balleros Albillo
//

import UIKit
import NVActivityIndicatorView

class RequerimentController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SaveDeleteObjectProtocol {
    
    // MARK: Variables
    
    @IBOutlet weak var tableView: UITableView!
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
        
        myTabBarReqNFun = tabBarController as? ReqNFunTabBarController
        myTabBarReqInfo = tabBarController as? ReqInfoTabBarController
        myTabBarReqFun = tabBarController as? ReqFunTabBarController
        
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
        if(segue.identifier == "showAddRequeriments"){
            destinationVC.mode = mode
            destinationVC.flagTab = AppDelegate.REQU
            if AppDelegate.REQ_NO_FUN == mode {
                destinationVC.idObject = myTabBarReqNFun.idReqNFun
            } else if AppDelegate.REQ_INFO == mode {
                destinationVC.idObject = myTabBarReqInfo.idReqInfo
            } else {
                destinationVC.idObject = myTabBarReqFun.idReqFun
            }
        }
    }
    
    @IBAction func unwindRequeriment(_ sender: UIStoryboardSegue){
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
        if AppDelegate.REQ_NO_FUN == mode {
            return myTabBarReqNFun.reqnfun.requeriments.count
        } else if AppDelegate.REQ_INFO == mode {
            return myTabBarReqInfo.reqinfo.requeriments.count
        } else {
            return myTabBarReqFun.reqfun.requeriments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if AppDelegate.REQ_NO_FUN == mode {
            cell.textLabel?.text = Utils.deterTipoReq(TipoReq: (myTabBarReqNFun.reqnfun.requeriments[indexPath.row] as! Generic).tipoReq) +  (myTabBarReqNFun.reqnfun.requeriments[indexPath.row] as! Generic).name
            if (myTabBarReqNFun.reqnfun.requeriments[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else if AppDelegate.REQ_INFO == mode {
            cell.textLabel?.text = Utils.deterTipoReq(TipoReq: (myTabBarReqInfo.reqinfo.requeriments[indexPath.row] as! Generic).tipoReq) +  (myTabBarReqInfo.reqinfo.requeriments[indexPath.row] as! Generic).name
            if (myTabBarReqInfo.reqinfo.requeriments[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        } else {
            cell.textLabel?.text = Utils.deterTipoReq(TipoReq: (myTabBarReqFun.reqfun.requeriments[indexPath.row] as! Generic).tipoReq) +  (myTabBarReqFun.reqfun.requeriments[indexPath.row] as! Generic).name
            if (myTabBarReqFun.reqfun.requeriments[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
            }else{ cell.accessoryType = .none }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.requeriments[indexPath.row] as! Generic).isSelected = true
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.requeriments[indexPath.row] as! Generic).isSelected = true
            } else {
                (myTabBarReqFun.reqfun.requeriments[indexPath.row] as! Generic).isSelected = true
            }
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if AppDelegate.REQ_NO_FUN == mode {
                (myTabBarReqNFun.reqnfun.requeriments[indexPath.row] as! Generic).isSelected = false
            } else if AppDelegate.REQ_INFO == mode {
                (myTabBarReqInfo.reqinfo.requeriments[indexPath.row] as! Generic).isSelected = false
            } else {
                (myTabBarReqFun.reqfun.requeriments[indexPath.row] as! Generic).isSelected = false
            }
            cell.accessoryType = .none
        }
    }
    
    // MARK: Buttons
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        if AppDelegate.REQ_NO_FUN == mode {
            for i in myTabBarReqNFun.reqnfun.requeriments{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqNFun.idReqNFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.REQU, id: myTabBarReqNFun.idReqNFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqNFun.reqnfun.requeriments.remove(item)
                }
            }
        } else if AppDelegate.REQ_INFO == mode {
            for i in myTabBarReqInfo.reqinfo.requeriments{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqInfo.idReqInfo != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.REQU, id: myTabBarReqInfo.idReqInfo, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqInfo.reqinfo.requeriments.remove(item)
                }
            }
        } else {
            for i in myTabBarReqFun.reqfun.requeriments{
                let item = i as! Generic
                if item.isSelected{
                    if myTabBarReqFun.idReqFun != AppDelegate.NOTHING{
                        let urlPath = Utils.getUrlDelete(mode: mode, flagTab: AppDelegate.REQU, id: myTabBarReqFun.idReqFun, g: item)
                        webService.save_deleteObject(url: URL(string: urlPath)!)
                    }
                    myTabBarReqFun.reqfun.requeriments.remove(item)
                }
            }
        }
        
        tableView.reloadData()
    }
    
}
