//
//  UITouch-EAGLAdditions.h
//  GLESSample
//
//  Created by Zach Margolis on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EAGLView;

@interface UITouch (EAGLAdditions)

- (CGPoint)locationInEAGLView:(EAGLView *)aView;

@end
