/*
 
 File: ES2Renderer.m

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import "ES2Renderer.h"
#import "GLErrors.h"

@interface ES2Renderer (PrivateMethods)

- (void)createFramebuffer;
- (void)deleteFramebuffer;

- (GLuint)_compileShaderOfType:(GLenum)type fromFiles:(NSArray *)fileNames error:(NSError **)error;
- (GLint)_linkProgram:(GLuint)program error:(NSError **)error;
- (GLint)_validateProgram:(GLuint)program error:(NSError **)error;

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

- (GLuint)buildShaderProgramWithVertexShaders:(NSArray *)vertexShaderFileNames andFragmentShaders:(NSArray *)fragmentShaderFileNames error:(NSError **)error attributeBlock:(void (^)(GLuint program))attributeBlock uniformBlock:(void (^)(GLuint program))uniformBlock;
{
    GLuint vertexShader, fragmentShader, program;
    
    program = glCreateProgram();
    
    vertexShader = [self _compileShaderOfType:GL_VERTEX_SHADER fromFiles:vertexShaderFileNames error:error];
    if (!vertexShader) {
        return 0;
    }
    
    fragmentShader = [self _compileShaderOfType:GL_FRAGMENT_SHADER fromFiles:fragmentShaderFileNames error:error];
    if (!fragmentShader) {
        return 0;
    }
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // bind atttribute locations
    // must happen before linking
    attributeBlock(program);
    
    
    if (![self _linkProgram:program error:error]) {
        return 0;
    }

    // bind uniform locations
    uniformBlock(program);

    // successfully linked shader
    return program;
}

- (void)deleteShaderProgram:(GLint)shader;
{
    if (shader) {
        glDeleteProgram(shader);
    }
}

#pragma mark Private Methods

- (GLuint)_compileShaderOfType:(GLenum)type fromFiles:(NSArray *)fileNames error:(NSError **)error;
{
    GLuint shader;
    
    // TODO: document "vsh" and "fsh" as the filenames
    NSString *fileType = type == GL_VERTEX_SHADER ? @"vsh" : @"fsh";
    

    NSInteger numberOfFiles = [fileNames count];
    const GLchar *sources[numberOfFiles];
    
    for (NSUInteger file = 0; file < numberOfFiles; file++) {
        NSString *location = [[NSBundle mainBundle] pathForResource:[fileNames objectAtIndex:file] ofType:fileType];
        sources[file] = (GLchar *) [[NSString stringWithContentsOfFile:location encoding:NSUTF8StringEncoding error:error] UTF8String];
        if (!sources[file]) {
            return 0;
        }
    }
    
    shader = glCreateShader(type);
    glShaderSource(shader, numberOfFiles, sources, NULL);
    glCompileShader(shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
        return 0;
    }
#endif

    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE)
    {
        NSLog(@"Failed to compile shader:\n");
        for (int i = 0; i < numberOfFiles; i++) {
            NSLog(@"%s", sources[i]);
        }
        return 0;
    }

    return shader;
}

- (GLint)_linkProgram:(GLuint)program error:(NSError **)error;
{
    GLint status;
    
    glLinkProgram(program);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE && error) {
        *error = [NSError errorWithDomain:GLErrorDomain code:GLLinkError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:GLLinkErrorDescription, NSLocalizedDescriptionKey, nil]];
        NSLog(@"Failed to link program %d", program);
    }
    
    return status;
}

- (GLint)_validateProgram:(GLuint)program error:(NSError **)error;
{
    GLint logLength, status;
    
    glValidateProgram(program);
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(program, GL_VALIDATE_STATUS, &status);
    if (status == GL_FALSE) {
        NSLog(@"Failed to validate program %d", program);
    }
    
    return status;
}

@end
