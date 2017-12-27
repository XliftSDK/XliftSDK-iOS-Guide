import UIKit

class ViewController: UIViewController, XliftWidgetViewDelegate {

    public var url:URL = URL(string: "select.mamastar.jp/215638")!
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var XliftWidgetView: XliftWidgetView!
    @IBOutlet weak var XliftWidgetHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleItem.title = url.absoluteString
        self.contentLabel.text = String(format: "URLをもとにコンテンツを表示する\nURL: %@", url.absoluteString)
        
        self.XliftWidgetView.delegate = self
        self.XliftWidgetView.load(with: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Xlift Widget View Delegate
    // WidgetのSlotがクリックされたイベントを通知する
    func xliftWidgetView(_ xliftWidgetView: XliftWidgetView, didSelect item: XliftWidgetItem, at indexPath: IndexPath) -> Bool {
        if (item.itemType() == XliftWidgetItemType.ad) {
            return true;
        } else {
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
            viewController.url = item.linkURL
            self.navigationController?.pushViewController(viewController, animated: true)
            return false;
        }
    }
    
    // Widgetの高さの推奨値を通知する
    func xliftWidgetView(_ xliftWidgetView: XliftWidgetView, recommendHeight height: CGFloat) -> Void {
        XliftWidgetHeightConstraint.constant = height
    }
}

