/*
 
 File: ESRenderer.h

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ES1Renderer : NSObject <ESRenderer>
{
	EAGLContext *context;
    EAGLView *view;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
}

@property(nonatomic, readonly) EAGLContext *context;
@property(nonatomic, assign) EAGLView *view;

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end
