//
//  SourceActorController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SourceActorController: UIViewController,  UITableViewDelegate, UITableViewDataSource, DeleteObjectProtocol {
    func gotResulDeleteItem(codeError: Int) {
        Utils.showError(codeError: codeError, controller: self)
    }
    
    var myTabBar: ActorTabBarController! {
        return tabBarController as? ActorTabBarController
    }
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
     
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTabBar.actor.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = (myTabBar.actor.sources[indexPath.row] as! Generic).name
            if (myTabBar.actor.sources[indexPath.row] as! Generic).isSelected {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                (myTabBar.actor.sources[indexPath.row] as! Generic).isSelected = true
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
           (myTabBar.actor.sources[indexPath.row] as! Generic).isSelected = false
        cell.accessoryType = .none
        }
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! AddItemsController
        if(segue.identifier == "showActorAddSources"){
            destinationVC.mode = AppDelegate.ACTORES
            destinationVC.flagTab = AppDelegate.SOUR
            destinationVC.idObject = myTabBar.idActor
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        for i in myTabBar.actor.sources{
            let item = i as! Generic
            if item.isSelected{
                if myTabBar.idActor != AppDelegate.NOTHING{
                    let urlPath = Utils.getUrlDelete(mode: AppDelegate.ACTORES, flagTab: AppDelegate.SOUR, id: myTabBar.idActor, g: item)
                    let webService = Utils()
                    webService.delegateDeleteObject = self
                    webService.deleteObject(url: URL(string: urlPath)!)
                }
                myTabBar.actor.sources.remove(item)
            }
        }
        tableView.reloadData()
    }

    
    @IBAction func unwindActorSource(_ sender: UIStoryboardSegue){
 tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
