import UIKit

class TableViewController: UITableViewController, XliftInfeedAdLoaderDelegate {

    // mdediaIdは、管理画面でメディア登録を行った際に発行されたIDをお使い下さい
    let infeedAdLoader:XliftInfeedAdLoader = XliftInfeedAdLoader(mediaId:123456789, isTest:true)
    var ads:[XliftInfeedAd] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infeedAdLoader.delegate = self
        infeedAdLoader.loadInfeedAd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Xlift InfeedAdLoader Delegate

    func xliftInfeedAdLoader(_ infeedAdLoader: XliftInfeedAdLoader!, didLoad infeedAds: [XliftInfeedAd]!) {
        ads = infeedAds
        tableView.reloadData()
    }
    
    func xliftInfeedAdLoader(_ infeedAdLoader: XliftInfeedAdLoader!, didFailLoad error: Error) {
        print(error)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ads.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ad = ads[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfeedCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        ad.loadImage(completeHandler: {img, error in
            imageView.image = img
        })
     
        let titleLabelView = cell.viewWithTag(2) as! UILabel
        titleLabelView.text = ad.title;
        
        let siteTitleLabelView = cell.viewWithTag(3) as! UILabel
        siteTitleLabelView.text = String(format:"PR: %@", ad.siteTitle)
     
        return cell

    }

    // MARK: - Table view dalegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ads[indexPath.row].open(completeHandler: {success in
            print("click")
        })
    }
}
