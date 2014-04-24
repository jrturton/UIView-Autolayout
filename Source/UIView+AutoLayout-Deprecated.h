//
//  UIView+AutoLayout-Deprecated.h
//
//  Created by Liam Nichols on 24/04/2014.

@interface UIView (AutoLayoutDeprecated)

// Pin an attribute to the same attribute on another view. Both views must be in the same view hierarchy
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfView:(UIView *)peerView DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toSameAttributeOfItem: instead");


/// Pins a view's edge to a peer view's edge. Both views must be in the same view hierarchy. Deprecated as of iOS7 to allow for layout guides instead.
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toAttribute:ofItem: instead");

/// Pins a view's edge to a peer view's edge, with an inset. Both views must be in the same view hierarchy. Deprecated as of iOS7 to allow for layout guides instead.
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)peerView inset:(CGFloat)inset DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toAttribute:ofItem:withConstant: instead");



/// Pins a view's edge to a peer item's edge. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toAttribute:ofItem instead");

/// Pins a view's edge to a peer item's edge, with an inset. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem inset:(CGFloat)inset DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toAttribute:ofItem:withConstant: instead");

/// Pins a view's edge to a peer item's edge, with an inset and a specific relationtype. The item may be the layout guide of a view controller.
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem inset:(CGFloat)inset relation:(NSLayoutRelation)relation DEPRECATED_MSG_ATTRIBUTE("use pinAttribute:toAttribute:ofItem:withConstant:relation: instead");

@end