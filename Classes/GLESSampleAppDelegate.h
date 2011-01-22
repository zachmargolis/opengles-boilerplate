//
//  GLESSampleAppDelegate.h
//  GLESSample
//
//  Created by Zach Margolis on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface GLESSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glview;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

