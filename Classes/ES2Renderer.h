/*
 
 File: ES2Renderer.h

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import "ESRenderer.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "EAGLView.h"

@interface ES2Renderer : NSObject <ESRenderer>
{
@private
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

- (BOOL)loadShaders;
- (void)deleteShaders;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end

