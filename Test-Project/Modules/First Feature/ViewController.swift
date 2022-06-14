//
//  ViewController.swift
//  Test-Project
//
//  Created by Muhammad Fahad Baig on 13/06/2022.
//

import UIKit

class ViewController: UIViewController {

    private var tableView = UITableView()
    private var spinner = UIActivityIndicatorView.init(style: .medium)
    
    var startIndex = 1 //This is the start index that we use to call the API
    var offset:Int = 30 //This is the end Index
    var isLoadingList: Bool = false
    var loadMore: Bool = true
    var completedCounter = 0 //for stopping animating spinning
    
    var dataSource: [NameMO] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        getData()
        
    }
    
    func setupUI() {
        //table view configurations
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //spinner loader
        spinner.frame = .init(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        tableView.tableFooterView = spinner
        tableView.tableHeaderView = UIView()
    }

    // to get data from API call for every index
    func getData() {
        isLoadingList = true
        guard self.offset <= 999 else {
            self.loadMore = false
            return
        }
        completedCounter = 0
        spinner.startAnimating()
        for i in startIndex...offset {
            APICallRepo.getName(byIndex: i) { [weak self] name, error in
                guard let self = self else { return }
                
                self.isLoadingList = false
                self.completedCounter += 1
                if error != nil {
                    print("Index \(i) error \(error?.localizedDescription ?? "")")
                    return
                }
                guard let model = name else { return }
                
                self.dataSource.append(model)
                
                if self.completedCounter == 30 {
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = (scrollView.contentOffset.y + scrollView.frame.size.height)
        if ((scrollViewHeight > scrollView.contentSize.height ) && !isLoadingList && loadMore) {
            isLoadingList = true
            startIndex += 30
            offset += 30
            self.getData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          cell.textLabel?.text = dataSource[indexPath.row].name
          return cell
    }
}

