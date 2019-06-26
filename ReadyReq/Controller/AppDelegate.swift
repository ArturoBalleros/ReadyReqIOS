//
// Autor: Arturo Balleros Albillo
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    
    public static let NOTHING = -1
    public static let GRUPO = 0
    public static let PAQUETES = 1
    public static let OBJETIVOS = 2
    public static let ACTORES = 3
    public static let REQ_FUNC = 4
    public static let REQ_NO_FUN = 5
    public static let REQ_INFO = 6
    
    public static let DATA = 0
    public static let AUTH = 1
    public static let SOUR = 2
    public static let OBJE = 3
    public static let REQU = 4
    public static let ACTO = 5
    
    public static let SEC_NOR = 46
    public static let SEC_EXC = 47
    public static let DAT_ESP = 65
    
    public static let ERROR_URL = 1
    public static let ERROR_EMPTY_PARAM = 2
    public static let ERROR_EMPTY_QUERY = 3
    public static let ERROR_QUERY = 4
    public static let ERROR_READ_FILE = 5
    public static let ERROR_CONNECT = 6
    public static let CONF_FRAG_ERROR_1 = 7
    public static let SUCCESS = 0
    public static let SUCCESS_DATA = 8
    
    public static let CATEGORY = [1,2,3,4,5,6,7,8,9,10]
    public static let COMPLEXITY = [1 : NSLocalizedString("LOW", comment: ""),
                                    2 : NSLocalizedString("MED", comment: ""),
                                    3 : NSLocalizedString("HIGH", comment: "")]
    public static let RANGE_VALUES = [1 : NSLocalizedString("VLOW", comment: ""),
                                      2 : NSLocalizedString("LOW", comment: ""),
                                      3 : NSLocalizedString("MED", comment: ""),
                                      4 : NSLocalizedString("HIGH", comment: ""),
                                      5 : NSLocalizedString("VHIGH", comment: "")]
    public static let TIPO_REQ_INFO = 1
    public static let TIPO_REQ_NFUN = 2
    public static let TIPO_REQ_FUN = 3
    
    var window: UIWindow?
    
    // MARK: - Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
