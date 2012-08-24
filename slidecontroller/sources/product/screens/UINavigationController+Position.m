
// BSD License. author: jano@jano.com.es

#import "UINavigationController+Position.h"

// 640 points per second (that's 320 in 0.5 seconds)
const NSInteger kVelocity = 640;


@implementation UINavigationController (Position)


// what width of the controller remains visible when slid
-(CGFloat) minimumWidth {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return floorf(screenWidth * .2);
}


// animate the navigation controller sideways
-(void) setVisibility:(Position)position {
    [self slideToPosition:position withSpeed:kVelocity];
}


// animate the navigation controller sideways
-(void) slideToPosition:(Position)position withSpeed:(CGFloat)velocity
{
    // use a minimum of kVelocity
    if (velocity<kVelocity) velocity = kVelocity;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat startX = self.view.frame.origin.x;
    CGFloat endX = position ? screenWidth - self.minimumWidth : 0;
    
    // time to slide from 'startX' to 'endX' with the given velocity
    CGFloat time = fabs((startX - endX) / velocity);
    
    CGRect newRect = self.view.frame;
    newRect.origin.x = endX;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        self.view.frame = newRect;
    } completion:^(BOOL finished) {}];
}


// toggle the visibility of this controller
-(void) togglePosition {
    Position inverse = ([self visibility]==PositionLeft) ? PositionRight : PositionLeft;
    [self setVisibility:inverse];
}


// tell whether the controller is partially or fully visible
-(Position) visibility {
    return self.view.frame.origin.x==0 ? PositionLeft : PositionRight;
}


@end
