//
//  MainView.m
//  AutoLayoutDemo
//
//  Created by Vanderlei Martinelli on 18/07/14.
//
//  Ported from iOS code by Liam Nichols.
//

#import "MainView.h"
#import "JRTView+JRTAutoLayout.h"

#define ARC4RANDOM_MAX 0x100000000

@interface MainView ()

@property (nonatomic, strong) NSView *redView;
@property (nonatomic, strong) NSView *head;
@property (nonatomic, strong) NSView *body;
@property (nonatomic, strong) NSView *leftEye;
@property (nonatomic, strong) NSView *rightEye;
@property (nonatomic, strong) NSView *rightPupil;
@property (nonatomic, strong) NSView *hair;
@property (nonatomic, strong) NSView *leftArm;


@end

@implementation MainView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    
    //
    [self pinToSuperviewEdges:(JRTViewPinTopEdge) inset:22];
    [self pinToSuperviewEdges:(JRTViewPinLeftEdge | JRTViewPinRightEdge | JRTViewPinBottomEdge) inset:0];
    [self constrainToMinimumSize:CGSizeMake(320.0f, 400.0f)];
    
    /// Pins a view to all the edges in of its superview.
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
    self.redView = [NSView autoLayoutView];
    self.redView.wantsLayer = YES;
    self.redView.layer.backgroundColor = [[NSColor redColor] CGColor];
    
    [self addSubview:self.redView];
    
    //Constrain a flexible sized view 10pt inset from all edges of superview
    [self.redView pinToSuperviewEdges:JRTViewPinAllEdges inset:10.0];
}

- (void)loadHead
{
    self.head = [NSView autoLayoutView];
    self.head.wantsLayer = YES;
    self.head.layer.backgroundColor = [[NSColor greenColor] CGColor];
    
    [self.redView addSubview:self.head];
    
    //Constrain a fixed sized view (100x100) centered on the x axis and 10pts inset from the top of the superview
    [self.head constrainToSize:CGSizeMake(100.0, 100.0)];
    [self.head centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [self.head pinToSuperviewEdges:JRTViewPinTopEdge inset:10.0];
}

- (void)loadBody
{
    self.body = [NSView autoLayoutView];
    self.body.wantsLayer = YES;
    self.body.layer.backgroundColor = [NSColor blueColor].CGColor;
    
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
    [self.body spaceViews:views onAxis:JRTLayoutConstraintAxisVertical withSpacing:10 alignmentOptions:0];
}

- (void)loadLeftEye
{
    self.leftEye = [NSView autoLayoutView];
    self.leftEye.wantsLayer = YES;
    self.leftEye.layer.backgroundColor = [[NSColor orangeColor] CGColor];
    
    [self.head addSubview:self.leftEye];
    
    //Pin the top left of a fixed size view (25x25) to a specified point (15x15)
    [self.leftEye constrainToSize:CGSizeMake(25.0, 25.0)];
    [self.leftEye pinPointAtX:NSLayoutAttributeLeft Y:NSLayoutAttributeTop toPoint:CGPointMake(15.0, 15.0)];
}

- (void)loadRightEye
{
    self.rightEye = [NSView autoLayoutView];
    self.rightEye.wantsLayer = YES;
    self.rightEye.layer.backgroundColor = [[NSColor magentaColor] CGColor];
    
    [self.head addSubview:self.rightEye];
    
    [self.rightEye pinAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeRight ofItem:self.leftEye withConstant:20.0];
    [self.rightEye constrainToWidth:25.0];
    //pinning to the same attributes of a certain view can be achieved in different ways:
    [self.rightEye pinAttribute:NSLayoutAttributeBottom toSameAttributeOfItem:self.leftEye];
    [self.rightEye pinEdges:JRTViewPinTopEdge toSameEdgesOfView:self.leftEye];
}

- (void)loadRightPupil
{
    self.rightPupil = [NSView autoLayoutView];
    self.rightPupil.wantsLayer = YES;
    self.rightPupil.layer.backgroundColor = [[NSColor blackColor] CGColor];
    
    [self.head addSubview:self.rightPupil];
    
    [self.rightPupil constrainToSize:CGSizeMake(10.0, 10.0)];
    [self.rightPupil centerInView:self.rightEye];
}

- (void)loadHair
{
    self.hair = [NSView autoLayoutView];
    self.hair.wantsLayer = YES;
    self.hair.layer.backgroundColor = [[NSColor yellowColor] CGColor];
    
    [self.redView addSubview:self.hair];
    
    [self.hair pinEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.head];
    [self.hair constrainToMinimumSize:CGSizeMake(0.0, 4.0)];
    [self.hair pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofItem:self.head withConstant:-1.0];
}

- (void)loadLeftArm
{
    self.leftArm = [NSView autoLayoutView];
    self.leftArm.wantsLayer = YES;
    self.leftArm.layer.backgroundColor = [[NSColor grayColor] CGColor];
    
    [self addSubview:self.leftArm positioned:NSWindowAbove relativeTo:self.body];
    
    [self.leftArm pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeft ofItem:self.body withConstant:-10.0];
    [self.leftArm pinAttribute:NSLayoutAttributeTop toSameAttributeOfItem:self.body withConstant:10.0];
    [self.leftArm constrainToSize:CGSizeMake(20.0, 200.0)];
}

- (void)evenlySpaceViewsOnArmWithFixedSize
{
    NSMutableArray *tiles = [NSMutableArray new];
    for (int i = 0; i < 5; i++)
    {
        NSView *panel = [NSView autoLayoutView];
        panel.wantsLayer = YES;
        panel.layer.backgroundColor = [[NSColor blackColor] CGColor];
        
        [self.leftArm addSubview:panel];
        
        [panel constrainToSize:CGSizeMake(10.0, 10.0 + (i * 2.0))];
        [panel centerInContainerOnAxis:NSLayoutAttributeCenterX];
        
        [tiles addObject:panel];
    }
    [self.leftArm spaceViews:tiles onAxis:JRTLayoutConstraintAxisVertical];
}

#pragma mark -

- (NSView *)randomGreyscaleView
{
    //Get a random value between 0 and 1
    double random = ((double)arc4random() / ARC4RANDOM_MAX);
    
    //Create a view
    NSView *view = [NSView autoLayoutView];
    
    //Set the random background color
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor colorWithWhite:random alpha:1] CGColor];
    
    //Add the view to the superview
    [self.body addSubview:view];
    
    //Constrain the width and center on the x axis
    [view constrainToSize:CGSizeMake(150.0, 0.0)];
    [view centerInContainerOnAxis:NSLayoutAttributeCenterX];
    
    //Return the view
    return view;
}

@end
