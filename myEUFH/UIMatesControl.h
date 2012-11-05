//
//  UIMatesControl.h
//  myEUFH
//
//  Created by Christoph Beger on 22.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMatesControl : UITableViewController {
    NSMutableString *sCourseID, * currentElement, *sCourseName;
    NSXMLParser * rssParser;
	NSMutableArray * data;
	NSMutableDictionary * detail;
    NSUserDefaults *defaults;
}

@end
