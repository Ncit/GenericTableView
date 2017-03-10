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

class TableDataSource<CellBaseType: UITableViewCell>: NSObject, UITableViewDataSource where CellBaseType: DataInteractor
{
    private var tableView: UITableView!
    private var cellReuseIdentifier: String = String(describing: CellBaseType.self)

    private var dataSource: Array<DataObject>!
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }

    convenience init(tableView: UITableView,with items: Array<DataObject> = [])
    {
        self.init()
        self.tableView = tableView
        self.dataSource = items
        self.tableView.dataSource = self
        self.tableView.register(CellBaseType.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    override init()
    {
        super.init()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CellBaseType
        {
            let dataObject = self.dataSource[indexPath.row]
            cell.setup(dataObject: dataObject)
            return cell
        }
        return UITableViewCell()
    }
}