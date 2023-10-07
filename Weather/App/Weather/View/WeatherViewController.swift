//
//  WeatherViewController.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit
import SnapKit

final class WeatherViewController: ViewController {

    // MARK: - Properties
    var presenter: (WeatherPresenterInterface&FindWeatherPresenterInterface)!
    
    //MARK: UI Properties
    var searchController: UISearchController!
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var searchResultsTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupNavigationBar()
        setupUI()
        
        addSubviews()
        addConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.viewDidLoad()
        
    }
    
    //MARK: Setup
    private func setupUI(){
        view.backgroundColor = .white
        searchResultsTable.isHidden = true
        
        //Над ячейками сделаем серый цвет, чтобы гармонично смотрелось
        var frame = self.view.bounds
        frame.origin.y = -frame.size.height
        let whiteView = UIView(frame: frame)
        whiteView.backgroundColor = .systemGray6
        self.tableView.addSubview(whiteView)
    }
    
    func setupSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.backgroundColor = .white
        searchController.navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .white
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.sizeToFit()
//        self.navigationController?.navigationBar.isTranslucent = true
        
        searchController.searchBar.placeholder = "Поиск городов"
        searchController.searchBar.delegate = self
    }
    
    //MARK: setupNavigationBar
    private func setupNavigationBar(){
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.white
    }
    
    //MARK: - Setup View -
    override func addSubviews() {
        super.addSubviews()
        
        self.view.addSubview(tableView)
        self.view.addSubview(searchResultsTable)
    }
    
    override func addConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        searchResultsTable.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

//MARK: - UITableViewDelegate&&UITableViewDataSource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return presenter.countTableObjects()
        case searchResultsTable:
            return presenter.searchCountTableObjects()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableView:
            
            var cell: TableViewCellConfigurable!
            
            let cellObj = presenter.tableCellObj(
                row: indexPath.row,
                section: indexPath.section)
            
            switch cellObj {
                
            case is WeatherEntity.DailyListCell:
                cell = tableView.cell(forClass: WeatherListTVC.self)
                
            case is WeatherEntity.Info:
                cell = tableView.cell(forClass: InfoWeatherTVC.self)
                
            default:
                return UITableViewCell()
            }
            
            cell.configure(with: cellObj)
            return cell
            
        case self.searchResultsTable:
            
            var cell: TableViewCellConfigurable!
            
            let cellObj = presenter.searchTableCellObj(
                row: indexPath.row,
                section: indexPath.section)
            
            switch cellObj {
                
            case is WeatherEntity.CityList:
                cell = tableView.cell(forClass: CityListTVC.self)
                
            default:
                return UITableViewCell()
            }
            
            cell.configure(with: cellObj)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.searchResultsTable:
            presenter.chooseSearchCity(indexPath.row)
            searchController.searchBar.endEditing(true)
            searchController.searchBar.text = ""
            searchResultsTable.isHidden = true
            self.tableView.isHidden = false
            
        default:
            break
        }
    }
}

//MARK: UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate&UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText != "" {
            tableView.isHidden = true
            searchResultsTable.isHidden = false
            delayDataEntry(text: searchText, action: #selector(delaySearch(with:)), afterDelay: 1.5)
        } else {
            searchResultsTable.isHidden = false
        }
    }
    
    @objc
    private func delaySearch(with text: String) {
        presenter.searchCityWheater(city: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultsTable.isHidden = false
        if let text = searchBar.text, text == "" {
            searchResultsTable.isHidden = false
            tableView.isHidden = true
        }
    }
    
    //Реализовывать историю поиска нет смысла, поскольку в задании этого требованя нет.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !searchController.isActive {
            searchController.searchBar.endEditing(true)
            tableView.isHidden = false
        } else {
            if let text = searchBar.text, text == "" {
                searchResultsTable.isHidden = true
            } else {
                searchResultsTable.isHidden = false
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            searchController.searchBar.endEditing(true)
            tableView.isHidden = false
            searchResultsTable.isHidden = true
        }
    }
}

// MARK: - Interface -
extension WeatherViewController: WeatherViewInterface {
    func reloadView() {
        tableView.reloadData()
    }
    
    func reloadSearch() {
        searchResultsTable.reloadData()
    }
}
