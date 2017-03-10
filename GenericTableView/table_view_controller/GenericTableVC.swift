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

class GenericTableVC: UIViewController, UITableViewDelegate
{
    //MARK: - table view

    let tableView: UITableView = UITableView()
    var dataSource: TableDataSource!

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
        self.dataSource = TableDataSource(tableView: self.tableView,supportTypes: [String(describing: Person.self):BaseExtraTextCell.self,
                                                                          String(describing: Audio.self): BaseCell.self])
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
