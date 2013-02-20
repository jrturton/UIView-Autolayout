//
//  UIView+AutoLayout.h
//  CollectionTableGrid
//
//  Created by Richard Turton on 18/10/2012.
//  Copyright (c) 2012 Richard Turton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(unsigned long, JRTViewPinEdges){
    JRTViewPinTopEdge = 1 << 0,
    JRTViewPinRightEdge = 1 << 1,
    JRTViewPinBottomEdge = 1 << 2,
    JRTViewPinLeftEdge = 1 << 3,
    JRTViewPinAllEdges = ~0UL
};

@interface UIView (AutoLayout)
/// Return a frameless view that does not automatically use autoresizing (for use in autolayouts)
+(id)autoLayoutView;

/// Centers the receiver in the superview
-(void)centerInView:(UIView*)superview;
-(void)centerInContainerOnAxis:(NSLayoutAttribute)axis;

/// Pins a view to a specific edge(s) of its superview, with a specified inset
-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset;

/// Pins a view's edge to a peer view's edge
-(void)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView;
-(void)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView inset:(CGFloat)inset;

/// Set to a specific size. 0 in any axis results in no constraint being applied.
-(void)constrainToSize:(CGSize)size;

@end
