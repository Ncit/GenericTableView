//
// Created by Nikita Feshchun on 10.03.17.
// Copyright (c) 2017 Ncit. All rights reserved.
//

import Foundation
import UIKit

struct TableAnchors
{
    var topConstraint: NSLayoutConstraint
    var bottomConstraint: NSLayoutConstraint
    var leadingConstraint: NSLayoutConstraint
    var trailingConstraint: NSLayoutConstraint
}

class GenericTableVC<CellBaseType: UITableViewCell>: UIViewController, UITableViewDelegate where CellBaseType: DataInteractor
{
    //MARK: - table view

    let tableView: UITableView = UITableView()
    var dataSource: TableDataSource<CellBaseType>!

    //MARK: - table anchors

    private(set) var tableAnchors: TableAnchors!

    //MARK: - life cycle

    static func build(with dataSource: Array<DataObject>) -> GenericTableVC
    {
        let genericTableVC: GenericTableVC = GenericTableVC()
        genericTableVC.updateDataSource(with: dataSource)
        return genericTableVC
    }

    convenience init()
    {
        self.init(nibName: nil, bundle: nil)
        configureTableViewLayout()
        self.dataSource = TableDataSource<CellBaseType>(tableView: self.tableView)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI

    private func configureTableViewLayout()
    {
        self.view.addSubview(tableView)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = buildConstraint(for: .top)
        let bottomConstraint = buildConstraint(for: .bottom)
        let leadingConstraint = buildConstraint(for: .leading)
        let trailingConstraint = buildConstraint(for: .trailing)

        tableAnchors = TableAnchors(
                topConstraint: topConstraint,
                bottomConstraint: bottomConstraint,
                leadingConstraint: leadingConstraint,
                trailingConstraint: trailingConstraint)
    }

    private func buildConstraint(for attribute: NSLayoutAttribute) -> NSLayoutConstraint
    {
        let constraint =  NSLayoutConstraint(
                item: tableView,
                attribute: attribute,
                relatedBy: .equal,
                toItem: self.view,
                attribute: attribute,
                multiplier: 1,
                constant: 0)

        constraint.isActive = true

        return constraint
    }

    //MARK: - update data source

    func updateDataSource(with dataSource: Array<DataObject>)
    {
        self.dataSource.updateDataSource(with: dataSource)
    }

    func register()
    {

        self.tableView.estimatedRowHeight = 0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionFooterHeight = 0
        self.tableView.sectionHeaderHeight = 0
    }
}


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
