//
//  AccountServicesManager.swift
//  Caseys
//
//  Created by Bolton, Zach (US - Seattle) on 4/11/19.
//  Copyright © 2019 Casey's General Stores, Inc. All rights reserved.
//

import Foundation
import Alamofire

extension ServicesManager {
	
    @discardableResult static func getMyAccountInforamtion(completion: @escaping (Result<GitResponseModel>) -> Void) -> Request? {
        let defaults = UserDefaults.standard
        
        //Set this key in User default constants
        if defaults.bool(forKey: "LocalTestData") {
            loadLocal(assetName: "personalInformation", resultType: GitResponseModel.self, completion: completion)
            return nil
        }
        else {
            //TODO:- Service not available
            let error = ServiceError.serviceFailure(reason: "Service not available, try with test data on.")
            completion(Result.failure(error))
            return nil
        }
    }
    
    @discardableResult static func updateCustomerInformation(email: String,
                                                             firstName: String,
                                                             lastName: String,
                                                             phoneNumber: String,
                                                             completion: @escaping (Result<GitResponseModel>) -> Void) -> Request? {
        //Set this key in User default constants
        if UserDefaults.standard.bool(forKey: "Contant") {
            loadLocal(assetName: "personalInformation", resultType: GitResponseModel.self, completion: completion)
            return nil
        }
        else {
            let urlString = url(serviceType: MicroServiceType.user,
                                path: "" + email,
                                queryItems: [])
            //TODO: - to be confirm the parameters to pass.
            let parameters = [
                "firstName": firstName,
                "lastName": lastName,
                "phoneNumber": phoneNumber
                ] as [String: Any]
            
            return sendRequest(urlString: urlString, parameters: parameters, method: .put, encoding: JSONEncoding.default, completion: completion)
        }
        
    }
    
    // This is to demostrate network request and data parsing with Json Deconder.
    @discardableResult static func getGithubRepoList(completion: @escaping (Result<[GitResponseModel]>) -> Void) -> Request? {
            // Unable to call github api because of new security issue, which required to install some certificate.
            //Showing it with local test data.
            // https://github.com/Alamofire/Alamofire/issues/2402
           if 1 == 1 {
               loadLocal(assetName: "gitReposResponse", resultType: [GitResponseModel].self, completion: completion)
               return nil
           }
           else {
               let urlString = "https://api.github.com/repositories"
               
               return sendRequest(urlString: urlString, parameters: nil, method: .get, encoding: JSONEncoding.default, completion: completion)
           }
           
       }
}
