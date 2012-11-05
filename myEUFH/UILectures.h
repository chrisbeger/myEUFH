//
//  UILectures.h
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILectures : UITableViewController{
    NSMutableString *sLecture, * currentElement,* currentFirstLetter, *sLectureID, *sLectureDean, *sLecutreDate, *sLectureStart, *sLectureEnd, *sLectureRoom, *sLectureNotes;
    NSXMLParser * rssParser;
	NSMutableArray * data, *flcount, *firstletters;
	NSMutableDictionary * detail;
    NSUserDefaults *defaults;
}

@property(nonatomic,readwrite) int nModeID;

@end
