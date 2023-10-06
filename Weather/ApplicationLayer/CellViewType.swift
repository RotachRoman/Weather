//
//  CellViewType.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

class CellViewType: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
    }
    
    init(){
        super.init(style: .default, reuseIdentifier: String(describing: CellViewType.self))
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {}

    func addConstraints() {}
}
