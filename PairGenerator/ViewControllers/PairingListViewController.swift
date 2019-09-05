//
//  PairingListViewController.swift
//  PairGenerator
//
//  Created by Madison Kaori Shino on 9/5/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class PairingListViewController: UIViewController {

    //PROPERTIES
    var people: [Person] = []
    var pairs: [[Person]]?
    var pairCount: Int?
    
    //OUTLETS
    @IBOutlet weak var nameListTableView: UITableView!
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        fetchPeople()
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
    }
    
    //ACTIONS
    @IBAction func shufflePairingsButtonTapped(_ sender: Any) {
        createNewPairings()
        self.nameListTableView.reloadData()
    }
    
    //HELPER FUNCTIONS
    func fetchPeople() {
        PersonController.shared.fetchPeople { (people) in
            if let people = people {
                self.people = people
                DispatchQueue.main.async {
                    self.createNewPairings()
                    self.nameListTableView.reloadData()
                }
            }
        }
    }
    
    func createNewPairings() {
        self.pairs = nil
        var shuffledPeople = people.shuffled()
        let peopleCount = people.count
        var pairCount: Int
        if peopleCount % 2 != 0 {
            pairCount = (peopleCount / 2) + 1
        } else {
            pairCount = (peopleCount / 2)
        }
        self.pairCount = pairCount
        if pairCount > 0 {
            for _ in 1...pairCount {
                var pair: [Person] = []
                if shuffledPeople.count > 1 {
                    let person = shuffledPeople.remove(at: 0)
                    pair.append(person)
                    let personTwo = shuffledPeople.remove(at: 0)
                    pair.append(personTwo)
                } else {
                    pair = shuffledPeople
                }
                if pairs != nil {
                    pairs?.append(pair)
                } else {
                    pairs = [pair]
                }
            }
        } else { return }
    }
    
    func loadViews() {
        nameListTableView.layer.cornerRadius = 20
        let label = UILabel()
        label.text = "∙Pairings∙"
        label.textColor = #colorLiteral(red: 0.8236967921, green: 0.5886859298, blue: 0.6307470798, alpha: 1)
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 25)
        navigationItem.titleView = label
    }
    
    //NAVIGATION
    @IBAction func unwindFromAddPersonVC(segue:UIStoryboardSegue) {
        let data = segue.source as? AddNewPersonViewController
        guard let nameEntered = data?.name else { return }
        PersonController.shared.savePerson(withName: nameEntered) { (person) in
            if let person = person {
                self.people.append(person)
                DispatchQueue.main.async {
                    self.createNewPairings()
                    self.nameListTableView.reloadData()
                }
            }
        }
    }
}

//TABLE VIEW DATA SOURCE
extension PairingListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let pairCount = pairCount else { return 1 }
        if pairCount > 1 {
            return pairCount
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pairs = pairs else { return 0 }
        let sectionCount = pairs.count - 1
        if section <= sectionCount {
            return pairs[section].count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pairs == nil {
            return ""
        } else {
            return "Pair \(section+1)"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        headerLabel.textColor = #colorLiteral(red: 0.8236967921, green: 0.5886859298, blue: 0.6307470798, alpha: 1)
        headerLabel.text = self.tableView(nameListTableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        guard let pairs = pairs else { return UITableViewCell() }
        let person = pairs[indexPath.section][indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var pairs = pairs else { return }
            let person = pairs[indexPath.section][indexPath.row]
            PersonController.shared.delete(person: person) { (success) in
                if success {
                    DispatchQueue.main.async {
                        pairs[indexPath.section].remove(at: indexPath.row)
                        guard let index = self.people.firstIndex(of: person) else { return }
                        self.people.remove(at: index)
                        self.createNewPairings()
                        self.nameListTableView.reloadData()
                        print("success")
                    }
                }
            }
        }
    }
}
