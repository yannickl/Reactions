<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/798235/19212170/781ebb64-8d4c-11e6-8285-94e74a356d53.png" alt="Reactions">
</p>

<p align="center">
  <a href="http://cocoadocs.org/docsets/Reactions/"><img alt="Supported Platforms" src="https://cocoapod-badges.herokuapp.com/p/Reactions/badge.svg"/></a>
  <a href="http://cocoadocs.org/docsets/Reactions/"><img alt="Version" src="https://cocoapod-badges.herokuapp.com/v/Reactions/badge.svg"/></a>
  <a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
  <a href="https://travis-ci.org/yannickl/Reactions"><img alt="Build status" src="https://travis-ci.org/yannickl/Reactions.svg?branch=master"/></a>
  <a href="http://codecov.io/github/yannickl/Reactions"><img alt="Code coverage status" src="http://codecov.io/github/yannickl/Reactions/coverage.svg?branch=master"/></a>
  <a href="https://codebeat.co/projects/github-com-yannickl-reactions"><img alt="Codebeat badge" src="https://codebeat.co/badges/69ae0ba9-21bf-4fc6-ba45-e21b1d26ac1a" /></a>
</p>

**Reactions** is a fully customizable control to give people more ways to share their reaction in a quick and easy way.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/798235/19211779/1d4a4d68-8d45-11e6-9b0a-b58a0f4c78ed.gif" alt="Reactions">
</p>

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#contact">Contact</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## Usage

### Reaction

 <img src="https://cloud.githubusercontent.com/assets/798235/19212812/1bc819f6-8d5a-11e6-81fc-555f02db2342.png" alt="Reaction" height="132px">

A `Reaction` object is a model defined with these properties:

- *id:* a unique identifier.
- *title:* the title displayed either in a selector or a button.
- *color:* the color used to display the button title.
- *icon:* the reaction icon.
- *alternativeIcon:* the optional alternative icon used with the reaction button.

The library already packages the standard Facebook reactions: `like`, `love`, `haha`, `wow`, `sad` and `angry`. And of course you can create your owns:

```swift
let myReaction = Reaction(id: "id", title: "title", color: .red, icon: UIImage(named: "name")!)
```

### ReactionSelector

 <img src="https://cloud.githubusercontent.com/assets/798235/19212442/8b9fe032-8d51-11e6-84c3-e2a026a31d72.png" alt="ReactionSelector" height="65px">

The `ReactionSelector` control allows people to select a reaction amongst a list:

```swift
let select       = ReactionSelector()
select.reactions = Reaction.facebook.all

// React to reaction change
select.addTarget(self, action: #selector(reactionDidChanged), for: .valueChanged)

func reactionDidChanged(_ sender: AnyObject) {
  print(select.selectedReaction)
}

// Conforming to the ReactionFeedbackDelegate
select.feedbackDelegate = self

func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
  // .slideFingerAcross, .releaseToCancel, .tapToSelectAReaction
}
```

The component can be used alone (like above) or in conjunction with the `ReactionButton` (discussed later). You can of course customize the component using a `ReactionSelectorConfig` object:

```swift
select.config = ReactionSelectorConfig {
  $0.spacing        = 6
  $0.iconSize       = 40
  $0.stickyReaction = false
}
```

### ReactionButton

<img src="https://cloud.githubusercontent.com/assets/798235/19213727/b43341d4-8d73-11e6-9696-5f10dcf6815d.gif" alt="ReactionButton" height="32px">

A `ReactionButton` provides a simple way to toggle a reaction (e.g. like/unlike). A `ReactionSelector` can also be attached in order to display it when a long press is performed:

```swift
let button      = ReactionButton()
button.reaction = Reaction.facebook.like

// To attach a selector
button.reactionSelector = ReactionSelector()
```

You can configure the component using a `ReactionButtonConfig` object:

```swift
button.config           = ReactionButtonConfig() {
  $0.iconMarging      = 8
  $0.spacing          = 4
  $0.font             = UIFont(name: "HelveticaNeue", size: 14)
  $0.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
  $0.alignment        = .left
}
```

### ReactionSummary

<img src="https://cloud.githubusercontent.com/assets/798235/19214415/709ff948-8d83-11e6-9155-1af925fb4dbe.png" alt="ReactionSummary" height="28px">

The `ReactionSummary` is a control which display a given reaction list as a set of unique icons superimposed. You can also link it to a text description.

```swift
let summary       = ReactionSummary()
summary.reactions = Reaction.facebook.all
summary.text      = "You, Chris Lattner, and 16 others"

// As is a control you can also react to the .touchUpInside event
select.addTarget(self, action: #selector(summaryDidTouched), for: .touchUpInside)
```

<img src="https://cloud.githubusercontent.com/assets/798235/19440513/792e0b6c-9482-11e6-8410-c5522ca93fed.png" alt="ReactionSummary Non Aggregated" height="23px">

You can also have the details for each reaction. For that you'll need to uncombined them by setting the `isAggregated` config property to `false`.

```swift
summary.config = ReactionSummaryConfig {
  $0.isAggregated = false
}
```

Like the other components you can setting it using a `ReactionSummaryConfig` object:

```swift
summary.config = ReactionSummaryConfig {
  $0.spacing      = 8
  $0.iconMarging  = 2
  $0.font         = UIFont(name: "HelveticaNeue", size: 12)
  $0.textColor    = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
  $0.alignment    = .left
  $0.isAggregated = true
}
```

## Installation

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your *Podfile* and add _Reactions_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
pod 'Reactions', '~> 1.1.1'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import Reactions` framework into your files.

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `Reactions` into your Xcode project using Carthage, specify it in your `Cartfile` file:

```ogdl
github "yannickl/Reactions" >= 1.1.1
```

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Reactions` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/yannickl/Reactions.git", versions: "1.1.1" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually

[Download](https://github.com/YannickL/Reactions/archive/master.zip) the project and copy the `Sources` and `Resources` folders into your project to use it in.

## Contact

Yannick Loriot
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)
 - [contact@yannickloriot.com](mailto:contact@yannickloriot.com)


## License (MIT)

Copyright (c) 2016-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
