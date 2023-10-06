//
//  CityListTVC.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import UIKit

//MARK: Ячейка отображения информации о погоде(верхняя)
final class CityListTVC: CellViewType, TableViewCellConfigurable {
    
    //MARK: - UI elements
    private var cityLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.141, blue: 0.22, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0, green: 0.686, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Configure
    func configure(with object: CellObject) {
        guard let obj = object as? WeatherEntity.CityList else { return }
        setupData(temp: obj.temp, city: obj.city)
        addSubviews()
        addConstraints()
    }
    
    //MARK: - init -
    private func setupData(temp: String, city: String){
        tempLbl.text = temp
        cityLbl.text = city
    }
    
    //MARK: - Setup View -
    override func addSubviews() {
        super.addSubviews()
        [tempLbl, cityLbl].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func addConstraints() {
        super.addConstraints()
        cityLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(24)
        }
        
        tempLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(cityLbl).inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
