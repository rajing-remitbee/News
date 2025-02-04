//
//  APICaller.swift
//  News
//
//  Created by Rajin Gangadharan on 03/02/25.
//

import Foundation

//APICaller class for fetching data from API
final class APICaller {
    
    //Shared object to access the APICaller class's object
    static let shared = APICaller()
    
    //Struct to hold static value
    struct Constants {
        static let topHeadLinesURL = URL(
            string: API_URL
        )
    }
    
    //Private initializer
    private init() {}
    
    //Fetch top stories using ghe backend details.
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        //Ensure the validity of the URL
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        //URLSession to fetch the data from the backend
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            //If any error the code will fail
            if let error = error {
                completion(.failure(error))
                //If success the code will following execution
            } else if let data = data {
                do {
                    //Decode the response into APIMode
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    //Detect and store the data
                    completion(.success(result.articles))
                } catch {
                    //Show error message it false
                    completion(.failure(error))
                }
            }
            
        }
        //Start  with delect button
        task.resume()
    }
}
