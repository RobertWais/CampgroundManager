//
//  SiteSectionsVC.swift
//  independentStudy
//
//  Created by Robert Wais on 2/5/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class SiteSectionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var sites = [Site]()
    var numberSite = [String]()
    var site: Site!
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
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Hopefully last")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        cell.configureCell(site: tempSite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        site = sites[indexPath.row]
        
        RedisCon.instance.getSiteInfo(number: site.siteNumber, site: "HGETALL site:\(site.siteNumber)") { (site) in
            self.site = site
            if(user==2){
                self.performSegue(withIdentifier: "showSendVC", sender: self)
            }else if (user==1){
                self.performSegue(withIdentifier: "showSiteVC", sender: self)
            }
        }
        //site.siteNumber = cell.siteNumber
        //site.timeFrame = cell.timeFrame
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSiteVC"){
            //let path = self.tableView.indexPathForSelectedRow?.row
            
            var vc = segue.destination as! SiteVC
            vc.wholeSite = site
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
