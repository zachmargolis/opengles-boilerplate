/*
 
 File: EAGLView.h

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code
*/

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>

#import "ESRenderer.h"


extern NSString *EAGLViewOptionsOpaqueKey;
extern NSString *EAGLViewOptionsDrawablePropertiesKey;

extern NSDictionary *EAGLViewDefaultOptionsTransparent;

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{    
	id <ESRenderer> renderer;
	
	BOOL animating;
	NSInteger animationFrameInterval;

	CADisplayLink *displayLink;
}

@property (nonatomic, readonly, retain) id<ESRenderer> renderer;
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

// an EAGLView must be initialized with a non-nil renderer. options may be nil if defaults are acceptable
- (id)initWithFrame:(CGRect)frame renderer:(id<ESRenderer>)theRenderer options:(NSDictionary *)options;
- (id)initWithRenderer:(id<ESRenderer>)theRenderer options:(NSDictionary *)options;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;

@end