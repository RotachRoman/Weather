//
//  DataFetcher.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

class DataFetcher: DataFetcherProtocol {
    
    //MARK: Properties
    private var getDataService: GetDataService
    
    //MARK: Init
    init(getDataService: GetDataService) {
        self.getDataService = getDataService
    }
    
    //MARK: dataFetcher
    func dataFetcher<T: Decodable>(urlString: String, response: @escaping (T?)-> ()){
        getDataService.dataFetcher(urlString: urlString) { (data, error) in
            if let error = error {
                print(error)
                print("Error received requesting data: \(error.localizedDescription)")
                return
            }
            let decoder = self.decoderJSON(type: T.self, data: data)
            response(decoder)
        }
    }
    
    private func decoderJSON<T: Decodable>(type: T.Type ,data: Data?) -> T? {
        let decoder = JSONDecoder()

        guard let data = data else { return nil }
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch let error as NSError {
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }
}
