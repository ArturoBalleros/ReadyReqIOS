//
// Autor: Arturo Balleros Albillo
//

import UIKit
import NVActivityIndicatorView

class ActorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SaveDeleteObjectProtocol {
    
    // MARK: Variables
    
    @IBOutlet weak var tableView: UITableView!
    var myTabBar: ReqFunTabBarController!
    var activityIndicator : NVActivityIndicatorView!
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        myTabBar = tabBarController as? ReqFunTabBarController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! AddItemsController
        if(segue.identifier == "showAddActors"){
            destinationVC.mode = AppDelegate.REQ_FUNC
            destinationVC.flagTab = AppDelegate.ACTO
            destinationVC.idObject = myTabBar.idReqFun
        }
    }
    
    @IBAction func unwindActor(_ sender: UIStoryboardSegue){
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
        return myTabBar.reqfun.actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (myTabBar.reqfun.actors[indexPath.row] as! Generic).name
        if (myTabBar.reqfun.actors[indexPath.row] as! Generic).isSelected { cell.accessoryType = .checkmark
        }else{ cell.accessoryType = .none }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            (myTabBar.reqfun.actors[indexPath.row] as! Generic).isSelected = true
            
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            (myTabBar.reqfun.actors[indexPath.row] as! Generic).isSelected = false
            
            cell.accessoryType = .none
        }
    }
    
    // MARK: Buttons
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let webService = Utils()
        webService.delegateSaveDeleteObject = self
        for i in myTabBar.reqfun.actors{
            let item = i as! Generic
            if item.isSelected{
                if myTabBar.idReqFun != AppDelegate.NOTHING{
                    let urlPath = Utils.getUrlDelete(mode: AppDelegate.REQ_FUNC, flagTab: AppDelegate.ACTO, id: myTabBar.idReqFun, g: item)
                    webService.save_deleteObject(url: URL(string: urlPath)!)
                }
                myTabBar.reqfun.actors.remove(item)
            }
        }
        tableView.reloadData()
    }
    
}
