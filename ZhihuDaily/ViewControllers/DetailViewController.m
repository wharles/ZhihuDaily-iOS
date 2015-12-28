//
//  DetailViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import <ReactiveCocoa.h>

#import "RequestManager.h"
#import "SQLiteHelper.h"

@interface DetailViewController () <WKScriptMessageHandler, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) NewsContent *newsContent;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareClicked)];
    UIBarButtonItem *remarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remark"] style:UIBarButtonItemStyleDone target:self action:@selector(markClicked)];
    self.navigationItem.rightBarButtonItems = @[shareButton, remarkButton];
    //配置WKWebView
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"notification"];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    //indicator
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:4 requestParaId:self.newsId];
    [[[RACObserve([RequestManager sharedManager], newsContent) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NewsContent *content) {
         self.newsContent = content;
         NSString *html = [self jointHTMLWithModel:content];
         if (content.body != nil) {
             [self.webView loadHTMLString:html baseURL:nil];
         } else {
             NSURL *url = [NSURL URLWithString:content.shareURL];
             NSURLRequest *request = [NSURLRequest requestWithURL:url];
             [self.webView loadRequest:request];
         }
     }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.spinner stopAnimating];
}

- (void)shareClicked {
    NSLog(@"%@",self.newsContent.shareURL);
    NSArray *activityItems = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"#知乎日报#%@", self.newsContent.title], self.newsContent.shareURL, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [activityVC dismissViewControllerAnimated:YES completion:nil];
    };
    activityVC.completionWithItemsHandler = completionHandler;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)markClicked {
    SQLiteHelper *sqliteHelper = [SQLiteHelper sharedManager];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO INFO (newsId, name) VALUES ('%ld', '%@')", self.newsContent.id, self.newsContent.title];
    BOOL result = [sqliteHelper execSql:sql];
    NSString *title = nil;
    if (result == YES) {
        title = @"收藏成功！";
    } else {
        title = @"收藏失败！";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alertView show];
}

/**
 将请求到的对象拼成一个html
 **/
- (NSString *)jointHTMLWithModel:(NewsContent *)content {
    NSMutableString *headGroup = [NSMutableString stringWithString:@""];
    for (NSString *script in content.js) {
        [headGroup appendString:[NSString stringWithFormat:@"<script type=\"text/javascript\" src=\"%@\">",script]];
    }
    for (NSString *style in content.css) {
        [headGroup appendString:[NSString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\" />",style]];
    }
    //html style
    [headGroup appendString:@"<style type=\"text/css\"> #imgDiv { height:300px;width:100％; position: relative; }"];
    [headGroup appendString:@".blackDiv { background-color: rgba(0, 0, 0, 0.5); width:100%; height: 80px; position: absolute; bottom: 0px; left: 0px;display: table; }"];
    [headGroup appendString:@"#title { font-size: 18px; display: table-cell; vertical-align: middle; color: #FFFFFF; padding-left: 10px; }"];
    [headGroup appendString:@"#copyRight { color: lightgray; font-size: 12px;  float: right; padding-right: 10px; } </style>"];
    //html js
    [headGroup appendString:@"<script type=\"text/javascript\"> $(document).ready(function () { $('div').remove('.img-place-holder'); $('a').each(function () { var href = $(this).attr('href'); $(this).attr('href', ''); $(this).click(function (event) { event.preventDefault(); }); $(this).click(function () { window.webkit.messageHandlers.notification.postMessage(href);  });});});</script></head><body>"];
    //顶部图像
    NSString *imageDiv = @"";
    if (content.image && ![content.image isEqual:@""]) {
        imageDiv = [NSString stringWithFormat:@"<div id=\"imgDiv\" style=\"background-image:url('%@');\"><div class=\"blackDiv\"><span id=\"title\">%@<br /><span id=\'copyRight\'>%@</span></span></div></div>", content.image, content.title, content.imageSource];
    }

    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width,user-scalable=no,target-densitydpi=device-dpi\" /><script src=\"http://cdn.bootcss.com/jquery/2.1.4/jquery.min.js\"></script>%@</head><body>%@%@</body></html>", headGroup,  imageDiv, content.body];
   
    return html;
}


//js回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"Message: %@", message.body);
    NSURL *url = [[NSURL alloc] initWithString:message.body];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
