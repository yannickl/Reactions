/*
 * Reactions
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import CoreText
import UIKit

final class CAReactionSummaryLayer: CALayer {
  private var indicatorLayers: [CALayer] = [] {
    didSet {
      for l in oldValue {
        l.removeFromSuperlayer()
      }

      for index in 0 ..< indicatorLayers.count {
        let l = indicatorLayers[indicatorLayers.count - 1 - index]

        addSublayer(l)
      }
    }
  }

  var reactions: [Reaction] = [] {
    didSet {
      indicatorLayers = reactions.uniq().map({
        let l           = CALayer()
        l.contents      = $0.icon.cgImage
        l.masksToBounds = true
        l.borderColor   = UIColor.white.cgColor
        l.borderWidth   = 2

        return l
      })
    }
  }

  var config: ReactionSummaryConfig = ReactionSummaryConfig()

  var margin: CGFloat = 0

  override func draw(in ctx: CGContext) {
    super.draw(in: ctx)

    /*var b = bounds

    for i in 0 ..< indicatorIcons.count {
      b.origin.x = b.height + 50 * CGFloat(i)

      let path = CGPath(rect: b, transform: nil)
      let str  = NSMutableAttributedString(string: "0")

      str.addAttribute(kCTForegroundColorAttributeName as String, value: UIColor.black, range: NSMakeRange(0,str.length))

      let fontRef = UIFont.systemFont(ofSize: 20)
      str.addAttribute(kCTFontAttributeName as String, value: fontRef, range:NSMakeRange(0, str.length))

      let frameSetter = CTFramesetterCreateWithAttributedString(str)
      let ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0,str.length), path, nil)

      CTFrameDraw(ctFrame, ctx)
    }*/

    ctx.translateBy(x: 0, y: bounds.height)
    ctx.scaleBy(x: 1, y: -1)
    
    for index in 0 ..< reactions.count {
      updateIconAtIndex(index, with: bounds.height - config.iconMarging * 2, in: ctx)
    }
  }

  private func updateIconAtIndex(_ index: Int, with size: CGFloat, in ctx: CGContext) {
    let x: CGFloat
    let layer = indicatorLayers[index]

    switch config.alignment {
    case .left: x = (size - 3) * CGFloat(index)
    case .right: x = bounds.width - size - (size - 3) * CGFloat(index)
    case .centerLeft: x = margin + (size - 3) * CGFloat(index)
    case .centerRight: x = bounds.width - size - (size - 3) * CGFloat(index) - margin
    }

    let iconFrame = CGRect(x: x, y: (bounds.height - size) / 2, width: size, height: size)

    layer.frame        = iconFrame
    layer.cornerRadius = iconFrame.height / 2
    layer.draw(in: ctx)
  }
}
