//
//  WeatherListTVC.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit
import SnapKit

//MARK: Ячейка отображения даты на следущие пару дней
final class WeatherListTVC: CellViewType, TableViewCellConfigurable {
    
    //MARK: - UI elements
    private var dateLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.141, blue: 0.22, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
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
        guard let obj = object as? WeatherEntity.DailyListCell else { return }
        setupData(temp: obj.temp, date: obj.date)
        backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    //MARK: - init -
    private func setupData(temp: String, date: String){
        tempLbl.text = temp
        dateLbl.text = date
    }
    
    //MARK: - Setup View -
    override func addSubviews() {
        super.addSubviews()
        [tempLbl, dateLbl].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func addConstraints() {
        super.addConstraints()
        dateLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(24)
        }
        
        tempLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(dateLbl).inset(24)
            make.trailing.equalToSuperview().inset(24)
        }
    }
}
