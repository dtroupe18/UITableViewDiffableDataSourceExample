//
//  ViewController.swift
//  iOS13
//
//  Created by Dave Troupe on 6/11/19.
//  Copyright © 2019 WaveMeditation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Section: CaseIterable {
        case friends
        case family
        case coworkers
    }

    struct Contact: Hashable {
        var name: String
        var email: String
    }

    struct ContactList {
        var friends: [Contact]
        var family: [Contact]
        var coworkers: [Contact]
    }

    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellReuseIdentifier
        )

        tableView.dataSource = dataSource

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        loadData()
    }


    func makeDataSource() -> UITableViewDiffableDataSource<Section, Contact> {
        let reuseIdentifier = cellReuseIdentifier

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, contact in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                )

                // UNCOMMENTING THIS WILL CAUSE A CRASH
                //
//                if contact.name == "Bob" {
//                    return nil
//                }

                cell.textLabel?.text = contact.name
                cell.detailTextLabel?.text = contact.email
                return cell
            }
        )
    }

    func update(with list: ContactList, animate: Bool = true) {
        let snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(list.friends, toSection: .friends)
        snapshot.appendItems(list.family, toSection: .family)
        snapshot.appendItems(list.coworkers, toSection: .coworkers)

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

    func loadData() {
        let friends = [
            Contact(name: "Bob", email: "Bob@gmail.com"),
            Contact(name: "Tom", email: "Tom@myspace.com")
        ]

        let family = [
            Contact(name: "Mom", email: "mom@aol.com"),
            Contact(name: "Dad", email: "dad@aol.com")
        ]

        let coworkers = [
            Contact(name: "Mason", email: "tim@something.com"),
            Contact(name: "Tim", email: "mason@something.com")
        ]

        let contactList = ContactList(friends: friends, family: family, coworkers: coworkers)
        update(with: contactList, animate: true)
    }
}

