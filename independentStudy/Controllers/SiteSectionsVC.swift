//
//  SiteSectionsVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/5/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SiteSectionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    var numberSite = [String]()
    var alertSites = Set<String>()
    var site: Site!
    var siteSection: String?
    
    private var sites = [Site]()
    private var rowSelected = 1
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        refreshAlerts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshAlerts(){
        RedisCon.instance.getAlertSites(siteSection: siteSection!) { (array) in
            self.alertSites.removeAll();
            for index in 0..<array.count{
                print("Item: \(array[index])")
                self.alertSites.insert(array[index])
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refreshSites(_ sender: Any) {
        refreshAlerts()
    }
    
    

    //MARK: Table Views
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberSite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SiteCell") as? SiteTableCell else{
            return UITableViewCell()
        }
        
        let tempSite = Site(siteNum: self.numberSite[indexPath.row], siteClean: true, wood: true, info: "Nothing", duration: "1 hour")
        
        //Adding to an array
        sites.append(tempSite)
        var tempBool = false
        if alertSites.contains(self.numberSite[indexPath.row]){
            tempBool = true
        }
        cell.configureCell(site: tempSite,alert: tempBool)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        site = sites[indexPath.row]
        RedisCon.instance.getSiteInfo(number: site.siteNumber, site: "HGETALL site:\(site.siteNumber)") { (site) in
            self.site = site
            if(AuthService.instance.role == "Employee"){
                self.performSegue(withIdentifier: "showSiteVC", sender: self)
            }else if (AuthService.instance.role == "Manager"){
                self.performSegue(withIdentifier: "showSendVC", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSiteVC"){
            var vc = segue.destination as! SiteVC
            vc.wholeSite = site
            vc.siteSection = self.siteSection!
        }
        if(segue.identifier == "showSendVC"){
            var vc = segue.destination as! SiteSendVC
            vc.siteSelected = site
        }
    }
    
    //Unwind Segue
    @IBAction func unwindFromSiteVC(unwindSegue: UIStoryboardSegue ){
        print("going back completed")
    }
    @IBAction func unwindFromSendVC(unwindSegue: UIStoryboardSegue ){
        print("going back from sent")
    }

}
