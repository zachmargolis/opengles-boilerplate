/*
 
 File: EAGLView.m
 
*/

#import "EAGLView.h"





NSString *EAGLViewOptionsOpaqueKey = @"EAGLViewOptionsOpaqueKey";
NSString *EAGLViewOptionsDrawablePropertiesKey = @"EAGLViewOptionsDrawablePropertiesKey";

NSDictionary *EAGLViewDefaultDrawableProperties = nil;
NSDictionary *EAGLViewDefaultOptionsTransparent = nil;



@interface EAGLView ()
@property(nonatomic, readwrite, retain) id<ESRenderer> renderer;
- (id)_initHelper:(id<ESRenderer>)renderer options:(NSDictionary *)options;
@end




@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;
@synthesize renderer;


#pragma mark Static Methods

// You must implement this method
+ (Class) layerClass;
{
    return [CAEAGLLayer class];
}

+ (void)initialize;
{
    // Prepare default options
    EAGLViewDefaultDrawableProperties = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    EAGLViewDefaultOptionsTransparent = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], EAGLViewOptionsOpaqueKey, nil];
}

#pragma mark Initialization


- (id)initWithFrame:(CGRect)frame renderer:(id <ESRenderer>)theRenderer options:(NSDictionary *)options;
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    return (self = [self _initHelper:theRenderer options:options]);
}

- (id)initWithRenderer:(id <ESRenderer>)theRenderer options:(NSDictionary *)options;
{    
    if (!(self = [super init])) {
        return nil;
    }
    
    return (self = [self _initHelper:theRenderer options:options]);
}

- (id)_initHelper:(id<ESRenderer>)theRenderer options:(NSDictionary *)options;
{
    // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

    // set up the layer with options passed in (if there are any)

    NSNumber *opaqueOption = [options objectForKey:EAGLViewOptionsOpaqueKey];
    if (opaqueOption) {
        eaglLayer.opaque = [opaqueOption boolValue];
    } else {
        eaglLayer.opaque = YES; // defaults to opaque
    }

    NSDictionary *drawablePropertiesOption = [options objectForKey:EAGLViewOptionsDrawablePropertiesKey];
    if (drawablePropertiesOption) {
        eaglLayer.drawableProperties = drawablePropertiesOption;
    } else {
        eaglLayer.drawableProperties = EAGLViewDefaultDrawableProperties;
    }

    
    
    if (theRenderer) {
        self.renderer = theRenderer;
    } else {
        [self release];
        return nil;
    }
    
    animating = NO;
    animationFrameInterval = 1;
    displayLink = nil;
    
    return self;
}

- (void) dealloc;
{
    [self.renderer release];
	
    [super dealloc];
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ([self.renderer respondsToSelector:@selector(touchesBegan:withEvent:)]) {
        [self.renderer touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ([self.renderer respondsToSelector:@selector(touchesMoved:withEvent:)]) {
        [self.renderer touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ([self.renderer respondsToSelector:@selector(touchesEnded:withEvent:)]) {
        [self.renderer touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ([self.renderer respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
        [self.renderer touchesCancelled:touches withEvent:event];
    }
}

#pragma mark UIView

- (void) layoutSubviews;
{
	[self.renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

#pragma mark Drawing and Animating

- (void) drawView:(id)sender;
{
    [self.renderer render];
}

- (void) startAnimation;
{
	if (!animating) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [displayLink setFrameInterval:animationFrameInterval];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
        animating = YES;
	}
}

- (void)stopAnimation;
{
	if (animating) {
        [displayLink invalidate];
        displayLink = nil;
		
		animating = NO;
	}
}


#pragma mark Properties

- (void) setAnimationFrameInterval:(NSInteger)frameInterval;
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1) {
		animationFrameInterval = frameInterval;
		
		if (animating) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

@end