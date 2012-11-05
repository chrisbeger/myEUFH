//
//  UIMatesDetail.h
//  myEUFH
//
//  Created by Christoph Beger on 22.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface UIMatesDetail : UITableViewController
@property (nonatomic, strong) NSString *currentName, *currentPhone, *currentMail;
-(IBAction)showPicker:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
@end
