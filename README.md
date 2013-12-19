UIView-Autolayout
=================

Category on UIView to simplify the creation of common layout constraints. The code is described and introduced in [this blog post](http://commandshift.co.uk/blog/2013/02/20/creating-individual-layout-constraints/).

The demo project is most of the way towards drawing a robot made of views arranged using all the category methods:

![robot](https://raw.github.com/jrturton/UIView-Autolayout/master/screenshot.png)

Here's the header to save you a click:

```objc
/// Return a frameless view that does not automatically use autoresizing (for use in autolayouts)
+(id)autoLayoutView;

/// Centers the receiver in the superview
-(NSArray *)centerInView:(UIView*)superview;
-(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis;

// Pin an attribute to the same attribute on another view. Both views must be in the same view hierarchy
-(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfView:(UIView *)peerView;

/// Pins a view to a specific edge(s) of its superview, with a specified inset
-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset;
/// Pins a view to specific edge(s) of its superview, with a specified inset, using the layout guides of the viewController parameter for top and bottom pinning if appropriate
-(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset usingLayoutGuidesFrom:(UIViewController*)viewController;

/// Pins a view to all edges of its superview, with specified edge insets
-(NSArray*)pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets;

/// Pins a view's edge to a peer view's edge. Both views must be in the same view hierarchy. Deprecated as of iOS7 to allow for layout guides instead.
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView __deprecated;
/// Pins a view's edge to a peer view's edge, with an inset. Both views must be in the same view hierarchy. Deprecated as of iOS7 to allow for layout guides instead.
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)peerView inset:(CGFloat)inset __deprecated;

/// Pins a view's edge to a peer item's edge. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem;
/// Pins a view's edge to a peer item's edge, with an inset. The item may be the layout guide of a view controller
-(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofItem:(id)peerItem inset:(CGFloat)inset;

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
-(void)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options;
```

See the AutoLayoutDemo project for example usage.
