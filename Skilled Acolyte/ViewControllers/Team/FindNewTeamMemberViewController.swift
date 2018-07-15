//
//  FindNewTeamMemberViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 10/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

protocol FindNewTeamMemberViewControllerDelegate: class {
    func findNewTeamMemberSelected(student: Student)
}

class FindNewTeamMemberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    weak private var delegate: FindNewTeamMemberViewControllerDelegate?
    var students:[Student]! = [Student]()
    var filteredStudents:[Student]! = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets.init(top: 100, left: 0, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populate(withStudents students:[Student], delegate: FindNewTeamMemberViewControllerDelegate) {
        self.students = students
        self.filteredStudents = students
        self.delegate = delegate
    }
    
    @IBAction func btnCancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve an invite if there is one in range
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
        cell.populate(withStudent: filteredStudents[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = delegate {
            delegate.findNewTeamMemberSelected(student: filteredStudents[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            filteredStudents = students
        } else {
            filteredStudents = students.filter({ (student) -> Bool in
                return (student.fullName().range(of: searchBar.text!) != nil)
            })
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
