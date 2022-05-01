import UIKit


final class FindUserCell: UITableViewCell {
    
    static let idCell: String = "FindUserCell"
    
    private lazy var userImageView: UIImageView = {
        let userImageView: UIImageView = UIImageView()
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 37
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.borderWidth = 1
        userImageView.contentMode = .scaleAspectFill
        
        return userImageView
    }()
    
    
    private lazy var usernameLabel: UILabel = {
        let usernameLabel: UILabel = UILabel()
        
        usernameLabel.textColor = .black
        
        return usernameLabel
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = .none
        usernameLabel.text = ""
    }
    
    
    public func setupCell(context: FindUserCellContext) {
        let imageData: Data? = context.imageData
        userImageView.image = imageData != nil ? UIImage(data: imageData!) : UIImage(named: "avatar")
        
        usernameLabel.text = context.username
        
        [userImageView, usernameLabel].forEach {
            contentView.addSubview($0)
        }
        
        setupLayout()
    }
    
    
    private func setupLayout() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topMarginImage
            ),
            userImageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: Constants.leftMarginImage
            ),
            userImageView.widthAnchor.constraint(
                equalToConstant: Constants.sizeImage.width
            ),
            userImageView.heightAnchor.constraint(
                equalToConstant: Constants.sizeImage.height
            )
        ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            usernameLabel.leftAnchor.constraint(
                equalTo: userImageView.rightAnchor,
                constant: Constants.leftMarginUsernameLabel
            ),
            usernameLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            usernameLabel.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            )
        ])
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            UIView.animate(withDuration: 0.2) {
                self.contentView.backgroundColor = .lightGray
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.contentView.backgroundColor = .white
            }
        }
    }
}


struct Constants {
    static let leftMarginImage: CGFloat = 25
    static let topMarginImage: CGFloat = 8
    static let sizeImage: CGSize = CGSize(width: 74, height: 74)
    
    static let leftMarginUsernameLabel: CGFloat = 25
}


struct FindUserCellContext {
    let uid: String
    let username: String
    let imageData: Data?
}
