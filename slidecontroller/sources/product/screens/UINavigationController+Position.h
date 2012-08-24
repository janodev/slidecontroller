
// BSD License. author: jano@jano.com.es

#import <objc/runtime.h>

typedef enum {
    PositionLeft,
    PositionRight
} Position;


@interface UINavigationController (Position)

-(void) togglePosition;
-(void) slideToPosition:(Position)position withSpeed:(CGFloat)velocity;
-(CGFloat) minimumWidth;

@end
