//
//  InfoViewController.swift
//  Navigation
//
//  Created by Наталья Босякова on 23.08.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    var residents: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var button: CustomButton = {
        
        let button = CustomButton(
            title: "Show alert",
            backgroundColor: UIColor(named: "ButtonColor")!,
            tapAction: showAlert)

        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
        
    }()
    
    private lazy var titleOfModel: UILabel = {
        
        let label = UILabel()
        label.text = "title: "
        NetworkService.getTitle(for: AppConfiguration.url1) {
            title in
            DispatchQueue.main.async {
                label.text = label.text! + title
            }
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
        
    private lazy var orbitalPeriodOfModel: UILabel = {
       let label = UILabel()
        label.text = "orbital period: "
        NetworkService.getOrbitalPeriod(for: AppConfiguration.url3) {
            period in
            DispatchQueue.main.async {
                label.text = label.text! + period
            }
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemGray3
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        getResidents()
        addSubviews()
        setConstraints()        
    }
    
    private func getResidents() {
        NetworkService.getResidents(for: AppConfiguration.url3) {
            resident in
            self.residents.append(resident)
            print("resident \(self.residents.count): \(resident)")
        }
    }
    
    private func addSubviews() {
        view.addSubview(button)
        view.addSubview(titleOfModel)
        view.addSubview(orbitalPeriodOfModel)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleOfModel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleOfModel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8),
            orbitalPeriodOfModel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitalPeriodOfModel.topAnchor.constraint(equalTo: titleOfModel.bottomAnchor, constant: 8),
            
            self.tableView.topAnchor.constraint(equalTo: orbitalPeriodOfModel.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
       ])
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "just for test",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
           print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            print("OK")
        }))
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray3
        cell.textLabel?.text = self.residents[indexPath.row]
        return cell
    }

}
