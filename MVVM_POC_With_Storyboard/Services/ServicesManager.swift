//
//  ServiceManager.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 09/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import Foundation
import Alamofire

public enum ServiceError: Error {
    case serviceFailure(reason: String)
    case connectivityError
    case unknownError
}

public enum Environment: String, CaseIterable {
    
    case qa = "QA"
    case dev = "DEV"
    
    var baseURL: String {
        switch self {
        case .qa, .dev : return ""
        }
    }
    
    var imageBaseURL: String {
        switch self {
        case .qa, .dev : return ""
        }
    }
    
    /*
    var clientId: String {
        switch self {
        case .qa, .dev : return ""
        }
    }
    
    var clientSecret: String {
        switch self {
        case .qa, .dev : return ""
        }
    }
 */
    
    var versionHeader: String? {
        switch self {
        case .qa:
            return ""
        case .dev:
            return ""
        }
    }
}

struct Constants {
    static let useLocalTestDataKey = "UseLocalTestData"
    static let useDemoModeKey = "UseDemoModeKey"
    static let useSimulatedCurrentLocation = "useSimulateCurrentLocation"
    static let useSimulatedAddress = "useSimulateAddress"
    static let simulatedCurrentLocation =  "SimulatedCurrentLocation"
    static let environmentKey = "ServicesEnvironment"
    static let loggedInUserToken = "loggedInUserToken"
    static let loggedInUserUID = "loggedInUserUID"
    static let loggedInUserUIDSignature = "loggedInUserUIDSignature"
    static let loggedInUserSignatureTimestamp = "loggedInUserSignatureTimestamp"
    static let hideUIElements = "HideUIElements"
    static let appInstallUUID = "appInstallUUID"
}

enum MicroServiceType: String {
    case user = "user"
    case activities = "activities"
    case survey = "survey"
}

class ServicesManager {
    
    private static let alamoFireManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        
        var timeout: TimeInterval = 15
        
        #if DEBUG
        timeout = 60
        #endif
        
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    public static var environment: Environment {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.environmentKey)
        }
        get {
            #if DEBUG
            if let environmentString = UserDefaults.standard.string(forKey: Constants.environmentKey) {
                return Environment(rawValue: environmentString) ?? .qa
            }
            else {
                return .qa
            }
            #elseif UAT
            return ""// Setup later once UAT is ready
            #endif
        }
    }
    
    public static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? true
    }
    
    // Use this constructor if we are consuming microervices.
    public static func url(serviceType: MicroServiceType,
                           path: String,
                           queryItems: [URLQueryItem]) -> String {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = environment.baseURL
        components.path = "/" + path
        // Need to re-visit it once service is ready.
        components.queryItems = [URLQueryItem(name: "channelType", value: "MOBILE")] + queryItems
        
        return components.url?.absoluteString ?? ""
    }
    
    static func sendRequest<T: Decodable>(urlString: String,
                                          parameters: [String: Any]?,
                                          method: HTTPMethod,
                                          encoding: ParameterEncoding = URLEncoding.queryString,
                                          requiresAuth: Bool = true,
                                          completion: @escaping (Result<T>) -> Void) -> Request? {
        
        let request = alamoFireManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: defaultHeaders(requiresAuth: requiresAuth))
        NSLog("Sending request to \(request.request?.url?.absoluteString ?? "")")
        
        request.validate()
        
        if !ServicesManager.isConnectedToInternet() {
            completion(.failure(ServiceError.connectivityError))
            return request
        }
        
        request.responseJSON { response in
            if let code = response.response?.statusCode {
                NSLog("  Received response: \(code) \(HTTPURLResponse.localizedString(forStatusCode: code))")
            }
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                do {
                    if let data = response.data {
                        let decodedResponse: T = try decoder.decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    }
                    else {
                        let error = ServiceError.serviceFailure(reason: "Missing response data")
                        NSLog("Error: \(error)")
                        completion(.failure(error))
                    }
                }
                catch let error {
                    //Revisit it to apply error parsing
                    NSLog("Error: \(error)")
                    self.logRawResponseData(response.data)
                    completion(.failure(error))
                }
            case .failure(let error):
                debugPrint(request)
                self.logRawResponseData(response.data)
                NSLog("Error: \(error)")
                completion(.failure(error))
            }
        }
        return request
    }
    
    static func loadLocal<T: Decodable>(assetName: String, resultType: T.Type, completion: @escaping (Result<T>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let asset = NSDataAsset(name: assetName, bundle: Bundle.main) {
                NSLog("Loading saved response for: \(asset.name), type: \(asset.typeIdentifier)")
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: asset.data)
                    sleep(1)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                }
                catch let error {
                    NSLog("Error: \(error)")
                    self.logRawResponseData(asset.data)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(ServiceError.unknownError))
                }
            }
        }
    }
    
    private static func logRawResponseData(_ data: Data?) {
        if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
            // Use print, as we don't want additional output of NSLog or debugPrint
            print("********** Response Data **********")
            print(utf8Text) // original JSON data as UTF8 string
        }
    }
    
    private static func defaultHeaders(requiresAuth: Bool) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
//            "client_id": "",
//            "client_secret": "",
        ]
        
        if let versionHeader = environment.versionHeader {
            headers["version"] = versionHeader
        }
        
        /* Enable it if we have auth required.
        if requiresAuth, let authToken = AuthoToken.getToken() {
            headers["Authorization"] = "Bearer " + authToken
        }
 */
        return headers
    }
}
