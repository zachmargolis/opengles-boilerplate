//
//  ES2RendererExample.h
//  sig
//
//  Created by Zach Margolis on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ES2Renderer.h"

@interface ES2RendererExample : ES2Renderer {
	/* the shader program object */
	GLuint program;
	
	GLfloat rotz;
}

@end
