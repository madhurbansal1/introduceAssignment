//
//  viewAllVC.swift
//  introduceAssignment
//
//  Created by madhur bansal on 5/11/21.
//

import UIKit

class viewAllVC: UIViewController
{
    @IBOutlet weak var tableview: UITableView!
    
    var userArray:[userStruct] = []
    var mfirebaseManager:firebaseManager!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        mfirebaseManager = firebaseManager()
        tableview.tableFooterView = UIView()
        tableview.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        getData()
    }
    
    func getData()
    {
        self.startAtcivityIndicator()
        mfirebaseManager.fetchUsers { (enrolledUsers) in
            self.stopActivityIndicator()
            self.userArray = enrolledUsers
            self.tableview.reloadData()
        }
    }
}

extension viewAllVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! userCell
        cell.profileImageView.downloaded(from: userArray[indexPath.row].imageStr)
        cell.nameLabel.text = userArray[indexPath.row].name
        cell.detailLabel.text = "\(userArray[indexPath.row].gender) | \(userArray[indexPath.row].age) | \(userArray[indexPath.row].city)"
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    @objc func deletePressed(_ sender:UIButton)
    {
        let x = sender.tag
        mfirebaseManager.deleteUser(firebaseId: userArray[x].firebaseId) { (message) in
            self.presentAlertController("MESSAGE", message)
            self.getData()
        }
    }
}
