//
//  UIMatesDetail.m
//  myEUFH
//
//  Created by Christoph Beger on 22.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UIMatesDetail.h" 
#import "MailComposerViewController.h"

@interface UIMatesDetail ()

@end

@implementation UIMatesDetail
@synthesize currentMail, currentName, currentPhone;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.scrollEnabled = FALSE;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgEUFH1.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    currentMail = [NSString stringWithFormat:@"%@@eufh-mail.de",[[[[currentName stringByReplacingOccurrencesOfString:@" " withString:@"."] stringByReplacingOccurrencesOfString:@"ö" withString:@"oe"] stringByReplacingOccurrencesOfString:@"ä" withString:@"ae"] stringByReplacingOccurrencesOfString:@"ü" withString:@"ue"]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return currentName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %i, %i",indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.opaque = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
    cell.detailTextLabel.opaque = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:12.0f];
    
    if (indexPath.row == 0) {
        // Jetzt die Telefonnummer
        cell.textLabel.text = currentPhone;
        cell.detailTextLabel.text = @"Telefon";
    } else {
        // Jetzt die Mail Adresse
        cell.textLabel.text = currentMail;
        cell.detailTextLabel.text = @"E-Mail";
    }

    
    return cell;
}

-(NSString *)preparePhoneNumber:(NSMutableString *)phone {
    
    [phone replaceOccurrencesOfString:@" "
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"("
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@")"
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"-"
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"/"
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    [phone replaceOccurrencesOfString:@"+"
                           withString:@""
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [phone length])];
    
    return phone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        currentPhone = [self preparePhoneNumber:[NSMutableString stringWithFormat:@"%@",currentPhone]];
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+%@",currentPhone]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:+%@",currentPhone]]];
        }
    }
    else {
        NSString *mail = [NSString stringWithFormat:@"mailto:?to=%@",currentMail];
        
        mail = [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *recipients = [NSString stringWithFormat:@"%@",currentMail];
	
	NSString *email = [NSString stringWithFormat:@"mailto:%@",recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@""];
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:currentMail];
    
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	picker.navigationBar.tintColor = [UIColor blackColor];
	[self presentViewController:picker animated:YES completion:^{
        ;
    }];
    //[picker release];
}
@end
