import UIKit
import PinLayout


final class ImageCell: UICollectionViewCell {
    static let id: String = "ImageCell"
    
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
    
    
    private lazy var view4Button: UIView = {
        let backViewForButton: UIView = UIView()
        
        backViewForButton.backgroundColor = .backgroundColorDeletPhotoButton
        backViewForButton.layer.cornerRadius = Constants.baseCornerRadius
        backViewForButton.isUserInteractionEnabled = true
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didTapDeleteButton)
        )
        gesture.minimumPressDuration = Constants.minPressDuration
        backViewForButton.addGestureRecognizer(gesture)
        
        return backViewForButton
    }()
    
    
    private lazy var icon4DeleteButton: UIImageView = {
        let titleImageView: UIImageView = UIImageView()
        
        titleImageView.image = UIImage(systemName: "xmark")
        titleImageView.tintColor = .white
        
        return titleImageView
    }()
    
    
    private var deleteAction: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(urlImage: URL, actionDelete: (() -> Void)?) {
        deleteAction = actionDelete
        
        contentView.backgroundColor = .clear
        contentView.addSubview(bodyView)
        
        imageView.image = UIImage(contentsOfFile: urlImage.path)
        bodyView.addSubview(imageView)
        
        imageView.addSubview(view4Button)
        view4Button.addSubview(icon4DeleteButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin
            .all()
        
        imageView.pin
            .all()
        
        bodyView.pin
            .wrapContent()
        
        view4Button.pin
            .size(Constants.sizeButtonDelete)
            .top(Constants.marginTopButtonDelete)
            .right(Constants.marginRightButtonDelete)
        
        icon4DeleteButton.pin
            .size(Constants.sizeIconButtonDelete)
            .hCenter()
            .vCenter()
    }
    
    
    @objc private func didTapDeleteButton(recognizer: UILongPressGestureRecognizer) {
        print("TAAAAAAP!!!!!")
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.durationAnimation) { [weak self] in
                self?.view4Button.alpha = 0.7
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.durationAnimation) { [weak self] in
                self?.view4Button.alpha = 1.0
            } completion: {  [weak self] _ in
                self?.deleteAction?()
            }
        }
    }
}


private extension ImageCell {
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
