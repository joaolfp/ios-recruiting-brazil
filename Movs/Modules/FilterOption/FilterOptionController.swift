//
//  FilterOptionController.swift
//  Movs
//
//  Created by Joao Lucas on 15/10/20.
//

import UIKit

protocol FilterOptionDelegate: class {
    func getItemsSelected(items: FilterOptionEntity)
}

class FilterOptionController: UITableViewController {
    
    private var yearSelected = ""
    private var genreSelected = ""
    
    weak var delegate: FilterOptionDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterOption")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Filter option"
    }
    
    @objc func btnApply() {
        let items = FilterOptionEntity(year: yearSelected, genre: genreSelected)
        delegate.getItemsSelected(items: items)
        navigationController?.popViewController(animated: true)
    }
}

extension FilterOptionController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOption", for: indexPath)
        
        switch indexPath.row {
        case 0:
            if yearSelected.isEmpty {
                cell.textLabel?.text = "Year"
            } else {
                cell.textLabel?.text = "Year: \(yearSelected)"
            }
            
            cell.accessoryType = .disclosureIndicator
        case 1:
            if genreSelected.isEmpty {
                cell.textLabel?.text = "Genre"
            } else {
                cell.textLabel?.text = "Genre: \(genreSelected)"
            }
            
            cell.accessoryType = .disclosureIndicator
        default:
            fatalError()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller = FilterYearController()
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            
        case 1:
            let controller = FilterGenreController()
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            print("Error index path")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(btnApply), for: .touchUpInside)
        button.heightAnchor(equalTo: 50)
        return button
    }
}

extension FilterOptionController: FilterByYearDelegate, FilterByGenreDelegate {
    func getGenreSelected(genre: String) {
        self.genreSelected = genre
        tableView.reloadData()
    }
    
    func getYearSelected(year: String) {
        self.yearSelected = year
        tableView.reloadData()
    }
}
