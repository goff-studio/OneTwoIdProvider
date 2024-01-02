import UIKit
import Foundation
import Alamofire

public struct OneTwoIdProvider {
    static internal let baseUrl: String = "https://verifier-wrapper-development.prd.int.1-2-id.com"
    
    public init() {
    }
    private static var isUIKitAvailable: Bool {
        #if os(iOS) || os(tvOS) || os(watchOS)
            return true
        #else
            return false
        #endif
    }
    
    private static var sharedApplication: UIApplication? {
        return isUIKitAvailable ? UIApplication.shared : nil
    }
    
    // Check if com.onetwoid.mobile is installed and return a boolean
    public static func is12iDAppInstalled(appBundle: String = "com.onetwoid.mobile") -> Bool {
        guard let appUrl = URL(string: "\(appBundle)://"), let application = sharedApplication else {
            return false
        }
        return application.canOpenURL(appUrl)
    }
    
    // Open com.onetwoid.mobile if installed
    public static func open12iDApp(appBundle: String = "com.onetwoid.mobile") {
        guard is12iDAppInstalled(appBundle: appBundle) else {
            print("12iD app is not installed")
            return
        }
        guard let appUrl = URL(string: "\(appBundle)://"), let application = sharedApplication else {
            return
        }
        application.open(appUrl, options: [:], completionHandler: nil)
    }
    // check to see is com.onetwoid.mobile installed or not and return a boolean
    public static func is12iDAppInstalled(appScheme: String = "com.onetwoid.mobile") -> Bool {
        let appUrl = URL(string: "\(appScheme)://")!
        let application = UIApplication.shared
        return application.canOpenURL(appUrl)
    }
    
    // opens 12iD app if installed
    public static func open12iDApp(appScheme: String = "com.onetwoid.mobile") {
        if (!is12iDAppInstalled(appScheme: appScheme)) {
            print("12iD app is not installed")
            return
        }
        let appUrl = URL(string: "\(appScheme)://")!
        let application = UIApplication.shared
        application.open(appUrl, options: [:], completionHandler: nil)
    }
    
    // opens 12iD app if installed and send user info to the app. user info is a json string
    public static func registerExistingCustomer(accessId: String, secretKey: String, userInfo: String, appScheme: String = "com.onetwoid.mobile") {
        if (!is12iDAppInstalled(appScheme: appScheme)) {
            print("12iD app is not installed")
            return
        }
        let appUrl = URL(string: "\(appScheme)://?userInfo=\(userInfo)")!
        let application = UIApplication.shared
        application.open(appUrl, options: [:], completionHandler: nil)
    }
    
    // This function receives accessId secretKey, operation and type and returns a qrCodeString
    public static func getToken(accessId: String, secretKey: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: baseUrl) else {
            
            return
        }
        
        let parameters = ["accessId": accessId, "secretKey": secretKey]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = value as! [String: Any]
                let token = json["token"] as! String
                completion(token)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func makeGetRequest(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        AF.request(url)
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            completion(.success(jsonString))
                        } else {
                            completion(.failure(NSError(domain: "Unable to convert data to JSON string", code: 0, userInfo:
                                                            nil)))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

