import UIKit


final class ImagePresentCell: UICollectionViewCell {
    static let id: String = "ImagePresentCell"
    
    private lazy var bodyView: UIView = {
        let bodyView: UIView = UIView()
        
        bodyView.layer.cornerRadius = Constants.baseCornerRadius
        
        return bodyView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = Constants.baseCornerRadius
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(urlImage: String) {
        
        contentView.backgroundColor = .clear
        contentView.addSubview(bodyView)
        
        imageView.image = UIImage(named: urlImage)
        bodyView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin
            .all()
        
        imageView.pin
            .all()
        
        bodyView.pin
            .wrapContent()
    }
}


private extension ImagePresentCell {
    struct Constants {
        static let baseCornerRadius: CGFloat = 15
        
        static let sizeButtonDelete: CGSize = CGSize(width: 40, height: 40)
        static let marginTopButtonDelete: CGFloat = 5
        static let marginRightButtonDelete: CGFloat = 5
        
        static let sizeIconButtonDelete: CGSize = CGSize(width: 20, height: 20)
        
        static let minPressDuration: TimeInterval = 0
        static let durationAnimation: TimeInterval = 0.1
    }
}

