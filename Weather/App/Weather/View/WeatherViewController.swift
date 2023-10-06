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
    
    private lazy var searchResultsController: UITableViewController = {
        let tableViewController = UITableViewController()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewController.tableView.register(CityListTVC.self, forCellReuseIdentifier: String(describing: CityListTVC.self))
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        
        tableViewController.tableView.allowsSelection = false
        tableViewController.tableView.showsVerticalScrollIndicator = false
        tableViewController.tableView.contentInsetAdjustmentBehavior = .never
        return tableViewController
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
        
        //Над ячейками сделаем серый цвет, чтобы гармонично смотрелось
        var frame = self.view.bounds
        frame.origin.y = -frame.size.height
        let whiteView = UIView(frame: frame)
        whiteView.backgroundColor = .systemGray6
        self.tableView.addSubview(whiteView)
    }
    
    func setupSearchController(){
        searchController = UISearchController(searchResultsController: searchResultsController)
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
        
        var frame = self.tableView.bounds
        frame.origin.y = -frame.size.height
        let grayView = UIView(frame: frame)
        grayView.backgroundColor = .white
        self.tableView.addSubview(grayView)
    }
    
    override func addConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

//MARK: - UITableViewDelegate&&UITableViewDataSource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView:
            return presenter.countTableObjects()
        case searchResultsController.tableView:
            return presenter.searchCountTableObjects()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableView:
            
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
            
        case searchResultsController.tableView:
            
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
}

//MARK: UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate&UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
//        changeViewBarButtons(isView: false)
//        topHistoryView.isHidden = false
//        if let text = searchBar.text, text == "" {
//            historyTableView.isHidden = false
//            tableView.isHidden = true
//        }
    }
    
    //Реализовывать историю поиска нет смысла, поскольку в задании этого требованя нет. Поиск будем производить только по нажатию поиска, а не по мере ввода текста, поскольку требуется отображать температуру рядом с городом(очень затратно, поскольку нет одного метода, и для каждого города придется делать запрос, а сервер имеет ограничения
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else {
            searchController.searchBar.endEditing(true)
            return
        }
        presenter.searchCityWheater(city: city)
        tableView.isHidden = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        if !searchController.isActive {
//            searchController.searchBar.endEditing(true)
//            tableView.isHidden = false
//        } else {
            tableView.isHidden = true
//        }
    }
}

// MARK: - Interface -
extension WeatherViewController: WeatherViewInterface {
    func reloadView() {
        tableView.reloadData()
    }
    
    func reloadSearch() {
        searchResultsController.tableView.reloadData()
    }
}
