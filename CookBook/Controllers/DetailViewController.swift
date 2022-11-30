//
//  DetailViewController.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 30.11.2022.
//

import UIKit


final class DetailViewController: UIViewController {
    // MARK: - Properties
    private let ingredients = "cucumber 1 pc \n tomato 1 pc \n oil 1 tbsp" //for test

    // MARK: - UI elements
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        table.register(DetailScreenHeader.self, forHeaderFooterViewReuseIdentifier: "detailHeader")
        return table
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - UITableView Data Source/Delegate
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = ingredients
        
        return cell
    }
}

extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "detailHeader") as? DetailScreenHeader
        return header
    }
    
    // MARK: - Header height specified
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}
