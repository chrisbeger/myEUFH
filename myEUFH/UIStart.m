//
//  UIStart.m
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UIStart.h"
#import "NSString+MD5.h"
#import <QuartzCore/QuartzCore.h>

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)


@interface UIStart ()

@end

@implementation UIStart

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
    self.title = @"Start";
    //User Defaults
    defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"myeufh_remember"] integerValue] != 1) {
        [defaults removeObjectForKey:@"myeufh_userid"];
        [defaults removeObjectForKey:@"myeufh_userpw"];
        [defaults removeObjectForKey:@"myeufh_userlogin"];
    }
    tbPassword.delegate = self;
    tbUser.delegate = self;
    nResize = 0;
    
    
    //self.tabBarController.delegate = self;
    //Controls ausblenden
    myActivtyIndicator.hidden = TRUE;
    
    [self checkForCurrentSession];
    self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the m.
}
- (IBAction)clickOnTbUser:(id)sender {
    if (nResize == 0) {
        [self doPositionChangesUp];

    }
}
- (IBAction)clickOnTbPassword:(id)sender {
    if (nResize == 0) {
        [self doPositionChangesUp];
        
    }
}
- (IBAction)clickOnLoginButton:(id)sender {
    [tbPassword resignFirstResponder];
    [tbUser resignFirstResponder];
    [self doPositionChangesDown];
    myActivtyIndicator.hidden = FALSE;
    [myActivtyIndicator startAnimating];
    if (login == TRUE) {
        // Hier den LogOut
        [self doLogOut];
    }
    else {
        //Hier der Login
        [self doLogin];
    }
}

-(void)checkForCurrentSession{
    // ist der user bereits eingeloggt
    if ([[defaults objectForKey:@"myeufh_userid"] integerValue] > 0) {
        // bereits eingelogt
        lbCurrentUser.hidden = FALSE;
        lbWelcome.hidden = FALSE;
        tbPassword.hidden = TRUE;
        tbUser.hidden = TRUE;
        lbUser.hidden = TRUE;
        lbPassword.hidden = TRUE;
        myActivtyIndicator.hidden= TRUE;
        myLoginButton.hidden = FALSE;
        [myLoginButton setTitle:@"Abmelden" forState:0];
        myLoginFrame.hidden = TRUE;
        //tabbar enablen
        for(UITabBarItem *item in self.tabBarController.tabBar.items)
            item.enabled = true;
        //texte zuweisen
        lbWelcome.text = @"Herzlich Willkommen";
        lbCurrentUser.text = [NSString stringWithFormat:@"%@ %@",[defaults objectForKey:@"myeufh_forename"],[defaults objectForKey:@"myeufh_surname"]];
        login = TRUE;
        
    }
    else{
        //hier den login zeigen
        lbCurrentUser.hidden = TRUE;
        lbWelcome.hidden = TRUE;
        lbUser.hidden = FALSE;
        lbPassword.hidden = FALSE;
        tbPassword.hidden = FALSE;
        tbUser.hidden = FALSE;
        lbUser.text = @"Login";
        myActivtyIndicator.hidden= TRUE;
        myLoginButton.hidden = FALSE;
        [myLoginButton setTitle:@"Anmelden" forState:0];
        myLoginFrame.hidden = FALSE;
        //tabbar disablen
        for(UITabBarItem *item in self.tabBarController.tabBar.items)
            item.enabled = false;
        //jetzt schauen ob das PW gespeichert worden ist
        if ([[defaults objectForKey:@"myeufh_remember"] integerValue] == 1) {
            tbPassword.text = [defaults objectForKey:@"myeufh_userpw"];
            tbUser.text = [defaults objectForKey:@"myeufh_userlogin"];
        }
        else {
            tbPassword.text = @"";
            tbUser.text = @"";
        }
        login = FALSE;
    }
}

// Ausloggen des User
-(void)doLogOut{
    if ([[defaults objectForKey:@"myeufh_remember"] integerValue] != 1) {
        [defaults removeObjectForKey:@"myeufh_userpw"];
        [defaults removeObjectForKey:@"myeufh_userlogin"];
    }
    [defaults removeObjectForKey:@"myeufh_userid"];
    [myActivtyIndicator stopAnimating];
    myActivtyIndicator.hidden = TRUE;
    [self viewDidLoad];

}

// Führt den Login aus 
-(void) doLogin{
    sPW = [NSString stringWithFormat:@"%@",tbPassword.text];
    sUser = [NSString stringWithFormat:@"%@",tbUser.text];
    
    if (sPW.length > 0 && sUser.length > 0) {
        
        //Login Seite
        NSString * path = [NSString stringWithFormat:@"http://myeufh.beger.org/mobile.php?object=login&pw=%@&login=%@",[sPW MD5], tbUser.text];
        //XML holen
		[self parseXMLFileAtURL:path];
        
        // Jetzt schauen wir ob alles in Ordnung war
        [self checkForCurrentSession];
        
    }
    else {
        // Schüttelgeste
        nResize = 0;
        [self earthquake:myImageView];
        [myActivtyIndicator stopAnimating];
        myActivtyIndicator.hidden = TRUE;
    }

}

