//
//  GLESSampleAppDelegate.m
//  GLESSample
//
//  Created by Zach Margolis on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GLESSampleAppDelegate.h"
#import "EAGLView.h"
#import "ES1RendererExample.h"
#import "ES2RendererExample.h"


@implementation GLESSampleAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    id<ESRenderer> renderer = [[ES2RendererExample alloc] init];
    
    // on an ES1-only device, renderer will be nil. we check for this case and use the es1 renderer as a backup.
    if (!renderer) {
        renderer = [[ES1RendererExample alloc] init];
    }
    
    glview = [[EAGLView alloc] initWithFrame:self.window.bounds renderer:renderer options:nil];
    [self.window addSubview:glview];

    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
     
    [glview stopAnimation];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */

     [glview stopAnimation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
     
     [glview startAnimation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

    [glview startAnimation];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    
    [glview stopAnimation];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [glview release];
    [super dealloc];
}


@end
