//
//  AuthorActorController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 10/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AuthorActorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DeleteObjectProtocol {
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
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myTabBar.actor.autors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (myTabBar.actor.autors[indexPath.row] as! Generic).name
        if (myTabBar.actor.autors[indexPath.row] as! Generic).isSelected {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                (myTabBar.actor.autors[indexPath.row] as! Generic).isSelected = true
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                (myTabBar.actor.autors[indexPath.row] as! Generic).isSelected = false
            cell.accessoryType = .none
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! AddItemsController
        if(segue.identifier == "showActorAddAuthors"){
            destinationVC.mode = AppDelegate.ACTORES
            destinationVC.flagTab = AppDelegate.AUTH
            destinationVC.idObject = myTabBar.idActor
        }
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        for i in myTabBar.actor.autors{
            let item = i as! Generic
            if item.isSelected{
                if myTabBar.idActor != AppDelegate.NOTHING{
                    let urlPath = Utils.getUrlDelete(mode: AppDelegate.ACTORES, flagTab: AppDelegate.AUTH, id: myTabBar.idActor, g: item)
                    let webService = Utils()
                    webService.delegateDeleteObject = self
                    webService.deleteObject(url: URL(string: urlPath)!)
                }
                myTabBar.actor.autors.remove(item)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func unwindActorAuthor(_ sender: UIStoryboardSegue){
     tableView.reloadData()
    }
 
    
}
