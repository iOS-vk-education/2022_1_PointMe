import UIKit
import PinLayout


final class AddPhotoCell: UICollectionViewCell {
    static let id: String = "AddPhotoCell"
    
    
    private lazy var bodyView: UIView = {
        let bodyView: UIView = UIView()
        
        bodyView.backgroundColor = .buttonAddPhotoColor
        bodyView.layer.cornerRadius = Constants.baseCornerRadius
        
        return bodyView
    }()
    
    
    private lazy var titleImageView: UIImageView = {
        let titleImageView: UIImageView = UIImageView()
        
        titleImageView.image = UIImage(systemName: "plus")
        titleImageView.tintColor = .white
        
        return titleImageView
    }()
    
    
    private lazy var titleText: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Добавить фото"
        label.font = .smallTitleButton
        label.textColor = .lightTitleButton
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines4TextButton
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        contentView.backgroundColor = .clear
        
        [bodyView].forEach {
            contentView.addSubview($0)
        }
        
        [titleImageView, titleText].forEach {
            bodyView.addSubview($0)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.pin
            .all()
        
        titleImageView.pin
            .size(Constants.sizeImage4Button)
            .hCenter()
            .top(Constants.marginTop4Button)
        
        titleText.pin
            .below(of: titleImageView)
            .marginTop(Constants.marginTop4TextButton)
            .horizontally(Constants.marginHor4TextButton)
            .height(Constants.height4TextButton)
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }

    
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
        })
    }
}


private extension AddPhotoCell {
    struct Constants {
        static let baseCornerRadius: CGFloat = 15
        static let numberOfLines4TextButton: Int = 2
        static let marginTop4TextButton: CGFloat = 15
        static let marginHor4TextButton: CGFloat = 5
        static let height4TextButton: CGFloat = 48
        
        static let sizeImage4Button: CGSize = CGSize(width: 35, height: 35)
        static let marginTop4Button: CGFloat = 22
    }
}

