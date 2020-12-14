
#### 模擬Line 聊天室Img 放大預覽效果


##### ZoomIn
    核心思路：
    - 添加全螢幕背景 backgroundView.alpha = 0
    - 添加 newImgView
    - orignImgView frame 轉移給 newImgView [Apple API](https://developer.apple.com/documentation/uikit/uicoordinatespace/1622564-convert)
    - 動畫: backgroundView.alpha = 1 / newImgView.frmae 還原成預設值
    
##### ZoomOut
    核心思路：
    - backgroundView.alpha = 0
    - newImgView frame 轉移給 orignImgView
    - 動畫: orignImgView.frmae 還原成預設值
    - 動畫結束: backgroundView 從父View 移除 / newImgView 從父View移除 / newImgView.image = nil
