//
//  ITunesItemTableViewController.swift
//  iTunesSearch
//
//  Created by Doba Duc on 1/5/16.
//  Copyright © 2016 Ducky Duke. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireImage

class ITunesItemTableViewController: UITableViewController {
    var items: [ItunesFeedEntry] = []
    let feedType: ItunesFeedType

    init(feedType: ItunesFeedType) {
        self.feedType = feedType
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 50
        reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!

        let item = items[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = item.name
        cell.imageView!.image = UIImage(named: "icon-placeholder")

        Alamofire.request(.GET, item.imageURL).responseImage { response in
            if let image = response.result.value {
                cell.imageView!.image = image
                cell.setNeedsLayout()
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    func reloadData() {
        let target = ItunesAPITarget(query: ItunesFeedQuery(country: "us",feedType: feedType, genre: nil, limit: 50))
        ItunesProvider.request(target, completion: { (result) -> () in

            var success = false
            var message = "Unable to fetch data from iTunes. Please try again."

            switch result {
            case let .Success(response):
                do {
                    let json = try response.mapJSON() as! [String: AnyObject]
                    self.mapData(json)
                    success = true
                } catch {
                    self.items = []
                    // success == false
                }
            case let .Failure(error):
                self.items = []
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
            }

            self.tableView.reloadData()

            if !success {
                let alertController = UIAlertController(title: "Itunes Fetch Error", message: message, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }

    func mapData(json: [String: AnyObject]) {
        let ModelClass = ItunesFeedType.associatedModel(forFeedType: self.feedType)
        switch ModelClass {
        case is ItunesIOSApp.Type:
            self.items = Mapper<ItunesIOSApp>().mapArray(json["feed"]!["entry"])!
        default:
            self.items = Mapper<ItunesFeedEntry>().mapArray(json["feed"]!["entry"])!
        }
    }
}
