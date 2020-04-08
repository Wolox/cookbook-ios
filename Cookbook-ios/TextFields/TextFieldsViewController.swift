//
//  TextFieldsViewController.swift
//  Cookbook-ios
//
//  Created by Matias David Schwalb on 08/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsViewController: GeneralViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ViewNames.textFieldCell, bundle: nil), forCellReuseIdentifier: "cell")
    }


}

extension TextFieldsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
