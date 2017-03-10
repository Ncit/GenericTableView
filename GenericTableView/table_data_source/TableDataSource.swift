//
// Created by Nikita Feshchun on 10.03.17.
// Copyright (c) 2017 Ncit. All rights reserved.
//

import Foundation
import UIKit

protocol DataObject: class
{
    var info: Dictionary<String, Any> { get }
}

protocol DataInteractor: class
{
    func setup(dataObject: DataObject)
}

class TableDataSource: NSObject, UITableViewDataSource
{
    private var tableView: UITableView!

    private var dataSource: Array<DataObject>!
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }

    private var supportTypes: Dictionary<String,AnyClass> = [:]
    {
        didSet
        {
            for (_,value) in supportTypes
            {
                self.tableView.register(value, forCellReuseIdentifier: String(describing: value))
            }
        }
    }

    convenience init(tableView: UITableView,with items: Array<DataObject> = [], supportTypes: Dictionary<String,AnyClass>)
    {
        self.init()
        self.tableView = tableView
        setup(supportTypes: supportTypes)
        self.dataSource = items
        self.tableView.dataSource = self
    }

    override init()
    {
        super.init()
    }

    private func setup(supportTypes: Dictionary<String,AnyClass>)
    {
        self.supportTypes = supportTypes
    }
    
    func updateDataSource(with dataSource: Array<DataObject>)
    {
        self.dataSource = dataSource
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dataObject = self.dataSource[indexPath.row]
        if let cellType = supportTypes[String(describing: type(of: dataObject))]
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath)

            if let dataInteractor = cell as? DataInteractor
            {
                dataInteractor.setup(dataObject: dataObject)
            }

            return cell
        }
       return UITableViewCell()
    }
}
