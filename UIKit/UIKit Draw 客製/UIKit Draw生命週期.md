
**前言**

UIView 在螢幕呈現時會呼叫 drawRect 繪製內容。   
drawRect 家族包含.   
1. draw(_ layer, in ctx : CGContext).  
2. draw(_ rect: CGRect)
> 不同的UIKit 元件會額外有專屬自己類的draw，比如 UILabel drawText(_ rect: CGRect)

呼叫順序： 1 > 2 > 其他專屬.   
使用概念：使用 UIGraphicsGetCurrentContext() 取得 context ，
或是在 draw(_ layer, in ctx: CGContext) 獲取 context，
搭配 [Drawing](https://developer.apple.com/documentation/uikit/drawing) 家族做各項繪製。 

_Point:  draw(\_ layer, in ctx) 後才使用UIGraphicsGetCurrentContext。_

