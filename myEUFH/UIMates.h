//
//  UIMates.h
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMates : UITableViewController{
    NSMutableString *sMateName, * currentElement, *sMateID, *sMatePhone, *sMateMail, *currentFirstLetter;
    NSXMLParser * rssParser;
	NSMutableArray * data, *flcount, *firstletters;
	NSMutableDictionary * detail;
    NSUserDefaults *defaults;
}

@property(nonatomic,readwrite) int nCourseID;

@end
