//
//  InfoWeatherTVC.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit
import SnapKit

//MARK: Ячейка отображения информации о погоде(верхняя)
final class InfoWeatherTVC: CellViewType, TableViewCellConfigurable {
    
    //MARK: - UI elements
    private var cityLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.141, blue: 0.22, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.141, blue: 0.22, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var humidityLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0.686, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var windLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0.686, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
    
    //MARK: Configure
    func configure(with object: CellObject) {
        guard let obj = object as? WeatherEntity.Info else { return }
        
        setupData(
            city: obj.city,
            temp: obj.temp,
            humidity: obj.humidity,
            wind: obj.wind)
        
        addSubviews()
        addConstraints()
        
        backgroundColor = .systemGray6
    }
    
    //MARK: - init -
    private func setupData(city: String, temp: String, humidity: String, wind: String){
        cityLbl.text = city
        tempLbl.text = temp 
        humidityLbl.text = humidity
        windLbl.text = wind
    }
    
    //MARK: - Setup View -
    override func addSubviews() {
        super.addSubviews()
        [cityLbl, tempLbl, humidityLbl, windLbl].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func addConstraints() {
        super.addConstraints()
        
        cityLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(24)
        }
        
        tempLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(cityLbl.snp.bottom).inset(-14)
        }
        
        humidityLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(tempLbl.snp.bottom).inset(-12)
        }
        
        windLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(humidityLbl.snp.bottom).inset(-12)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}
