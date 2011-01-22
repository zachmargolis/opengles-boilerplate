/*
 
 File: ESRenderer.h

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

@required
@property(nonatomic, assign) UIView *view;
@property(nonatomic, readonly) EAGLContext *context;
- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer*)layer;

@optional
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end


