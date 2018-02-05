//
//  SiteSectionsVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/5/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SiteSectionsVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SiteCell") as? SiteTableCell else{
            print("Happened")
            return UITableViewCell()
        }
        cell.configureCell(siteName: "Intitial", timeFrame: "Today")
        return cell
    }

}
