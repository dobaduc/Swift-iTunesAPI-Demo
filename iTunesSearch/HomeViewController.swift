//
//  HomeViewController.swift
//  iTunesSearch
//
//  Created by Doba Duc on 12/25/15.
//  Copyright © 2015 Ducky Duke. All rights reserved.
//

import UIKit
import SegmentedController
import Moya
import ObjectMapper

class HomeViewController: SegmentedViewController {
    let ItunesProvider = MoyaProvider<ItunesAPITarget>()

    var entries: [ItunesFeedEntry]? = []
    var didLayoutSubviews = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createTab(title: String, feedType: ItunesFeedType) -> UITableViewController {
        let tb = ITunesItemTableViewController(feedType: feedType)
        var frame = view.bounds
        frame.origin.y = segmentedControl.frame.height
        frame.size.height = frame.height - segmentedControl.frame.height
        tb.tableView.frame = frame
        tb.title = title
        return tb
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayoutSubviews {
            didLayoutSubviews = true

            viewControllers = [
                createTab("Free apps", feedType: .TopFreeApps),
                createTab("Paid apps", feedType: .TopPaidApps),
                createTab("Songs", feedType: .TopSongs),
                createTab("Podcast", feedType: .TopPodcasts)
            ]

            for tb in viewControllers {
                if let tb = tb as? UITableViewController {
                    var frame = view.bounds
                    frame.origin.y = segmentedControl.frame.height
                    frame.size.height = frame.height - segmentedControl.frame.height
                    tb.tableView.frame = frame
                }
            }
        }
    }

    override func didChangeSelectedIndex(sender: SegmentedControl) {
        super.didChangeSelectedIndex(sender)
    }
}

