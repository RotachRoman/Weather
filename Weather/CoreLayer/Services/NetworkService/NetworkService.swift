//
//  NetworkService.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

class NetworkService: GetDataService {
    //MARK: dataFetcher
    func dataFetcher(urlString: String, comletion: @escaping (Data?, Error?) -> ()){
        guard let url = URL(string: urlString) else {
            print("Error: adress not url")
            return
        }
        let request = URLRequest(url: url)
        createDataTask(request: request, completion: comletion)
    }
    
    private func createDataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> ()){
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}
