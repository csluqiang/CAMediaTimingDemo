//
//  ViewController.m
//  CAMediaTimingDemo
//
//  Created by renren on 16/5/9.
//  Copyright © 2016年 lasso. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeOffsetLabel;
@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UISlider *timeOffsetSlider;
@property (nonatomic, weak) IBOutlet UIButton *palyButton;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //create a path
    self.bezierPath = [[UIBezierPath alloc] init];
    [self.bezierPath moveToPoint:CGPointMake(40, 150)];
    [self.bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = self.bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(30, 0, 64, 64);
    self.shipLayer.position = CGPointMake(40, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"image"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
    //set initial values
    [self updateSliders];
}

- (IBAction)updateSliders
{
    CFTimeInterval timeOffset = self.timeOffsetSlider.value;
    self.timeOffsetLabel.text = [NSString stringWithFormat:@"%0.2f", timeOffset];
    float speed = self.speedSlider.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%0.2f", speed];
    
}

- (IBAction)play
{
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.timeOffset = self.timeOffsetSlider.value;
    animation.speed = self.speedSlider.value;
    animation.duration = 5.0;
    animation.path = self.bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.shipLayer addAnimation:animation forKey:@"slide"];
}

- (IBAction)pause:(id)sender
{
    CALayer *layer = self.shipLayer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}

- (IBAction)resume:(id)sender
{
    CALayer *layer = self.shipLayer;
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1;
    layer.timeOffset = 0;
    layer.beginTime = 0;
    layer.beginTime = [self.shipLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    
}


@end
