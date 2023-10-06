//
//  Protocols.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

//MARK: CellObject
protocol CellObject {}

//MARK: TableViewCellConfigurable
protocol TableViewCellConfigurable: UITableViewCell {
    func configure(with object: CellObject)
}

//MARK: Network
protocol DataFetcherProtocol {
    func dataFetcher<T: Decodable>(urlString: String, response: @escaping (T?)-> ())
}

protocol GetDataService {
    func dataFetcher(urlString: String, comletion: @escaping (Data?, Error?) -> ())
}
