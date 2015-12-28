//
//  AboutViewController.h
//  LiveTV
//
//  Created by Koudai on 15/12/17.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIImageView *logoImageView;
@property (strong,nonatomic) UILabel *remarkLabel;
@property (strong,nonatomic) UIButton *contactButton;
@property (strong,nonatomic) UIButton *websiteButton;

@end
