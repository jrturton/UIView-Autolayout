//
// Created by Liam Nichols on 24/07/13.
// Copyright (c) 2013 Liam Nichols. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainViewController.h"
#import "UIView+AutoLayout.h"

#define ARC4RANDOM_MAX 0x100000000

@interface MainViewController ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *orangeView;

@property(nonatomic, strong) UIView *magentaView;
@end

@implementation MainViewController

- (NSString *)title
{
    return @"Autolayout";
}

- (void)loadView
{
    [super loadView];

    //Load our views
    self.redView = [UIView autoLayoutView];
    self.redView.backgroundColor = [UIColor redColor];

    self.greenView = [UIView autoLayoutView];
    self.greenView.backgroundColor = [UIColor greenColor];

    self.blueView = [UIView autoLayoutView];
    self.blueView.backgroundColor = [UIColor blueColor];

    self.orangeView = [UIView autoLayoutView];
    self.orangeView.backgroundColor = [UIColor orangeColor];
    
    self.magentaView = [UIView autoLayoutView];
    self.magentaView.backgroundColor = [UIColor magentaColor];

    //Add them to their superview
    [self.view addSubview:self.redView];
    [self.redView addSubview:self.greenView];
    [self.redView addSubview:self.blueView];
    [self.greenView addSubview:self.orangeView];
    [self.greenView addSubview:self.magentaView];

    //Constrain our views

    //Constrain a flexible sized view 10pt inset from all edges of superview
    [self.redView pinToSuperviewEdges:JRTViewPinAllEdges inset:10 usingLayoutGuidesFrom:self];

    //Constrain a fixed sized view (100x100) centered on the x axis and 10pts inset from the top of the superview
    [self.greenView constrainToSize:CGSizeMake(100, 100)];
    [self.greenView centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.greenView pinToSuperviewEdges:JRTViewPinTopEdge inset:10];

    //Constrain a fixed width view with a flexible height inset 10pts below greenView and 10pts in from the bottom of its superview
    [self.blueView constrainToSize:CGSizeMake(200, 0)];
    [self.blueView centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.blueView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeBottom ofItem:self.greenView inset:10];
    [self.blueView pinToSuperviewEdges:JRTViewPinBottomEdge inset:10];

    //Constrain multiple child views along the Y axis with 10pt spacing
    NSArray *views = @[ [self randomGreyscaleView], [self randomGreyscaleView], [self randomGreyscaleView], [self randomGreyscaleView] ];
    [self.blueView spaceViews:views onAxis:UILayoutConstraintAxisVertical withSpacing:10 alignmentOptions:0];

    //Pin the top left of a fixed size view (25x25) to a specified point (15x15)
    [self.orangeView constrainToSize:CGSizeMake(25, 25)];
    [self.orangeView pinPointAtX:NSLayoutAttributeLeft Y:NSLayoutAttributeTop toPoint:CGPointMake(15, 15)];

    [self.magentaView pinAttribute:NSLayoutAttributeBottom toSameAttributeOfView:self.orangeView];
    [self.magentaView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeTop ofItem:self.orangeView];
    [self.magentaView pinEdge:NSLayoutAttributeLeft toEdge:NSLayoutAttributeRight ofItem:self.orangeView inset:20.0];
    [self.magentaView constrainToWidth:25.0];

    UIView *pupil = [UIView autoLayoutView];
    pupil.backgroundColor = [UIColor blackColor];
    [self.magentaView addSubview:pupil];
    [pupil constrainToSize:CGSizeMake(10.0, 10.0)];
    [pupil centerInView:self.magentaView];

    UIView *hair = [UIView autoLayoutView];
    hair.backgroundColor = [UIColor yellowColor];
    [self.redView addSubview:hair];
    [hair pinEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.greenView];
    [hair constrainToMinimumSize:CGSizeMake(0.0, 4.0)];
    [hair pinEdge:NSLayoutAttributeBottom toEdge:NSLayoutAttributeTop ofItem:self.greenView inset:-1.0];


}

- (UIView *)randomGreyscaleView
{
    //Get a random value between 0 and 1
    double random = ((double)arc4random() / ARC4RANDOM_MAX);

    //Create a view
    UIView *view = [UIView autoLayoutView];

    //Set the random background color
    [view setBackgroundColor:[UIColor colorWithWhite:random alpha:1]];

    //Add the view to the superview
    [self.blueView addSubview:view];

    //Constrain the width and center on the x axis
    [view constrainToSize:CGSizeMake(150, 0)];
    [view centerInContainerOnAxis:NSLayoutAttributeCenterX];

    //Return the view
    return view;
}

@end