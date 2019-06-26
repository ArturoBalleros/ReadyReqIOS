//
// Autor: Arturo Balleros Albillo
//

import UIKit
import NVActivityIndicatorView

class DataReqFunController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ReqFunProtocol, GenericProtocol {
    
    // MARK: - Variables
    
    var myTabBar: ReqFunTabBarController! {
        return tabBarController as? ReqFunTabBarController
    }
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescrip: UITextField!
    @IBOutlet weak var txtPreCond: UITextField!
    @IBOutlet weak var txtPostCond: UITextField!
    @IBOutlet weak var pickerPack: UIPickerView!
    @IBOutlet weak var pickerPrior: UIPickerView!
    @IBOutlet weak var pickerUrge: UIPickerView!
    @IBOutlet weak var pickerEstab: UIPickerView!
    @IBOutlet weak var pickerComple: UIPickerView!
    @IBOutlet weak var switchState: UISwitch!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    @IBOutlet weak var txtVer: UITextField!
    @IBOutlet weak var picketDate: UIDatePicker!
    var activityIndicator : NVActivityIndicatorView!
    var reqfun = ReqFun()
    var items: NSMutableArray = NSMutableArray()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reqfun.delegate = self
        self.txtComen.delegate = self
        self.pickerPrior.dataSource = self
        self.pickerPrior.delegate = self
        self.pickerUrge.dataSource = self
        self.pickerUrge.delegate = self
        self.pickerEstab.dataSource = self
        self.pickerEstab.delegate = self
        self.pickerComple.dataSource = self
        self.pickerComple.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        self.picketDate.datePickerMode = .date
        let urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/paq_frag_list.php"
        let generic = Generic()
        generic.delegate = self
        activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
        generic.getItems(url: URL(string: urlPath)!, activityIndicator : activityIndicator)
    }
    
    // MARK: - WebServices
    
    func gotReqFun(reqfun: ReqFun, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.reqfun = reqfun
            myTabBar.reqfun = self.reqfun
            txtName.text = self.reqfun.name
            txtVer.text = String(self.reqfun.version)
            picketDate.date  = self.reqfun.date
            txtDescrip.text = self.reqfun.descrip
            txtPreCond.text = self.reqfun.preCond
            txtPostCond.text = self.reqfun.postCond
            var cont = 0
            for i in items{
                let item = i as! Generic
                if(item.id == reqfun.package){
                    self.pickerPack.selectRow(cont, inComponent: 0, animated: false)
                    break
                }
                cont+=1
            }
            self.pickerPrior.selectRow((self.reqfun.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqfun.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqfun.esta-1), inComponent: 0, animated: false)
            self.pickerComple.selectRow((self.reqfun.comple-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqfun.state, animated: false)
            self.pickerCateg.selectRow((self.reqfun.category-1), inComponent: 0, animated: false)
            txtComen.text = self.reqfun.comentary
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    func gotItems(items: NSMutableArray, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.items = items
        }
        items.insert(Generic(id: 0, name: "No Asignado"), at: 0)
        self.pickerPack.dataSource = self
        self.pickerPack.delegate = self
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
        if(myTabBar.idReqFun != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqfun_search.php?a=\(myTabBar.idReqFun)"
            reqfun.getReqFun(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            myTabBar.reqfun = self.reqfun
            self.pickerPrior.selectRow(0, inComponent: 0, animated: false)
            self.pickerPrior.selectRow((self.reqfun.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqfun.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqfun.esta-1), inComponent: 0, animated: false)
            self.pickerComple.selectRow((self.reqfun.comple-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqfun.state, animated: false)
        }
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag != 0 && pickerView.tag != 4 && pickerView.tag != 5){
            return AppDelegate.RANGE_VALUES.count
        }else if pickerView.tag == 4{
            return items.count
        }else if pickerView.tag == 5{
            return AppDelegate.COMPLEXITY.count
        }else{
            return AppDelegate.CATEGORY.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag != 0 && pickerView.tag != 4 && pickerView.tag != 5){
            return AppDelegate.RANGE_VALUES[row+1]
        }else if pickerView.tag == 4{
            let pack = (items[row] as! Generic).name
            return pack
        }else if pickerView.tag == 5{
            return AppDelegate.COMPLEXITY[row+1]
        }else{
            return String(AppDelegate.CATEGORY[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqfun.prior = i
                    break
                }
            }
        } else if(pickerView.tag == 2){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqfun.urge = i
                    break
                }
            }
        } else if(pickerView.tag == 3){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqfun.esta = i
                    break
                }
            }
        } else if(pickerView.tag == 4) {
            reqfun.package = (items[row] as! Generic).id
        } else if(pickerView.tag == 5){
            for i in 1...AppDelegate.COMPLEXITY.count{
                if(AppDelegate.COMPLEXITY[row+1]!.elementsEqual(AppDelegate.COMPLEXITY[i]!)){
                    reqfun.comple = i
                    break
                }
            }
        } else {
            reqfun.category = AppDelegate.CATEGORY[row]
        }
    }
    
    // MARK: - Switch
    
    @IBAction func switchStateDidChange(_ sender: Any) {
        if (self.switchState.isOn){
            reqfun.state = true
        }else{
            reqfun.state = false
        }
    }
    
    // MARK: - Text
    
    func textViewDidChange(_ textView: UITextView) {
        reqfun.comentary = txtComen.text!
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if(sender.tag == 4){
            reqfun.name = txtName.text!
        }
        if(sender.tag == 5){
            reqfun.descrip = txtDescrip.text!
        }
        if(sender.tag == 6){
            reqfun.preCond = txtPreCond.text!
        }
        if(sender.tag == 7){
            reqfun.postCond = txtPostCond.text!
        }
        if(sender.tag == 8){
            reqfun.version = Utils.StringToDouble(string: txtVer.text!)
        }
    }
    
    // MARK: - DatePicket
    
    @IBAction func pickerChanged(_ sender: Any) {
        reqfun.date = picketDate.date
    }
    
}
