//
//  ViewController.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import UIKit

class AcronymSearchViewController: UIViewController {

    lazy var inputTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search Acronym (Ex. DOD)"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        return textField
    }()
    
    lazy var tableview: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.backgroundColor = .white
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Basic Cell")
        return table
    }()
    
    var viewModel: AcronymViewModelType
    
    init(viewModel: AcronymViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpBinding()
    }

    private func setUpUI() {
        self.title = "What Is This Acronym?"
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.inputTextField)
        self.view.addSubview(self.tableview)
        
        self.inputTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.inputTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.inputTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.inputTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.tableview.topAnchor.constraint(equalTo: self.inputTextField.bottomAnchor, constant: 8).isActive = true
        self.tableview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.tableview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    private func setUpBinding() {
        self.viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.tableview.reloadData()
            }
        } failureBinding: { [weak self] error in
            // Update with Error information if needed to user
            print(error)
            if let err = error as? NetworkError, err == NetworkError.emptyResult {
                self?.presentAlert(with: "That search returned no results, try again")
            }
        }

    }

}

extension AcronymSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Basic Cell", for: indexPath)
        cell.textLabel?.text = self.viewModel.fullForm(for: indexPath.row)
        return cell
    }

}

// TextField Logic
extension AcronymSearchViewController {
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        guard let acronym = sender.text else { return }
        self.viewModel.searchAcronym(acronym: acronym)
    }
    
}
