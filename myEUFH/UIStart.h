//
//  UIStart.h
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStart : UIViewController <UITextFieldDelegate> {

    IBOutlet UIButton *myLoginButton;
    IBOutlet UIButton *myLoginFrame;
    IBOutlet UITextField *tbUser;
    IBOutlet UITextField *tbPassword;
    IBOutlet UILabel *lbUser;
    IBOutlet UILabel *lbPassword;
    IBOutlet UIImageView *myImageView;
    int nResize;
    IBOutlet UIActivityIndicatorView *myActivtyIndicator;
    IBOutlet UILabel *lbWelcome;
    IBOutlet UILabel *lbCurrentUser;
    NSMutableString *sUser, *sPW, * currentElement, *sCourse, *sYear, *sProgram, *sUserID, *sForeName, *sSurname;
    NSXMLParser * rssParser;
	NSMutableArray * userData;
	NSMutableDictionary * user;
    NSUserDefaults *defaults;
    UIActivityIndicatorView *activityView;
    UIView *disabledView;
    Boolean login;
}

@end
