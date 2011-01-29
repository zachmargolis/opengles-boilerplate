//
//  UITouch-EAGLAdditions.m
//  GLESSample
//
//  Created by Zach Margolis on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITouch-EAGLAdditions.h"
#import "EAGLView.h"

@implementation UITouch (EAGLAdditions)

- (CGPoint)locationInEAGLView:(EAGLView *)aView;
{
    // get the location in Cocoa coordinates
    CGPoint quartzLocation = [self locationInView:aView];
    
    // flip the y-coordinate for GL coordinates
    quartzLocation.y = aView.bounds.size.height - quartzLocation.y;

    return quartzLocation;
}

@end
