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

struct ComponentBuilder {
  struct ReactionSelect {
    static func optionIcon(option: Reaction) -> CALayer {
      let ca      = CALayer()
      ca.contents = option.icon.cgImage

      return ca
    }

    static func optionLabel(option: Reaction, height: CGFloat) -> UILabel {
      let title = option.title

      let l                 = UILabel()
      l.text                = title
      l.font                = UIFont(name: "Helvetica", size: 10)
      l.textAlignment       = .center
      l.textColor           = .white
      l.backgroundColor     = .black
      l.alpha               = 0
      l.layer.masksToBounds = true
      l.layer.cornerRadius  = height / 2

      let size       = CGSize(width: 200, height: 200)
      let attributes = [NSFontAttributeName: l.font] as [String: Any]
      let bounds     = title.boundingRect(with: size, options: [], attributes: attributes, context: nil)
      l.frame        = CGRect(x: 0, y: 0, width: bounds.width + height / 2, height: height)

      return l
    }

    static var backgroundLayer: CAShapeLayer {
      let layer           = CAShapeLayer()
      layer.fillColor     = UIColor.white.cgColor
      layer.shadowOffset  = CGSize(width: 0, height: 1)
      layer.shadowOpacity = 0.1
      
      return layer
    }
  }

  struct ReactionButton {
    static var facebookLikeIcon: UIImageView {
      let iv         = UIImageView(image: UIImage(named: "like-template")?.withRenderingMode(.alwaysTemplate))
      iv.contentMode = .scaleAspectFit
      iv.tintColor   = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)

      return iv
    }

    static var facebookLikeLabel: UILabel {
      let l           = UILabel()
      l.text          = "Like"
      l.font          = UIFont(name: "HelveticaNeue", size: 16)
      l.textAlignment = .left
      l.textColor     = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
      
      return l
    }
  }
}
