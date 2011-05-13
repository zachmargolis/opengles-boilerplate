/*
 
 File: ES2RendererExample.h

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import <Foundation/Foundation.h>
#import "ES2Renderer.h"

@interface ES2RendererExample : ES2Renderer {
    /* the shader program object */
    GLuint shader;
    
    GLfloat rotz;
}

@end
