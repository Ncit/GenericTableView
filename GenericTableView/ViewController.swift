//
//  ViewController.swift
//  GenericTableView
//
//  Created by Nikita Feshchun on 10.03.17.
//  Copyright © 2017 Ncit. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell, DataInteractor
{
    func setup(dataObject: DataObject)
    {
        self.textLabel?.text = dataObject.info["info"] as? String
    }
}

class BaseExtraTextCell: UITableViewCell, DataInteractor
{
    func setup(dataObject: DataObject)
    {
        if let extraInfo = dataObject.info["extra"] as? String
        {
            self.textLabel?.text = "extra text + \(extraInfo)"
        }
    }
}

class Person: DataObject
{
    let simpleInfo: String = "random number is \(arc4random_uniform(15) + 1)"

    var info: Dictionary<String, Any> {
        return [
                "info": simpleInfo,
                "extra": "\(self.self)"]
    }

}

class Audio: DataObject
{
    let audioExtra: String = "audio extra info"
    let simpleInfo: String = "simple info audio \(arc4random_uniform(15) + 1)"

    var info: Dictionary<String, Any> {
        return [
                "info": simpleInfo,
                "extra": audioExtra]
    }

}

class ViewController: UIViewController {

    lazy var genericTableVC: GenericTableVC = GenericTableVC<BaseExtraTextCell>.build(with: [Audio(), Person(), Audio(), Person()])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(genericTableVC, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

