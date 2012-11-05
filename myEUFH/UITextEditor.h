//
//  UITextEditor.h
//  myEUFH
//
//  Created by Christoph Beger on 28.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextEditor : UIViewController {
    
    IBOutlet UITextView *tbNotes;
}
@property(nonatomic,readwrite) NSString *sNotes;
@end
