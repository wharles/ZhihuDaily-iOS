//
//  AppDelegate.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "StartImage.h"
#import "RequestManager.h"

#import <TSMessage.h>
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface AppDelegate ()

@property (strong, nonatomic) UIView *launchView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController* rootVC = [[MainViewController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:rootVC];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self setDefaultStyle];
    
    [TSMessage setDefaultViewController:self.window.rootViewController];
    
    [self initLaunchScreenView];
    
    return YES;
}

/**
 设置全局的风格
 **/
- (void)setDefaultStyle {
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:231.0/255.0 green:95.0/255.0 blue:53.0/255.0 alpha:0.3];
    //custom bar font
    UIFont* barFont = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:22.0];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:barFont};
    //change style of status bar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //style of tool bar
    [UIBarButtonItem appearance].tintColor = [UIColor colorWithRed:235.0 / 255.0 green:73.0 / 255.0 blue:27.0 / 255.0 alpha:1.0];
    [UIToolbar appearance].barTintColor = [UIColor colorWithRed:237.0 / 255.0 green:240.0 / 255.0 blue:243.0 / 255.0 alpha:0.5];
    //custom tab bar
    [UITabBar appearance].tintColor = [UIColor colorWithRed:235.0 / 255.0 green:75.0 / 255.0 blue:27.0 / 255.0 alpha:1.0];
    [UITabBar appearance].barTintColor = [UIColor blackColor];
}

/**
 加载splash screen
 **/
- (void)initLaunchScreenView {
    //获取sb实例
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    _launchView = viewController.view;
    _launchView.frame = self.window.frame;
    [self.window addSubview:_launchView];
    UIImageView *imageView = [viewController.view viewWithTag:10];
    //注册并加载数据
    [[RequestManager sharedManager] startRequestWithVCId:7];
    [[RACObserve([RequestManager sharedManager], startImage) deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(StartImage *startImage) {
         [imageView sd_setImageWithURL:[NSURL URLWithString:startImage.img] placeholderImage:[UIImage imageNamed:@"splashimage"]];
     }];
    [_launchView addSubview:imageView];
    [self.window bringSubviewToFront:_launchView];
    //3s后remove launch screen
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLaunchView) userInfo:nil repeats:NO];
}

-(void)removeLaunchView {
    [_launchView removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
