#import "ViewController.h"
#import <XliftSDK/XliftWidgetView.h>
#import <XliftSDK/XliftWidgetViewDelegate.h>
#import <XliftSDK/XliftWidgetItem.h>

@interface ViewController () <XliftWidgetViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet XliftWidgetView *XliftWidgetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *XliftWidgetViewHeightConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = [NSURL URLWithString:@"select.mamastar.jp/215638"];
    self.naviItem.title = [self.url absoluteString];
    self.contentLabel.text = [NSString stringWithFormat:@"URLをもとにコンテンツを表示する\nURL: %@", [self.url absoluteString]];
    self.XliftWidgetView.delegate = self;
    [self.XliftWidgetView loadWithURL:self.url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)XliftWidgetView:(XliftWidgetView *)XliftWidgetView didSelectItem:(XliftWidgetItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    if (item.itemType == XliftWidgetItemTypeAd) {
        return true;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
        viewController.url = item.linkURL;
        [self.navigationController pushViewController:viewController animated:YES];
        return false;
    }
}

- (void)XliftWidgetView:(XliftWidgetView *)XliftWidgetView recommendHeight:(CGFloat)height
{
    self.XliftWidgetViewHeightConstraint.constant = height;
}

@end
