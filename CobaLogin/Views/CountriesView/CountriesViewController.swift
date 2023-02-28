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
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var countriesVM = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        refreshControl.beginRefreshing()
        fetchCountryList()
    }
    
    func setup() {
        title = "Country List"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        errorView.isHidden = true
        
        registerCountriesCell()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_ :)), for: .valueChanged)
        
        self.spinner.startAnimating()
    }
    
    func registerCountriesCell() {
        let nib = UINib(nibName: "CountriesViewCell", bundle: Bundle(for: CountriesViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "countriesCellId")
    }
    
    @objc func refresh(_ sender: Any) {
        fetchCountryList()
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        self.spinner.startAnimating()
        fetchCountryList()
    }
    
    
    func fetchCountryList() {
        countriesVM.fetch { [weak self] (error) in
            self?.refreshControl.endRefreshing()
            self?.spinner.stopAnimating()
            self?.spinner.hidesWhenStopped = true
            self?.tableView.reloadData()
            
            if let error = error {
                self?.tableView.isHidden = true
                self?.errorView.isHidden = false
            
                print(error.localizedDescription)
                
            } else {
                self?.tableView.isHidden = false
                self?.errorView.isHidden = true
                
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countriesVM.numberOrRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countriesCellId", for: indexPath) as! CountriesViewCell
    
        cell.countryName.text = countriesVM.countryName(at: index)
        cell.countryImageView.kf.setImage(with: URL(string: countriesVM.countryFlag(at: index)!))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nib = DetailCountryViewController(nibName: "DetailCountry", bundle: nil)
        nib.selectedCountry = countriesVM.countries[indexPath.row]
        
        self.navigationController?.pushViewController(nib, animated: true)
    }
}
