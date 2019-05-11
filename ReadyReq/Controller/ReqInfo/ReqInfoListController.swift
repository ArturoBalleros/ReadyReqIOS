//
//  ReqInfoListController.swift
//  ReadyReq
//
//  Created by Arturo Balleros Albillo on 02/12/2018.
//  Copyright © 2018 Arturo Balleros Albillo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReqInfoListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GenericProtocol {
    
    // MARK: - Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator : NVActivityIndicatorView!
    var refreshControl   = UIRefreshControl()
    var searching = false
    var returnSegue = false
    var items: NSMutableArray = NSMutableArray()
    let itemsSearch: NSMutableArray = NSMutableArray()
    let urlPath: String = "http://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqinfo_frag_list.php"
    let generic = Generic()
    
    // MARK: - View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(returnSegue){
            returnSegue = false
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            generic.getItems(url: URL(string: urlPath)!, activityIndicator : activityIndicator)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        generic.delegate = self
        activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
        generic.getItems(url: URL(string: urlPath)!, activityIndicator : activityIndicator)
        
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("REF", comment: ""))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        returnSegue = true
        var idSelected = AppDelegate.NOTHING
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! ReqInfoTabBarController
        if(segue.identifier == "showEditReqInfo"){
            getIdSelected(idSelected: &idSelected)
            destinationVC.idReqInfo = idSelected
        }
        if(segue.identifier == "showNewReqInfo"){
            destinationVC.idReqInfo = idSelected
        }
    }
    
    // MARK: - WebServices
    
    func gotItems(items: NSMutableArray, codeError : Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.items = items
            tableView.reloadData()
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let resultPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        let resul = items.filtered(using: resultPredicate)
        itemsSearch.removeAllObjects()
        for i in 0 ..< resul.count{
            let item = resul[i] as! Generic
            itemsSearch.add(Generic(id: item.id, name: item.name))
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return itemsSearch.count
        }else{
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(searching){
            cell.textLabel?.text = (itemsSearch[indexPath.row] as! Generic).name
        }else{
            cell.textLabel?.text = (items[indexPath.row] as! Generic).name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh(_ sender: Any) {
        generic.getItems(url: URL(string: urlPath)!, activityIndicator : activityIndicator)
        refreshControl.endRefreshing()
    }
    
    // MARK: - Methods
    
    func getIdSelected(idSelected : inout Int){
        if(searching){
            idSelected = (itemsSearch[tableView.indexPathForSelectedRow!.row] as! Generic).id
        }else{
            idSelected = (items[tableView.indexPathForSelectedRow!.row] as! Generic).id
        }
    }
}
