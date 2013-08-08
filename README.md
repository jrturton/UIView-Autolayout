UIView-Autolayout
=================

Category on UIView to simplify the creation of common layout constraints. The code is described and introduced in [this blog post](http://commandshift.co.uk/blog/2013/02/20/creating-individual-layout-constraints/).

Here's the header to save you a click:

    /// Return a frameless view that does not automatically use autoresizing (for use in autolayouts)
    +(id)autoLayoutView;

    /// Centers the receiver in the superview
    -(NSArray *)centerInView:(UIView*)superview;
    -(NSLayoutConstraint *)centerInContainerOnAxis:(NSLayoutAttribute)axis;

    // Pin an attribute to the same attribute on another view. Both views must be in the same view hierarchy
    -(NSLayoutConstraint *)pinAttribute:(NSLayoutAttribute)attribute toSameAttributeOfView:(UIView *)peerView;

    /// Pins a view to a specific edge(s) of its superview, with a specified inset
    -(NSArray*)pinToSuperviewEdges:(JRTViewPinEdges)edges inset:(CGFloat)inset;

    /// Pins a view to all edges of its superview, with specified edge insets
    -(NSArray*)pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets;

    /// Pins a view's edge to a peer view's edge. Both views must be in the same view hierarchy
    -(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView*)peerView;
    -(NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)peerView inset:(CGFloat)inset;

    /// Pins a views edge(s) to another views edge(s). Both views must be in the same view hierarchy.
    -(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView;
    -(NSArray *)pinEdges:(JRTViewPinEdges)edges toSameEdgesOfView:(UIView *)peerView inset:(CGFloat)inset;

    /// Set to a specific size. 0 in any axis results in no constraint being applied.
    -(NSArray *)constrainToSize:(CGSize)size;

    /// Pins a point to a specific point in the superview's frame. Use NSLayoutAttributeNotAnAttribute to only pin in one dimension
    -(void)pinPointAtX:(NSLayoutAttribute)x Y:(NSLayoutAttribute)y toPoint:(CGPoint)point;

    /// Spaces the views evenly along the selected axis. Will force the views to the same size to make them fit
    -(void)spaceViews:(NSArray*)views onAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing alignmentOptions:(NSLayoutFormatOptions)options;
