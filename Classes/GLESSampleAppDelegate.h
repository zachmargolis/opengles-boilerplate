/*
 
 File: GLESSampleAppDelegate.h

 Created by Zach Margolis on 1/22/10

*/

#import <UIKit/UIKit.h>

@class EAGLView;

@interface GLESSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glview;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

