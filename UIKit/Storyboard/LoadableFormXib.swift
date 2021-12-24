
import UIKit

// https://gist.github.com/DenTelezhkin/d37c724a5231acab6e4f6edcd86ad27d
/// 直接載入對應得nibView到owner中  owner必須在xib中指定   並且contentView指定給 customView
/// 使用方式 storyborad 指定View的class

class LoadableFromXibView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    func loadXib() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func needLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if let superView = contentView.superview {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
                contentView.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
    }
}
