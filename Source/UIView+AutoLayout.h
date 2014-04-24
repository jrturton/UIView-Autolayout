//
//  UIView+AutoLayout.h
//  CollectionTableGrid
//
//  Created by Richard Turton on 18/10/2012.

#import <UIKit/UIKit.h>
#import "UIView+AutoLayout-Deprecated.h"

typedef NS_OPTIONS(unsigned long, JRTViewPinEdges){
    JRTViewPinTopEdge = 1 << 0,
    JRTViewPinRightEdge = 1 << 1,
    JRTViewPinBottomEdge = 1 << 2,
    JRTViewPinLeftEdge = 1 << 3,
    JRTViewPinAllEdges = ~0UL
};

@interface UIView (AutoLayout)

/// Return a frameless view that does not automatically use autoresizing (for use in autolayouts)
+(instancetype)autoLayoutView;

/// Centers the receiver in the specified view
-(NSArray *)centerInView:(UIView*)view;

/// Centers the receiver in the superview
-(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis;

/// Pins an attribute to any valid attribute of the peer item. The item may be the layout guide of a view controller. Provide a constant for offset/inset along with a relation.
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant relation:(NSLayoutRelation)relation;

/// Pins an attribute to any valid attribute of the peer item. The item may be the layout guide of a view controller. Provide a constant for offset/inset
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem withConstant:(CGFloat)constant;

/// Pins an attribute to any valid attribute of the peer item. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofItem:(id)peerItem;

/// Pins an attribute to the same attribute of the peer item. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem;

/// Pins an attribute to the same attribute of the peer item. The item may be the layout guide of a view controller. Provide a constant for offset/inset
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfItem:(id)peerItem withConstant:(CGFloat)constant;

/// Pins a view to a specific edge(s) of its superview, with a specified inset
-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset;

/// Pins a view to specific edge(s) of its superview, with a specified inset, using the layout guides of the viewController parameter for top and bottom pinning if appropriate
-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset usingLayoutGuidesFrom:(UIViewController*)viewController;

/// Pins a view to all edges of its superview, with specified edge insets
-(NSArray*)pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets;

/// Pins a views edge(s) to another views edge(s). Both views must be in the same view hierarchy.
-(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView;
-(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView inset:(CGFloat)inset;

/// Set to a specific size. 0 in any axis results in no constraint being applied.
-(NSArray *)constrainToSize:(CGSize)size;

/// Set to a specific width or height.
-(NSLayoutConstraint *)constrainToWidth:(CGFloat)width;
-(NSLayoutConstraint *)constrainToHeight:(CGFloat)height;

// Set minimum and maximum sizes. 0 in any axis results in no constraint in that direction. (e.g. 0 maximumHeight means no max height)
-(NSArray *)constrainToMinimumSize:(CGSize)minimum maximumSize:(CGSize)maximum;

// Set a minimum size. 0 in any axis results in no constraint being applied.
-(NSArray *)constrainToMinimumSize:(CGSize)minimum;

// Set a maximum size. 0 in any axis results in no constraint being applied.
-(NSArray *)constrainToMaximumSize:(CGSize)maximum;

/// Pins a point to a specific point in the superview's frame. Use NSLayoutAttributeNotAnAttribute to only pin in one dimension
-(NSArray*)pinPointAtX:(NSLayoutAttribute)x Y:(NSLayoutAttribute)y toPoint:(CGPoint)point;

/// Spaces the views evenly along the selected axis. Will force the views to the same size to make them fit
-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options;

/// Spaces the views evenly along the selected axis, using their intrinsic size
-(NSArray*)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis;

@end
