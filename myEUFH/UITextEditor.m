//
//  UITextEditor.m
//  myEUFH
//
//  Created by Christoph Beger on 28.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UITextEditor.h"
#import <QuartzCore/QuartzCore.h>

@interface UITextEditor ()

@end

@implementation UITextEditor
@synthesize sNotes;
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
    tbNotes.text = sNotes;
    tbNotes.backgroundColor = [UIColor whiteColor];
    tbNotes.opaque = FALSE;
    tbNotes.layer.borderWidth =1.0f;
    tbNotes.layer.borderColor = [[UIColor grayColor] CGColor];
    self.title = @"Details";
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgEUFH1.png"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
