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

import UIKit

/// Pre-build UI components
struct Components {
  struct reactionSelect {
    static func reactionIcon(option: Reaction) -> CALayer {
      return CALayer().build {
        $0.contents = option.icon.cgImage
      }
    }

    static func reactionLabel(option: Reaction, height: CGFloat) -> UILabel {
      let title = option.title
      let font  = UIFont(name: "HelveticaNeue", size: 10) ?? .systemFont(ofSize: 10)

      let size       = CGSize(width: 200, height: 200)
      let attributes = [NSFontAttributeName: font] as [String: Any]
      let bounds     = title.boundingRect(with: size, options: [], attributes: attributes, context: nil)

      return UILabel().build {
        $0.text                = title
        $0.font                = font
        $0.textAlignment       = .center
        $0.textColor           = .white
        $0.backgroundColor     = UIColor(white: 0, alpha: 0.7)
        $0.alpha               = 0
        $0.frame               = CGRect(x: 0, y: 0, width: bounds.width + height / 2, height: height)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius  = height / 2
      }
    }

    static func backgroundLayer() -> CAShapeLayer {
      return CAShapeLayer().build {
        $0.fillColor     = UIColor.white.cgColor
        $0.shadowOffset  = CGSize(width: 0, height: 1)
        $0.shadowOpacity = 0.1
      }
    }
  }

  struct reactionButton {
    static func facebookLikeIcon() -> UIImageView {
      return UIImageView().build {
        $0.contentMode = .scaleAspectFit
      }
    }

    static func facebookLikeLabel() -> UILabel {
      return UILabel().build {
        $0.font          = UIFont(name: "HelveticaNeue", size: 16)
        $0.textColor     = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
      }
    }
  }
}
