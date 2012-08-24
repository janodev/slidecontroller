
// BSD License. Author: jano@jano.com.es

#import "CenterVC.h"


@implementation CenterVC


-(void) handleBtnLeft:(id)sender {
    [self.navigationController togglePosition];
}


-(void) handleBtnRight:(id)sender {
    [self.navigationController pushViewController:[RightVC new] animated:TRUE];
}


-(void) handleDrag:(UIPanGestureRecognizer *)recognizer
{
    UIView *navView = self.navigationController.view;
    
    static CGFloat originX;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            originX = navView.frame.origin.x;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            // new x coord is the origin + the distance to our fingertip
            CGPoint translation = [recognizer translationInView:navView];
            CGFloat newX = originX + translation.x;
            
            // update only if we are between o and kSlideWidth
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if (newX>0 && newX< (screenWidth-[self.navigationController minimumWidth])){
                CGRect rect = navView.frame;
                rect.origin.x = newX;
                navView.frame = rect;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            // we lifted the finger
            CGPoint translation = [recognizer translationInView:navView];
            CGPoint velocity = [recognizer velocityInView:navView];
            CGFloat inertia = velocity.x * .1; // that's points per second * .1 seconds
            CGFloat finalX = originX + translation.x + inertia;
            // slide to the nearest border
            if (finalX > navView.frame.size.width / 2){
                [self.navigationController slideToPosition:PositionRight withSpeed:velocity.x];
            } else {
                [self.navigationController slideToPosition:PositionLeft withSpeed:velocity.x];
            }
            break;
        }
        default:{
            break;
        }
    }
}


-(void) GUISetup {
    // press to push the right view controller
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Push"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(handleBtnRight:)];
    
    // press to slide the navigation controller
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             // icon stolen from the facebook app
                                             initWithImage:[UIImage imageNamed:@"menu-icon.png"]
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(handleBtnLeft:)];
    
    // gesture recognizer to read drag gestures
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [recognizer setMinimumNumberOfTouches:1];
    [recognizer setMaximumNumberOfTouches:1];
    [self.navigationController.view addGestureRecognizer:recognizer]; // make the whole bar draggable
    
    // insert the left controller as a subview of the navigation controller parent
    self.leftVC = [LeftVC new];
    [self.navigationController.view.superview insertSubview:self.leftVC.view belowSubview:self.navigationController.view];
    
    // nav controller shadow
    CALayer *layer = self.navigationController.view.layer;
    layer.shadowOpacity = 1.0f;
    layer.shadowRadius = 10.0f;
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    // FPS sauce
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationController.view.bounds].CGPath;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self GUISetup];
}

@end