// Verschiebt den Login Frame nach oben
-(void)doPositionChangesUp{
    //alles nach oben verschieben
    //hauptframe
    CGRect btFrame = myLoginFrame.frame;
    nResize = myImageView.frame.origin.y + 30 - btFrame.origin.y;
    btFrame.origin.y = myImageView.frame.origin.y + 30;
    myLoginFrame.frame = btFrame;
    //anmelde button
    btFrame = myLoginButton.frame;
    btFrame.origin.y += nResize;
    myLoginButton.frame = btFrame;
    //user label
    btFrame = lbUser.frame;
    btFrame.origin.y += nResize;
    lbUser.frame = btFrame;
    //password label
    btFrame = lbPassword.frame;
    btFrame.origin.y += nResize;
    lbPassword.frame = btFrame;
    //password tb
    btFrame = tbPassword.frame;
    btFrame.origin.y += nResize;
    tbPassword.frame = btFrame;
    //user tb
    btFrame = tbUser.frame;
    btFrame.origin.y += nResize;
    tbUser.frame = btFrame;
}
// Verschiebt den Login Frame nach unten 
-(void)doPositionChangesDown{
    //alles nach oben verschieben
    //hauptframe
    CGRect btFrame = myLoginFrame.frame;
    btFrame.origin.y -= nResize;
    myLoginFrame.frame = btFrame;
    //anmelde button
    btFrame = myLoginButton.frame;
    btFrame.origin.y -= nResize;
    myLoginButton.frame = btFrame;
    //user label
    btFrame = lbUser.frame;
    btFrame.origin.y -= nResize;
    lbUser.frame = btFrame;
    //password label
    btFrame = lbPassword.frame;
    btFrame.origin.y -= nResize;
    lbPassword.frame = btFrame;
    //password tb
    btFrame = tbPassword.frame;
    btFrame.origin.y -= nResize;
    tbPassword.frame = btFrame;
    //user tb
    btFrame = tbUser.frame;
    btFrame.origin.y -= nResize;
    tbUser.frame = btFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseXMLFileAtURL:(NSString *)URL
{
	userData = [[NSMutableArray alloc] init];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Die Anmeldung konnte nicht durchgeführt werden.\nFehler %i", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"detail"]) {
		// clear out our story item caches...
		user = [[NSMutableDictionary alloc] init];
		sCourse = [[NSMutableString alloc] init];
        sProgram = [[NSMutableString alloc] init];
        sYear = [[NSMutableString alloc] init];
        sUserID = [[NSMutableString alloc] init];
        sSurname = [[NSMutableString alloc] init];
        sForeName = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	if ([elementName isEqualToString:@"detail"]) {
		// save values to an item, then store that item into the array...
		[user setObject:sProgram forKey:@"program"];
		[user setObject:sCourse forKey:@"course"];
		[user setObject:sYear forKey:@"year"];
		[user setObject:sUserID forKey:@"id"];
        [user setObject:sSurname forKey:@"surname"];
		[user setObject:sForeName forKey:@"forename"];
        
		[userData addObject:[user copy]];
        
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	// save the characters for the current item...
    // und die $ Zeichen mit & ersetzten
	if ([currentElement isEqualToString:@"program"]) {
		[sProgram appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	} else if ([currentElement isEqualToString:@"course"]) {
		[sCourse appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	} else if ([currentElement isEqualToString:@"year"]) {
		[sYear appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } else if ([currentElement isEqualToString:@"id"]) {
		[sUserID appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } else if ([currentElement isEqualToString:@"surname"]) {
		[sSurname appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } else if ([currentElement isEqualToString:@"forename"]) {
		[sForeName appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } 
    
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // hier schreiben wir die Werte in die User DeFaults
    if ([userData count] == 1) {
        [defaults setObject:[[userData objectAtIndex:0] objectForKey:@"program"] forKey:@"myeufh_userprogram"];
        [defaults setObject:[[userData objectAtIndex:0] objectForKey:@"course"] forKey:@"myeufh_usercourse"];
        [defaults setObject:[[userData objectAtIndex:0] objectForKey:@"id"] forKey:@"myeufh_userid"];
        [defaults setObject:[[userData objectAtIndex:0] objectForKey:@"surname"] forKey:@"myeufh_surname"];
        [defaults setObject:[[userData objectAtIndex:0] objectForKey:@"forename"] forKey:@"myeufh_forename"];
        
    }
    else {
        // Hier die Schüttelgest
        [self earthquake:myImageView];
    }
    [defaults setObject:tbUser.text forKey:@"myeufh_userlogin"];
    [defaults setObject:tbPassword.text forKey:@"myeufh_userpw"];
    [myActivtyIndicator stopAnimating];
    myActivtyIndicator.hidden = TRUE;
    
    nResize = 0;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //if (disabledView.hidden == TRUE) {
     //   [self showActivityIndicator];
    //}
}

-(void) viewDidDisappear:(BOOL)animated {
    [self popActivityIndicator];
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


-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    //write you code here to capture the return key.
    //Make sure to change textfield's class from interface builder if you are using interfce builder or initialize by code.
    if(textField.tag == 101) {
         UIResponder* nextResponder = [textField.superview viewWithTag:102];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        }
    }
    if(textField.tag == 102) {
        [self clickOnLoginButton:self];
    }
    return true;
}

- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:6];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}


@end
