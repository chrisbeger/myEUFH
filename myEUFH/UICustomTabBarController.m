//
//  UICustomTabBarController.m
//  myEUFH
//
//  Created by Christoph Beger on 29.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UICustomTabBarController.h"
#import <QuartzCore/QuartzCore.h>

@interface UICustomTabBarController ()

@end

@implementation UICustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;
	// Do any additional setup after loading the view.
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //[self showActivityIndicator];
}
-(void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"hello");

}


-(void)popActivityIndicator {
    [activityView stopAnimating];
    activityView.hidden = TRUE;
    
    disabledView.hidden = TRUE;
}

-(void)showActivityIndicator {
    disabledView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60.0, 60.0)];
    disabledView.center = self.view.center;
    disabledView.tag = 99;
    disabledView.layer.cornerRadius = 10;
    [disabledView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
    
    [self.view addSubview:disabledView];
    
    
    //Hier zeigen wir den Activity Indicator
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tag = 100;
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
}
-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"hello");
}
-(void)viewWillDisappear:(BOOL)animated {
     NSLog(@"hello");
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     NSLog(@"hello");
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion  {
    NSLog(@"hello");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
