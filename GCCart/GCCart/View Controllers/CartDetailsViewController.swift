//
//  ViewController.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import UIKit

class CartDetailsViewController: UIViewController {
    
    @IBOutlet weak var loadingStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private var collectionData: [OrderItemViewModel]?
    private var filteredCollectionData: [OrderItemViewModel]?
    private var isSearching = false
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCollectionData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if collectionData == nil {
            showLoader()
        }
        
    }
    
    //MARK: - UI Methods
    func setupNavigatoinData(cartInfoData: CartInfoData) {
        
        let title = "Total: \(cartInfoData.total.formattedPrice())"
        


        
        if #available(iOS 11.0, *) {
            navigationItem.title = title
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchResultsUpdater = self
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.prompt = "Cart " + title
            let searchBar = UISearchBar()
            searchBar.delegate = self
            navigationItem.titleView = searchBar
        }
    }
    
    func showLoader(){
        self.loadingStackView.alpha = 0.0
        UIView.animate(withDuration: 0.33) {
            self.loadingStackView.alpha = 1.0
        }
    }
    
    func hideLoader() {
        self.loadingStackView.alpha = 1.0
        UIView.animate(withDuration: 0.33, animations: {
            self.loadingStackView.alpha = 0.0
        })
    }
    
    
    //MARK: - Custom Methods
    func fetchCollectionData() {
        NetworkService.sharedService.sendRequestWithService(api: API.getCartItems(), success: { [weak self] (cartInfo: CartInfoData) in
            cartInfo.orderItemsInformation.forEach({print($0.product.name)})
            self?.hideLoader()
            self?.setupNavigatoinData(cartInfoData: cartInfo)
            self?.collectionData = cartInfo.orderItemsInformation.map({ return OrderItemViewModel(orderItem: $0)})
            self?.tableView.reloadData()
            
            
            }, failure: { [weak self] (error) in
                self?.hideLoader()
                print(error)
        })
    }
}

//MARK: -
extension CartDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    /** Data Source */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCollectionData?.count ?? 0 : self.collectionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let orderItem = isSearching ? filteredCollectionData![indexPath.row] : collectionData![indexPath.row]
        
        cell.bindData(orderItem: orderItem)
        
        return cell
    }
    
    /** Appearance */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.33, delay: 0, animations: {
            cell.transform = .identity
            cell.alpha = 1.0
        })
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
                cell.contentView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
}

extension CartDetailsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterCollectionData(by: searchController.searchBar.text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCollectionData(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterCollectionData(by text: String?) {
        if let searchText = text, !searchText.isEmpty {
            self.isSearching = true
            self.filteredCollectionData = collectionData?.filter({ return $0.name.lowercased().contains(searchText.lowercased())})
            self.tableView.reloadData()
        }else{
            self.isSearching = false
            self.filteredCollectionData?.removeAll()
            self.tableView.reloadData()
        }
    }
    
}
