//
//  TextFieldsViewController.swift
//  Cookbook-ios
//
//  Created by Matias Schwalb on 29/01/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsViewController: GeneralViewController {

    @IBOutlet weak var textFieldsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        title = "Text Fields"
    }
    
    private func setupTableView() {
        textFieldsTableView.delegate = self
        textFieldsTableView.dataSource = self
        textFieldsTableView.register(UINib.init(nibName: "TextFieldsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldsTableViewCell")
    }
}

extension TextFieldsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = textFieldsTableView.dequeueReusableCell(withIdentifier: "TextFieldsTableViewCell") as? TextFieldsTableViewCell
        return cell ?? UITableViewCell()
    }
    
    
}
