//
//  AboutViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/24/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//


#import "AboutViewController.h"
#import "NSObject+Utilities.h"
#import "MFSideMenu.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define P(x,y) CGPointMake(x, y)


@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
 //   self.view.backgroundColor = [UIColor greenColor];
    
	UIBezierPath *trackPath = [UIBezierPath bezierPath];
	[trackPath moveToPoint:P(160, 280)];
    
	[trackPath addCurveToPoint:P(300, 120)
				 controlPoint1:P(320, 0)
				 controlPoint2:P(300, 80)];
    
	[trackPath addCurveToPoint:P(80, 380)
				 controlPoint1:P(300, 200)
				 controlPoint2:P(200, 480)];

	[trackPath addCurveToPoint:P(160, 280)
				 controlPoint1:P(0, 160)
				 controlPoint2:P(0, 40)];
    
    
	CAShapeLayer *racetrack = [CAShapeLayer layer];
	racetrack.path = trackPath.CGPath;
	racetrack.strokeColor = [UIColor blackColor].CGColor;
	racetrack.fillColor = [UIColor clearColor].CGColor;
	racetrack.lineWidth = 30.0;
	[self.view.layer addSublayer:racetrack];
    
	CAShapeLayer *centerline = [CAShapeLayer layer];
	centerline.path = trackPath.CGPath;
	centerline.strokeColor = [UIColor whiteColor].CGColor;
	centerline.fillColor = [UIColor clearColor].CGColor;
	centerline.lineWidth = 2.0;
	centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2], nil];
	[self.view.layer addSublayer:centerline];
	
	CALayer *car = [CALayer layer];
	car.bounds = CGRectMake(20, 160, 60.0, 49.0);
	car.position = P(20, 160);
	car.contents = (id)([UIImage imageNamed:@"MyTortoise.png"].CGImage);
	[self.view.layer addSublayer:car];
	
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.path = trackPath.CGPath;
	anim.rotationMode = kCAAnimationRotateAuto;
	anim.repeatCount = HUGE_VALF;
	anim.duration = 8.0;
	[car addAnimation:anim forKey:@"race"];
//
//    
//    UIButton* websiteLink = [[UIButton alloc] initWithFrame:CGRectMake(170, 120, 100, 100)];
//    websiteLink.titleLabel.text = @"source.vn";
//    
//    [self.view addSubview:websiteLink];

}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
   
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        
    }
    else
    {
        
    }

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)linkToWebsite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.source.vn"]];
}

@end
