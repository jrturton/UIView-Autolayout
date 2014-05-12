[![Build Status](https://travis-ci.org/jrturton/UIView-Autolayout.svg)](https://travis-ci.org/jrturton/UIView-Autolayout)

UIView-Autolayout
=================

Category on UIView to simplify the creation of common layout constraints. The code is described and introduced in [this blog post](http://commandshift.co.uk/blog/2013/02/20/creating-individual-layout-constraints/).

Here's the API documentation [on Cocoadocs](http://cocoadocs.org/docsets/UIView-Autolayout).

The demo project is most of the way towards drawing a robot made of views arranged using all the category methods:

![robot](https://raw.github.com/jrturton/UIView-Autolayout/master/screenshot.png)

Installation
-------------

**Using [Cocoapods](http://cocoapods.org/):**

`pod 'UIView-Autolayout', '~> 0.2.0'`

**Manually:**

Download the source code and drag the files in the `Source/` directory into your project.

Deprecated Methods
------------------

As of version 1.0.0, all deprecated methods will be removed from this category.
All deprecated methods are marked with a compiler flag providing instructions on alternative methods to use but for more information check out the API documentation on the Cocoadocs website listed above.

If you are using Cocoapods and do not wish to upgrade to version 1.0.0 then you can specify the following in your Podfile:

`pod 'UIView-Autolayout', '~> 0.2.0'`

This will prevent Cocoapods installing any 1.0.0 updates.
