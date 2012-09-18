
#import "TouchTracker.h"

#define TRACE_COLOR     [UIColor colorWithRed:0.4f green:0.7f blue:0.7f alpha:7.5f]
#define TRACE_WIDTH     (15.0f)
//#define ECHO_COLOR      [UIColor colorWithRed:0.4f green:0.4f blue:0.7f alpha:1.0f]
//#define ECHO_WIDTH      (10.0f)

@implementation TouchTracker

@synthesize letter;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
        _target = target;
        _action = action;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    path = [UIBezierPath bezierPath];
    path.lineWidth = TRACE_WIDTH;
    
    UITouch *touch = [touches anyObject];
    [path moveToPoint:[touch locationInView:self]];
    if (fadeOutTimer != nil) {
        [fadeOutTimer invalidate];
    }
    fontAlpha = 1.0f;
    region = CGRectZero;
    firstTouchDate = [NSDate date];
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    NSArray *points = pointsFromBezierPath(path);
    CGRect newRegion = testForLetterO(points, firstTouchDate);
    if (newRegion.size.width > 100.0f || newRegion.size.height > 100.0f) {
        region = newRegion;
        letter = guessLetter(points);
    }
    [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    NSArray *points = pointsFromBezierPath(path);
    CGRect newRegion = testForLetterO(points, firstTouchDate);
    if (newRegion.size.width > 100.0f || newRegion.size.height > 100.0f) {
        region = newRegion;
        letter = guessLetter(points);
    }
    path = nil;
    fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/15.0f target:self selector:@selector(fadeOutFont:) userInfo:nil repeats:YES];
    [self setNeedsDisplay];
    if (!CGRectEqualToRect(CGRectZero, region)) {
        [_target performSelector:_action withObject:self];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void) fadeOutFont:(NSTimer *)theTimer {
    fontAlpha -= 0.03f;
    if (fontAlpha <= 0.0f) {
        region = CGRectZero;
        fontAlpha = 1.0f;
        [theTimer invalidate];
    }
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    if (path != nil) {
        [TRACE_COLOR set];
        [path stroke];
    }

    if (!CGRectEqualToRect(CGRectZero, region))
    {
        /*
        [ECHO_COLOR set];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circle];
        circlePath.lineWidth = ECHO_WIDTH;
        [circlePath stroke];
        
        CGRect cb1 = rectAroundCenter(getRectUpperCenter(circle), 4.0f, 4.0f);
        UIBezierPath *cp1 = [UIBezierPath bezierPathWithOvalInRect:cb1];
        [cp1 fill];
        
        CGRect cb2 = rectAroundCenter(getRectLowerCenter(circle), 4.0f, 4.0f);
        UIBezierPath *cp2 = [UIBezierPath bezierPathWithOvalInRect:cb2];
        [cp2 fill];
         */
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        int fontSize = region.size.height * 1.6f;
        CGContextSelectFont(context, [[UIFont boldSystemFontOfSize:24].fontName UTF8String], (int)fontSize, kCGEncodingMacRoman);
        //CGContextSetTextDrawingMode(context, kCGTextFillStroke);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        //CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.8f);
        CGContextSetRGBFillColor(context, 0.3f, 0.6f, 0.6f, fontAlpha);
        //CGContextSetRGBFillColor(context, 1.0f, 0.5f, 0.5f, fontAlpha);
        CGContextSetLineWidth(context, 1);
        CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGAffineTransform scale = CGAffineTransformScale(xform, region.size.width / region.size.height, 1.0f);
        CGContextSetTextMatrix(context, scale);
        CGContextShowTextAtPoint(context, region.origin.x - 10, region.origin.y + region.size.height, letter, 1);
    }
}
@end
