//
//  client.swift
//  dividend-analyser
//
//  Created by Sergiu-Stefan Tomescu on 17/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Client
{
    private var serverData : String = ""
    private let serverURL : String = "https://us-central1-dividend-analyser.cloudfunctions.net/app"
    private var dataFromAPI : Data?
    
    /**
     * access the main URL
     * extract and assign a default value for our data
     */
    init(){
        AF.request(self.serverURL, method: .get)
            .responseJSON {
                (response) in
                switch response.result {
                case .success:
                    self.dataFromAPI = response.data!
                case .failure(let error):
                    print(error)
                    return
                }
        }
    }
    
    /**
     * @param sufix is given by the user
     * @return a List of Strings containing data found at the requested URL
     */
    public func getDataFrom(_ sufix : String, _ number : Double, completion: @escaping ([String]) -> Void)
    {
        let newURL : String = serverURL + "/stocks/" + sufix + "?number=\(number)"
        
        print(newURL)
        
        var newData : Data?
        
        // requesting data from newURL
        AF.request(newURL, method: .get)
            .responseJSON {
                (response) in
                switch response.result {
                case .success:
                    //converting response from Data type to String type
                    newData = response.data
                    let jsonString = String(data: newData!, encoding: .utf8)
                    let jsonData = jsonString!.data(using: .utf8)
                    if let json = try? JSON(data: jsonData!)
                    {
                        var dataList : [String] = []
                        
                        for (_, subJson) : (String, JSON) in json {
                            dataList.append(subJson.stringValue)
                        }
                        
                        completion(dataList)
                    }
                case .failure(let error):
                    print("error = \(error)")
                    completion([])
                }
        }
    }
}
