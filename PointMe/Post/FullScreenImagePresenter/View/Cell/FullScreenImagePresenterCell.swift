import UIKit
import PinLayout


final class FullScreenImagePresenterCell: UICollectionViewCell {
    
    static let id: String = "FullScreenImagePresenterCell"
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    var delegate: FullScreenImagePresenterCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(imageName: String) {
        scrollView.delegate = self
        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(gesture)
        imageView.image = UIImage(named: imageName)
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.pin
            .all()
        
        imageView.pin
            .all()
        
        scrollView.contentSize = imageView.frame.size
    }
    
    @objc func didTap() {
        self.delegate?.didTapCell()
    }
}

extension FullScreenImagePresenterCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

private extension FullScreenImagePresenterCell {
    struct Constants {
        static let minimumZoomScale: CGFloat = 1.0
        static let maximumZoomScale: CGFloat = 10.0
    }
}
