//
//  AccountSettingsViewController.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import DesignSystem
import UIKit

protocol AccountSettingsViewInput: AnyObject {
    func setupInitialState(stringFactory: AccountSettingsStringFactoryProtocol)
    func setLoading(on: Bool)
}

final class AccountSettingsViewController: UIViewController {
    var output: AccountSettingsViewOutput?
    private let titleLabel = UILabel()
    private let editInfoButton = ButtonsFactory.whiteSettingsButton
    private let blackListButton = ButtonsFactory.whiteSettingsButton
    private let removeProfileButton = ButtonsFactory.whiteLoadButton
    private let exitButton = ButtonsFactory.whiteSettingsButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

private extension AccountSettingsViewController {
    
    func setupViews(stringFactory: AccountSettingsStringFactoryProtocol) {
        navigationItem.title = stringFactory.title
        tabBarController?.tabBar.isHidden = true
        titleLabel.text = stringFactory.title
        titleLabel.font = UIFont.avenir26()
        editInfoButton.setTitle(stringFactory.editButtonTitle, for: .normal)
        blackListButton.setTitle(stringFactory.blackListTitle, for: .normal)
        removeProfileButton.setTitle(stringFactory.removeTitle, for: .normal)
        exitButton.setTitle(stringFactory.logoutTitle, for: .normal)
        view.backgroundColor = .systemGray6
        view.addSubview(titleLabel)
        view.addSubview(editInfoButton)
        view.addSubview(blackListButton)
        view.addSubview(removeProfileButton)
        view.addSubview(exitButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        editInfoButton.translatesAutoresizingMaskIntoConstraints = false
        blackListButton.translatesAutoresizingMaskIntoConstraints = false
        removeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupActions() {
        editInfoButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        blackListButton.addTarget(self, action: #selector(showBlackListTapped), for: .touchUpInside)
        removeProfileButton.addTarget(self, action: #selector(removeProfileTapped), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        editInfoButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        editInfoButton.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -50).isActive = true
        editInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        blackListButton.topAnchor.constraint(equalTo: editInfoButton.bottomAnchor, constant: 30).isActive = true
        blackListButton.widthAnchor.constraint(equalTo: editInfoButton.widthAnchor).isActive = true
        blackListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        removeProfileButton.topAnchor.constraint(equalTo: blackListButton.bottomAnchor, constant: 30).isActive = true
        removeProfileButton.widthAnchor.constraint(equalTo: editInfoButton.widthAnchor).isActive = true
        removeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        exitButton.widthAnchor.constraint(equalTo: editInfoButton.widthAnchor).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    @objc func editProfileTapped() {
        output?.editProfileAction()
    }
    
    @objc func showBlackListTapped() {
        output?.blackListAction()
    }
    
    @objc func removeProfileTapped() {
        output?.removeProfileAction()
    }
    
    @objc func exitTapped() {
        output?.logout()
    }
}

extension AccountSettingsViewController: AccountSettingsViewInput {
    func setupInitialState(stringFactory: AccountSettingsStringFactoryProtocol) {
        setupViews(stringFactory: stringFactory)
        setupConstraints()
        setupActions()
    }
    
    func setLoading(on: Bool) {
        DispatchQueue.main.async {
            on ? self.removeProfileButton.loading() : self.removeProfileButton.stop()
        }
    }
}
