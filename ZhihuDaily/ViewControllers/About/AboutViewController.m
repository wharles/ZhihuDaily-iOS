//
//  AboutViewController.m
//  LiveTV
//
//  Created by Koudai on 15/12/17.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
    self.logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 100, 90, 200, 200)];
    self.logoImageView.image = [UIImage imageNamed:@"topImg0"];
    self.logoImageView.layer.cornerRadius = 25;
    self.logoImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.logoImageView];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 100, 300, 200, 50)];
    self.remarkLabel.textAlignment = NSTextAlignmentCenter;
    self.remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.remarkLabel.numberOfLines = 0;
    [self.remarkLabel setText:@"遇到问题？ \n 请选择一种解决方式"];
    [self.remarkLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.remarkLabel];
    
    self.contactButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contactButton setTitle:@"联系我们" forState:UIControlStateNormal];
    self.contactButton.backgroundColor = [UIColor colorWithRed:79.0 / 255.0 green:186.0 / 255.0 blue:31.0 / 255.0 alpha:1.0];
    self.contactButton.tintColor = [UIColor whiteColor];
    self.contactButton.frame = CGRectMake(self.view.bounds.size.width / 2 - 100, 400, 200, 30);
    [self.contactButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.contactButton];
    
    self.websiteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.websiteButton setTitle:@"访问官网" forState:UIControlStateNormal];
    self.websiteButton.backgroundColor = [UIColor colorWithRed:79.0 / 255.0 green:186.0 / 255.0 blue:31.0 / 255.0 alpha:1.0];
    self.websiteButton.tintColor = [UIColor whiteColor];
    self.websiteButton.frame = CGRectMake(self.view.bounds.size.width / 2 - 100, 435, 200, 30);
    [self.websiteButton addTarget:self action:@selector(gotoWebsite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.websiteButton];
}

- (void)gotoWebsite{
    WebViewController* webViewController = [[WebViewController alloc]init];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)sendEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* composer = [[MFMailComposeViewController alloc]init];
        composer.mailComposeDelegate = self;
        [composer setToRecipients:@[@"cherlies_wang@outlook.com"]];
        composer.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:composer animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Failed to send mail:%@",error.localizedDescription);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
