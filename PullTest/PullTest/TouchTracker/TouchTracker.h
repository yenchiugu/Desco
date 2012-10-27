
#import <UIKit/UIKit.h>
#import "GeometryUtilities.h"


@interface TouchTracker : UIControl
{
    UIBezierPath *path;
    NSDate *firstTouchDate;
    CGRect region;
    NSTimer *fadeOutTimer;
    float fontAlpha;
    char *letter;
    
    id _target;
    SEL _action;
}

@property(readonly, nonatomic) char *letter;

- (id) initWithFrame:(CGRect)frame andTarget:(id)target action:(SEL)action;

@end