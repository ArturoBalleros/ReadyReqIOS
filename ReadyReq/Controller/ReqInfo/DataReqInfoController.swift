//
// Autor: Arturo Balleros Albillo
//

import UIKit
import NVActivityIndicatorView

class DataReqInfoController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ReqInfoProtocol {
    
    // MARK: - Variables
    
    var myTabBar: ReqInfoTabBarController! {
        return tabBarController as? ReqInfoTabBarController
    }
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescrip: UITextField!
    @IBOutlet weak var pickerPrior: UIPickerView!
    @IBOutlet weak var pickerUrge: UIPickerView!
    @IBOutlet weak var pickerEstab: UIPickerView!
    @IBOutlet weak var switchState: UISwitch!
    @IBOutlet weak var pickerCateg: UIPickerView!
    @IBOutlet weak var txtComen: UITextView!
    @IBOutlet weak var sliderOcuMed: UISlider!
    @IBOutlet weak var labelOcuMed: UILabel!
    @IBOutlet weak var sliderOcuMax: UISlider!
    @IBOutlet weak var labelOcuMax: UILabel!
    @IBOutlet weak var sliderTimMed: UISlider!
    @IBOutlet weak var labelTimMed: UILabel!
    @IBOutlet weak var sliderTimMax: UISlider!
    @IBOutlet weak var labelTimMax: UILabel!
    @IBOutlet weak var txtVer: UITextField!
    @IBOutlet weak var picketDate: UIDatePicker!
    var activityIndicator : NVActivityIndicatorView!
    var reqinfo = ReqInfo()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reqinfo.delegate = self
        self.txtComen.delegate = self
        self.pickerPrior.dataSource = self
        self.pickerPrior.delegate = self
        self.pickerUrge.dataSource = self
        self.pickerUrge.delegate = self
        self.pickerEstab.dataSource = self
        self.pickerEstab.delegate = self
        self.pickerCateg.dataSource = self
        self.pickerCateg.delegate = self
        self.picketDate.datePickerMode = .date
        if(myTabBar.idReqInfo != AppDelegate.NOTHING){
            activityIndicator = ToolsView.beginActivityIndicator(view: self.view)
            let urlPath: String = MyUserDefaults.readUDHTTP() + "://" + MyUserDefaults.readUDServerIp() + ":" + String(MyUserDefaults.readUDPortHTTP()) + "/readyreq/reqinfo_search.php?a=\(myTabBar.idReqInfo)"
            reqinfo.getReqInfo(url: URL(string: urlPath)!, activityIndicator: activityIndicator)
        }else{
            myTabBar.reqinfo = self.reqinfo
            sliderOcuMed.value = Float(reqinfo.ocuMed)
            labelOcuMed.text = "\(Int(sliderOcuMed.value))"
            sliderOcuMax.value = Float(reqinfo.ocuMax)
            labelOcuMax.text = "\(Int(sliderOcuMax.value))"
            sliderTimMed.value = Float(reqinfo.timeMed)
            labelTimMed.text = "\(Int(sliderTimMed.value))"
            sliderTimMax.value = Float(reqinfo.timeMax)
            labelTimMax.text = "\(Int(sliderTimMax.value))"
            self.pickerPrior.selectRow((self.reqinfo.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqinfo.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqinfo.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqinfo.state, animated: false)
        }
    }
    
    // MARK: - WebServices
    
    func gotReqInfo(reqinfo: ReqInfo, codeError: Int) {
        if(codeError == AppDelegate.SUCCESS_DATA){
            self.reqinfo = reqinfo
            myTabBar.reqinfo = self.reqinfo
            txtName.text = self.reqinfo.name
            txtVer.text = String(self.reqinfo.version)
            picketDate.date  = self.reqinfo.date
            txtDescrip.text = self.reqinfo.descrip
            sliderOcuMed.value = Float(reqinfo.ocuMed)
            labelOcuMed.text = "\(Int(sliderOcuMed.value))"
            sliderOcuMax.value = Float(reqinfo.ocuMax)
            labelOcuMax.text = "\(Int(sliderOcuMax.value))"
            sliderTimMed.value = Float(reqinfo.timeMed)
            labelTimMed.text = "\(Int(sliderTimMed.value))"
            sliderTimMax.value = Float(reqinfo.timeMax)
            labelTimMax.text = "\(Int(sliderTimMax.value))"
            self.pickerPrior.selectRow((self.reqinfo.prior-1), inComponent: 0, animated: false)
            self.pickerUrge.selectRow((self.reqinfo.urge-1), inComponent: 0, animated: false)
            self.pickerEstab.selectRow((self.reqinfo.esta-1), inComponent: 0, animated: false)
            self.switchState.setOn(self.reqinfo.state, animated: false)
            self.pickerCateg.selectRow((self.reqinfo.category-1), inComponent: 0, animated: false)
            txtComen.text = self.reqinfo.comentary
        }
        Utils.showError(codeError: codeError, controller: self)
        ToolsView.hideActivityIndicator(activityIndicator: activityIndicator)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag != 0){
            return AppDelegate.RANGE_VALUES.count
        }else{
            return AppDelegate.CATEGORY.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag != 0){
            return AppDelegate.RANGE_VALUES[row+1]
        }else{
            return String(AppDelegate.CATEGORY[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqinfo.prior = i
                    break
                }
            }
        } else if(pickerView.tag == 2){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqinfo.urge = i
                    break
                }
            }
        } else if(pickerView.tag == 3){
            for i in 1...AppDelegate.RANGE_VALUES.count{
                if(AppDelegate.RANGE_VALUES[row+1]!.elementsEqual(AppDelegate.RANGE_VALUES[i]!)){
                    reqinfo.esta = i
                    break
                }
            }
        }else{
            reqinfo.category = AppDelegate.CATEGORY[row]
        }
    }
    
    // MARK: - Slider
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if sender.tag == 1{
            labelOcuMed.text = "\(Int(sliderOcuMed.value))"
            reqinfo.ocuMed = Int(sliderOcuMed.value)
        } else if sender.tag == 2 {
            labelOcuMax.text = "\(Int(sliderOcuMax.value))"
            reqinfo.ocuMax = Int(sliderOcuMax.value)
        } else if sender.tag == 3 {
            labelTimMed.text = "\(Int(sliderTimMed.value))"
            reqinfo.timeMed = Int(sliderTimMed.value)
        } else {
            labelTimMax.text = "\(Int(sliderTimMax.value))"
            reqinfo.timeMax = Int(sliderTimMax.value)
        }
    }
    
    // MARK: - Switch
    
    @IBAction func switchStateDidChange(_ sender: Any) {
        if (self.switchState.isOn){
            reqinfo.state = true
        }else{
            reqinfo.state = false
        }
    }
    
    // MARK: - Text
    
    func textViewDidChange(_ textView: UITextView) {
        reqinfo.comentary = txtComen.text!
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if(sender.tag == 4){
            reqinfo.name = txtName.text!
        }
        if(sender.tag == 5){
            reqinfo.descrip = txtDescrip.text!
        }
        if(sender.tag == 6){
            reqinfo.version = Utils.StringToDouble(string: txtVer.text!)
        }
    }
    
    // MARK: - DatePicket
    
    @IBAction func pickerChanged(_ sender: Any) {
        reqinfo.date = picketDate.date
    }
    
}
