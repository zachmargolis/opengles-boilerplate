/*
 
 File: ES2Renderer.m

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import "ES2Renderer.h"

@interface ES2Renderer (PrivateMethods)
- (void)createFramebuffer;
- (void)deleteFramebuffer;
@end

@implementation ES2Renderer

@synthesize view;
@synthesize context;

#pragma mark Initialization

// Create an ES 2.0 context
- (id <ESRenderer>) init;
{
    if (!(self = [super init])) {
        return nil;
    }
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!context || ![EAGLContext setCurrentContext:context] || ![self loadShaders]) {
        [self release];
        return nil;
    }
    
    [self createFramebuffer];

    return self;
}

- (void) dealloc;
{
    // tear down GL
    [self deleteFramebuffer];
    [self deleteShaders];

    // tear down context
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];
    context = nil;
    
    [super dealloc];
}

#pragma mark Rendering

- (void)render;
{
    // Replace the implementation of this method to do your own custom drawing
    [self setFramebuffer];
    [self presentFramebuffer];
}

#pragma mark Framebuffer Methods

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    return YES;
}

- (void)createFramebuffer;
{
    // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
    glGenFramebuffers(1, &defaultFramebuffer);
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
}

- (void)deleteFramebuffer;
{
    if (defaultFramebuffer) {
        glDeleteFramebuffers(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
    
    if (colorRenderbuffer) {
        glDeleteRenderbuffers(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
}

- (void)setFramebuffer;
{
    [EAGLContext setCurrentContext:context];
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
}

- (BOOL)presentFramebuffer;
{
    [EAGLContext setCurrentContext:context];        
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    return [context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark Shader Methods

- (BOOL)loadShaders;
{
    return YES;
}

- (void)deleteShaders;
{
}

@end
