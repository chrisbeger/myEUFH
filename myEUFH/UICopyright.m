//
//  UICopyright.m
//  myEUFH
//
//  Created by Christoph Beger on 20.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UICopyright.h"
#import <QuartzCore/QuartzCore.h>

@interface UICopyright ()

@end

@implementation UICopyright

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
    self.title = @"Copyright";
    
    ivLogo.image = [UIImage imageNamed:@"EUFH_Copyright.png"];
    
    tvCopright.editable = FALSE;
    tvCopright.backgroundColor = [UIColor clearColor];
    tvCopright.text = @"myEUFH 1.0\nCopyright © 2012\nby Christoph Beger";
    
    tvThanks.editable = FALSE;
    tvThanks.layer.borderColor = [[UIColor grayColor] CGColor];
    tvThanks.layer.borderWidth = 1.0f;
    tvThanks.text = @"Vielen Dank an Tobias für den Aufbau des Webfrontend und Axel für die Erstellung der Grafiken.\nWeiterhin vielen Dank an alle Tester aus WI11 für die Qualitätssicherung.";
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgEUFH1.png"]];
    //self.navigationController.navigationBar.backItem.backBarButtonItem.tintColor = [UIColor orangeColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
