//
//  BlackListViewController.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol BlackListViewInput: AnyObject {
    func setupInitialState()
    func setLoading(on: Bool)
    func reloadData()
}

final class BlackListViewController: UIViewController {
    var output: BlackListViewOutput?
    private let tableView = UITableView()

    private let activityIndicator: CustomActivityIndicator = {
        let view = CustomActivityIndicator()
        view.strokeColor = UIColor.mainApp()
        view.lineWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
}

extension BlackListViewController: BlackListViewInput {

    func setupInitialState() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        setupTableView()
        setupActivity()
    }
    
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.activityIndicator.startLoading() : self.activityIndicator.completeLoading(success: true)
            self.activityIndicator.isHidden = true
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

private extension BlackListViewController {
    
    struct Constants {
        static let heightRow: CGFloat = 50
        static let deleteButtonTitle = "Удалить"
        static let title = "Черный список"
        static let headerHeightEmpty: CGFloat = 250
        static let headerHeight: CGFloat = 0
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.fillSuperview()
        tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupActivity() {
        tableView.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height/2).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.constraint(equalTo: CGSize(width: 40, height: 40))
        activityIndicator.startLoading()
    }
    
    func infoLabel() -> UIView {
        let view = EmptyHeaderView()
        view.config(type: .emptyBlackList)
        return view
    }
}

extension BlackListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.id,
                                                 for: indexPath) as! ListViewCell
        guard let profile = output?.profile(at: indexPath) else { return cell }
        cell.config(with: profile)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: Constants.deleteButtonTitle) { [weak self] (_, _, _) in
            self?.output?.remove(at: indexPath)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.select(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return infoLabel()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let output = output else { return Constants.headerHeightEmpty }
        guard output.numberOfRows != 0 else { return Constants.headerHeightEmpty }
        return Constants.headerHeight
    }
}
