//
//  ViewController.swift
//  Practice_TapToOpenZoomInNextBackgroundView
//
//  Created by Woody on 2020/12/14.
//


import UIKit

class ViewController: UIViewController {
    
    lazy var backgroundView: UIView = UIView()
    
    lazy var imageView: UIImageView = UIImageView()
    
    private var orignCGRect: CGRect?
    
    @IBOutlet var orignImgView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orignCGRect = orignImgView.frame
        button.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
    }
    
}

// ZoomIn 解析
// backgroundView 背景color = black
// backgroundView alpha = 0
// 主畫面 view.addsubview(backgroundView)
// orignImgView 轉移CGRect > imageView
// 添加 imageView > backgroundView
// 隱藏 orignImgView
// anitmate all View : backgroundView alpha = 1 , imageView.frame = 目標

extension ViewController {
    
    @objc func buttonTapAction(_ button: UIButton) {
        setImgView()
    }
    
    private func setImgView() {
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        
        backgroundView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        guard let vc = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController, let rootView = vc.view else {
            return
        }
        rootView.addSubview(backgroundView)
        
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        closeBtn.backgroundColor = .systemBlue
        backgroundView.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        
        imageView.frame = orignImgView.superview?.convert(orignImgView.frame, to: backgroundView) ?? CGRect()
        imageView.contentMode = .scaleToFill
        imageView.image = orignImgView.image
        backgroundView.addSubview(imageView)
        orignImgView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            [weak self] in
            guard let self = self else{ return }
            self.backgroundView.alpha = 1
            self.imageView.frame = CGRect(origin: .zero, size: CGSize(width: self.backgroundView.bounds.width, height: self.backgroundView.bounds.width))
            self.imageView.center = CGPoint(x: self.backgroundView.bounds.width / 2, y: self.backgroundView.bounds.height / 2)
        }, completion: nil)
    }
    
}

// ZoomOut 解析
// imageView = nil
// backgroundView alpha = 0
// orignImgView.frame 轉型成 imageView.frame
// orignImgView.alpha = 1
// anitmate all  orignImgView 還原成預設值
// animation.completion: 移除 imageView 移除 backgroundView


extension ViewController {
    
    
    @objc func closeBtnAction(_ button: UIButton) {
        imageView.image = nil
        backgroundView.alpha = 0
        zoomOut()
    }
    
    func zoomOut() {
        guard let vc = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController, let rootView = vc.view else {
            return
        }
        orignImgView.frame = imageView.superview?.convert(imageView.frame, to: rootView) ?? CGRect()
        orignImgView.alpha = 1
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            [weak self] in
            guard let self = self else { return }
            guard let orignCGRect = self.orignCGRect else { return }
            self.orignImgView.frame = orignCGRect
            
        }) { _ in
            self.imageView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
    
    
}
