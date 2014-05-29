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
@property (nonatomic, strong) UIView *head;
@property (nonatomic, strong) UIView *body;
@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;
@property (nonatomic, strong) UIView *rightPupil;
@property (nonatomic, strong) UIView *hair;
@property (nonatomic, strong) UIView *leftArm;

@end

@implementation MainViewController

- (NSString *)title
{
    return @"Autolayout";
}

- (void)loadView
{
    [super loadView];

    /// Pins a view to all the edges in of its superview. It also takes into account iOS7's UILayoutSupport (layout guides).
    [self loadRedView];

    /// Constrains a view to a specific size and centering itself within its superview on a specified axis.
    [self loadHead];

    /// Constrains to a specific width, centers on the X axis, pins the top to the bottom of a sibling view and to the bottom of its superview to give a flexible width.
    [self loadBody];

    /// Evenly spaces views on the vertical axis with a fixed amount of spacing between each view.
    [self evenlySpaceViewsOnBodyWithFixedSpacing];

    /// Pins a specified part of a view to a specific point in its superview and constrains to a fixed size.
    [self loadLeftEye];

    /// Pins to specific attributes of itself to the same attributes of another view, pins itself to the right of a neighbour view with a specific constant.
    [self loadRightEye];

    /// Centers a view inside another view what is not necessarily its superview.
    [self loadRightPupil];

    /// Constrains to a minimum size along with pining edges to the same edges of another view.
    [self loadHair];

    /// Pins an attribute to the same attribute of another view but with an additional inset and constraints to a specific size.
    [self loadLeftArm];

    /// Evenly spaces views on the vertical axis while maintaining the fixed height for each view (by applying even padding).
    [self evenlySpaceViewsOnArmWithFixedSize];
}

- (void)loadRedView
{
    self.redView = [UIView autoLayoutView];
    self.redView.backgroundColor = [UIColor redColor];

    [self.view addSubview:self.redView];

    //Constrain a flexible sized view 10pt inset from all edges of superview
    [self.redView pinToSuperviewEdges:JRTViewPinAllEdges inset:10.0 usingLayoutGuidesFrom:self];
}

- (void)loadHead
{
    self.head = [UIView autoLayoutView];
    self.head.backgroundColor = [UIColor greenColor];

    [self.redView addSubview:self.head];

    //Constrain a fixed sized view (100x100) centered on the x axis and 10pts inset from the top of the superview
    [self.head constrainToSize:CGSizeMake(100.0, 100.0)];
    [self.head centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.head pinToSuperviewEdges:JRTViewPinTopEdge inset:10.0];
}

- (void)loadBody
{
    self.body = [UIView autoLayoutView];
    self.body.backgroundColor = [UIColor blueColor];

    [self.redView addSubview:self.body];

    //Constrain a fixed width view with a flexible height inset 10pts below the head and 10pts in from the bottom of its superview
    [self.body constrainToWidth:200.0];
    [self.body centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.body pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.head withConstant:10.0];
    [self.body pinToSuperviewEdges:JRTViewPinBottomEdge inset:10.0];
}

- (void)evenlySpaceViewsOnBodyWithFixedSpacing
{
    //Constrain multiple child views along the Y axis with 10pt spacing
    NSArray *views = @[ [self randomGreyscaleView], [self randomGreyscaleView], [self randomGreyscaleView], [self randomGreyscaleView] ];
    [self.body spaceViews:views onAxis:UILayoutConstraintAxisVertical withSpacing:10 alignmentOptions:0];
}

- (void)loadLeftEye
{
    self.leftEye = [UIView autoLayoutView];
    self.leftEye.backgroundColor = [UIColor orangeColor];

    [self.head addSubview:self.leftEye];

    //Pin the top left of a fixed size view (25x25) to a specified point (15x15)
    [self.leftEye constrainToSize:CGSizeMake(25.0, 25.0)];
    [self.leftEye pinPointAtX:NSLayoutAttributeLeft Y:NSLayoutAttributeTop toPoint:CGPointMake(15.0, 15.0)];
}

- (void)loadRightEye
{
    self.rightEye = [UIView autoLayoutView];
    self.rightEye.backgroundColor = [UIColor magentaColor];

    [self.head addSubview:self.rightEye];

    [self.rightEye pinAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeRight ofItem:self.leftEye withConstant:20.0];
    [self.rightEye constrainToWidth:25.0];
    //pinning to the same attributes of a certain view can be achieved in different ways:
    [self.rightEye pinAttribute:NSLayoutAttributeBottom toSameAttributeOfItem:self.leftEye];
    [self.rightEye pinEdges:JRTViewPinTopEdge toSameEdgesOfView:self.leftEye];
}

- (void)loadRightPupil
{
    self.rightPupil = [UIView autoLayoutView];
    self.rightPupil.backgroundColor = [UIColor blackColor];

    [self.head addSubview:self.rightPupil];

    [self.rightPupil constrainToSize:CGSizeMake(10.0, 10.0)];
    [self.rightPupil centerInView:self.rightEye];
}

- (void)loadHair
{
    self.hair = [UIView autoLayoutView];
    self.hair.backgroundColor = [UIColor yellowColor];

    [self.redView addSubview:self.hair];

    [self.hair pinEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.head];
    [self.hair constrainToMinimumSize:CGSizeMake(0.0, 4.0)];
    [self.hair pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofItem:self.head withConstant:-1.0];
}

- (void)loadLeftArm
{
    self.leftArm = [UIView autoLayoutView];
    self.leftArm.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.leftArm];

    [self.leftArm pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeft ofItem:self.body withConstant:-10.0];
    [self.leftArm pinAttribute:NSLayoutAttributeTop toSameAttributeOfItem:self.body withConstant:10.0];
    [self.leftArm constrainToSize:CGSizeMake(20.0, 200.0)];
}

- (void)evenlySpaceViewsOnArmWithFixedSize
{
    NSMutableArray *tiles = [NSMutableArray new];
    for (int i = 0; i < 5; i++)
    {
        UIView *panel = [UIView autoLayoutView];
        panel.backgroundColor = [UIColor blackColor];

        [self.leftArm addSubview:panel];

        [panel constrainToSize:CGSizeMake(10.0, 10.0 + (i * 2.0))];
        [panel centerInContainerOnAxis:NSLayoutAttributeCenterX];

        [tiles addObject:panel];
    }
    [self.leftArm spaceViews:tiles onAxis:UILayoutConstraintAxisVertical];
}

#pragma mark -

- (UIView *)randomGreyscaleView
{
    //Get a random value between 0 and 1
    double random = ((double)arc4random() / ARC4RANDOM_MAX);

    //Create a view
    UIView *view = [UIView autoLayoutView];

    //Set the random background color
    [view setBackgroundColor:[UIColor colorWithWhite:random alpha:1]];

    //Add the view to the superview
    [self.body addSubview:view];

    //Constrain the width and center on the x axis
    [view constrainToSize:CGSizeMake(150.0, 0.0)];
    [view centerInContainerOnAxis:NSLayoutAttributeCenterX];

    //Return the view
    return view;
}

@end