/*
 
 File: ES1Renderer.h
 
*/

#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ES1Renderer : NSObject <ESRenderer>
{
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
}

@property(nonatomic, readonly) EAGLContext *context;

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end
