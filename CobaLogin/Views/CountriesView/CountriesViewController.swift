//
//  CoutriesViewController.swift
//  CobaLogin
//
//  Created by developer on 26/01/23.
//

import UIKit
//import RxSwift
//import RxCocoa
import Kingfisher


class CountriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    
    var countriesVM = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl.beginRefreshing()
        fetchCountryList()
    }
    
    func setup() {
        title = "Country List"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        registerCountriesCell()
        registerErrorCountriesCell()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_ :)), for: .valueChanged)
    }
    
    func registerCountriesCell() {
        let nib = UINib(nibName: "CountriesViewCell", bundle: Bundle(for: CountriesViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "countriesCellId")
    }
    
    func registerErrorCountriesCell() {
        let nib = UINib(nibName: "ErrorCountriesViewCell", bundle: Bundle(for: ErrorCountriesViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "errorCellId")
    }
    
    @objc func refresh(_ sender: Any) {
        fetchCountryList()
    }
    
    func fetchCountryList() {
        countriesVM.fetch { [weak self] (error) in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.countriesVM.countries.sort(by: {$0.name?.common ?? "" < $1.name?.common ?? ""})
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
//    func fetchCountryList() {
//        countriesVM.fetch { [weak self] in
//            self?.tableView.reloadData()
//            self?.countriesVM.countries.sort(by: {$0.name?.common ?? "" < $1.name?.common ?? ""})
//            self?.refreshControl.endRefreshing()
//        }
//    }
}




// MARK: - UITableViewDataSource
extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return countriesVM.numberOrRows()
        
        if countriesVM.numberOrRows() != 0 {
            return countriesVM.numberOrRows()
        } else {
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesCellId", for: indexPath) as! CountriesViewCell
//    
//        cell.countryName.text = countriesVM.countryName(at: index)
//        cell.countryImageView.kf.setImage(with: URL(string: countriesVM.countryFlag(at: index)!))
//        
//        return cell
        
        if countriesVM.numberOrRows() != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countriesCellId", for: indexPath) as! CountriesViewCell
        
            cell.countryName.text = countriesVM.countryName(at: index)
            cell.countryImageView.kf.setImage(with: URL(string: countriesVM.countryFlag(at: index)!))
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "errorCellId", for: indexPath) as! ErrorCountriesViewCell
        
            cell.errorLabel.text = "Something went wrong..."
            cell.reloadButton.addTarget(self, action: #selector(self.refresh(_ :)), for: .touchUpInside)
            
            return cell
            
        }
    }
}

// MARK: - UITableViewDelegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if countriesVM.numberOrRows() != 0 {
            let nib = DetailCountryViewController(nibName: "DetailCountry", bundle: nil)
            nib.selectedCountry = countriesVM.countries[indexPath.row]
            
            self.navigationController?.pushViewController(nib, animated: true)
        } else {
            
            return
            
        }
    }
}
