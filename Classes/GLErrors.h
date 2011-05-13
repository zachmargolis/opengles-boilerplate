//
//  GLErrors.h
//  GLESSample
//
//  Created by Zach Margolis on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *GLErrorDomain;

typedef enum {
    GLNoError,
    GLLinkError,
    GLCompileError,
    GLLoadError,
} GLError;

extern NSString *GLLinkErrorDescription;
extern NSString *GLCompileErrorDescription;
extern NSString *GLLoadErrorDescription;
