//
//  UICustomTabBarController.h
//  myEUFH
//
//  Created by Christoph Beger on 29.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomTabBarController : UITabBarController <UITabBarDelegate,UITabBarControllerDelegate> {
    UIActivityIndicatorView *activityView;
    UIView *disabledView;
}

@end
