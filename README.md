[![Build Status](https://travis-ci.org/jrturton/UIView-Autolayout.svg?branch=master)](https://travis-ci.org/jrturton/UIView-Autolayout)

UIView-Autolayout
=================

---

**Do you really need this?**

If you're making a new app targeting iOS9 or higher, I'd recommend using the new layout anchor functionality and stack views to achieve the layout you require. The layout anchor gives you concise creation of constraints in code, and stack views probably give you 90% of the layouts you were making yourself using constraints anyway. 

---

Category on UIView to simplify the creation of common layout constraints. The code is described and introduced in [this blog post](http://commandshift.co.uk/blog/2013/02/20/creating-individual-layout-constraints/).

Here's the API documentation [on Cocoadocs](http://cocoadocs.org/docsets/UIView-Autolayout).

The demo project is most of the way towards drawing a robot made of views arranged using all the category methods:

![robot](https://raw.github.com/jrturton/UIView-Autolayout/master/screenshot.png)

Installation
-------------

**Using [CocoaPods](http://cocoapods.org/):**

`pod 'UIView-Autolayout', '~> 0.2.0'`

**Manually:**

Download the source code and drag the files in the `Source/` directory into your project.

Deprecated Methods
------------------

As of version 1.0.0, all deprecated methods will be removed from this category.
All deprecated methods are marked with a compiler flag providing instructions on alternative methods to use but for more information check out the API documentation on the Cocoadocs website listed above.

If you are using CocoaPods and do not wish to upgrade to version 1.0.0 then you can specify the following in your Podfile:

`pod 'UIView-Autolayout', '~> 0.2.0'`

This will prevent CocoaPods installing any 1.0.0 updates.
