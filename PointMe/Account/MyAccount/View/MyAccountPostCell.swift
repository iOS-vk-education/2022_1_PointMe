import UIKit
import PinLayout

final class MyAccountPostCell: UITableViewCell {
    
    
    private let headViewContainer: UIView = UIView()
    private let contentViewContainer: UIView = UIView()
    
    private let userImage: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private let headerLine: UIView = UIView()
    private let deleteButton: UIButton = UIButton(type: .system)
    
    private let mainImageContainer: UIView = UIView()
    private let descriptionViewContainer: UIView = UIView()
    
    private let mainImage: UIImageView = UIImageView()
    private let numberOfImagesLabel: UILabel = UILabel()
    
    private let mainTitleLabel: UILabel = UILabel()
    private let placeViewContainer: UIView = UIView()
    private let scoreViewContainer: UIView = UIView()
    private let openButton: UIButton = UIButton(type: .system)
    
    private let placeMarkViewContainer: UIView = UIView()
    private let placeMarkImage: UIImageView = UIImageView()
    private let placeAddressLabel: UILabel = UILabel()
    
    private var scoreImage: [UIView] = []
    private let scoreLabel: UILabel = UILabel()
    
    var delegate: CellDeleteDelegate?
    
    var openDelegate: CellTapButtonDelegate?
    
    required init?(code aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        setupScoreImage()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = .none
        userImage.image = .none
        numberOfImagesLabel.text = ""
        mainTitleLabel.text = ""
        placeAddressLabel.text = ""
        scoreLabel.text = ""
        configureScoreImage(number: Constants.ScoreImage.quantity, color: .defaultWhiteColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCellConstraints()
    }
    
    func configure(data: MyAccountPost) {
        if let imageData = data.userImageData {
            userImage.image = UIImage(data: imageData)
        } else {
            userImage.image = UIImage(named: "avatar")
        }
        userName.text = data.userName
        dateLabel.text = "\(data.date.day) \(Constants.Date.month[data.date.month]!) \(data.date.year) года"
        
        if let mainImageData = data.mainImage {
            mainImage.image = UIImage(data: mainImageData)
        } else {
            mainImage.image = nil
        }
        numberOfImagesLabel.text = "\(data.numberOfImages) фото"
        
        mainTitleLabel.text = data.mainTitle
        
        placeAddressLabel.text = data.address
        
        scoreLabel.text = "\(data.mark)/\(Constants.ScoreImage.quantity)"
        configureScoreImage(number: data.mark, color: .defaultRedColor)
    }
    
    private func configureView() {
        [userImage, userName, dateLabel, headerLine, deleteButton].forEach {
            headViewContainer.addSubview($0)
        }
        
        [mainImage, numberOfImagesLabel].forEach {
            mainImageContainer.addSubview($0)
        }
        
        [placeMarkImage].forEach {
            placeMarkViewContainer.addSubview($0)
        }
        
        [placeMarkViewContainer, placeAddressLabel].forEach {
            placeViewContainer.addSubview($0)
        }
        
        scoreImage.forEach {
            scoreViewContainer.addSubview($0)
        }
        [scoreLabel].forEach {
            scoreViewContainer.addSubview($0)
        }
        
        [mainTitleLabel, placeViewContainer, scoreViewContainer, openButton].forEach {
            descriptionViewContainer.addSubview($0)
        }
        
        [descriptionViewContainer, mainImageContainer].forEach {
            contentViewContainer.addSubview($0)
        }
        
        [headViewContainer, contentViewContainer].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupCell() {
        userImage.layer.cornerRadius = Constants.UserImage.radius
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = Constants.UserImage.borderWidth
        userImage.tintColor = .defaultBlackColor
        userImage.contentMode = .scaleAspectFill

        headViewContainer.backgroundColor = .defaultWhiteColor
        
        contentViewContainer.backgroundColor = .defaultWhiteColor
        
        userName.tintColor = .defaultBlackColor
        userName.font = .postUserNameLabel
        userName.textAlignment = .left
        
        dateLabel.tintColor = .defaultBlackColor
        dateLabel.font = .postDateLabel
        dateLabel.textAlignment = .left
        
        deleteButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .defaultBlackColor
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        
        headerLine.backgroundColor = .defaultBlackColor
        
        mainImage.layer.cornerRadius = Constants.MainImage.cornerRadius
        mainImage.layer.masksToBounds = true
        mainImage.contentMode = .scaleAspectFill
        
        numberOfImagesLabel.layer.cornerRadius = Constants.NumberOfImagesLabel.cornerRadius
        numberOfImagesLabel.textColor = .defaultWhiteColor
        numberOfImagesLabel.font = .postNumbersOfImagesLabel
        numberOfImagesLabel.textAlignment = .center
        numberOfImagesLabel.backgroundColor = .numberOfImagesColor
        
        mainTitleLabel.tintColor = .defaultBlackColor
        mainTitleLabel.font = .postMainTitleLabel
        mainTitleLabel.textAlignment = .left
        
        openButton.tintColor = .defaultWhiteColor
        openButton.layer.cornerRadius = Constants.OpenButton.cornerRadius
        openButton.backgroundColor = .defaultBlackColor
        openButton.setTitle("Открыть обзор", for: .normal)
        openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
        
        placeAddressLabel.tintColor = .defaultBlackColor
        placeAddressLabel.font = .postPlaceAddressLabel
        placeAddressLabel.textAlignment = .left
        
        placeMarkImage.image = UIImage(named: "LocationPointer")
        
        scoreLabel.tintColor = .defaultBlackColor
        scoreLabel.font = .postScoreLabel
        scoreLabel.textAlignment = .left
        
        backgroundColor = .defaultBackgroundColor
        selectionStyle = .none
    }
    
    private func setupCellConstraints() {
        headViewContainer.pin
            .top(Constants.SeparatorLine.height)
            .horizontally()
            .height(Constants.Header.height)
        
        contentViewContainer.pin
            .below(of: headViewContainer)
            .left()
            .horizontally()
            .bottom()
        
        userImage.pin
            .left(Constants.DefaultPadding.leftRightPadding)
            .vCenter()
            .height(2 * Constants.UserImage.radius)
            .width(2 * Constants.UserImage.radius)
        
        userName.pin
            .after(of: userImage)
            .height(Constants.UserName.fontSize)
            .vCenter((-Constants.UserName.betweenPadding - Constants.UserName.fontSize) / 2)
            .right()
            .marginLeft(Constants.UserName.leftPadding)
        
        dateLabel.pin
            .after(of: userImage)
            .height(Constants.Date.fontSize)
            .vCenter((Constants.UserName.betweenPadding + Constants.Date.fontSize) / 2)
            .marginLeft(Constants.UserName.leftPadding)
            .right()
        
        deleteButton.pin
            .right(Constants.DeleteButton.rigthPadding)
            .vCenter()
            .height(Constants.DeleteButton.sideSize)
            .width(Constants.DeleteButton.sideSize)
        
        headerLine.pin
            .horizontally()
            .bottom()
            .height(Constants.HeaderLine.width)
        
        if mainImage.image != nil {
            mainImageContainer.pin
                .left(Constants.DefaultPadding.leftRightPadding)
                .vCenter()
                .width(Constants.Display.blockWidth)
                .height(Constants.Display.blockWidth)
            
            numberOfImagesLabel.pin
                .bottom(Constants.NumberOfImagesLabel.bottomPadding)
                .right(Constants.NumberOfImagesLabel.rightPadding)
                .width(Constants.NumberOfImagesLabel.width)
                .height(Constants.NumberOfImagesLabel.fontSize + Constants.NumberOfImagesLabel.heightAdd)
        } else {
            mainImageContainer.pin
                .left()
                .top()
                .width(0)
                .height(0)
            
            numberOfImagesLabel.pin
                .bottom()
                .right()
                .width(0)
                .height(0)
        }
        
        mainImage.pin
            .all()
        
        descriptionViewContainer.pin
            .after(of: mainImageContainer)
            .top(Constants.DefaultPadding.topBottomPadding)
            .marginLeft(Constants.DefaultPadding.leftRightPadding)
            .right(Constants.DefaultPadding.leftRightPadding)
            .bottom(Constants.DefaultPadding.topBottomPadding)
        
        mainTitleLabel.pin
            .top()
            .horizontally()
            .height(Constants.MainTitleLabel.fontSize)
        
        placeViewContainer.pin
            .below(of: mainTitleLabel, aligned: .left)
            .marginTop(Constants.DefaultPadding.topBottomPadding)
            .width(Constants.Display.blockWidth)
            .height(Constants.AddressLabel.fontSize)
        
        if mainImage.image != nil {
            scoreViewContainer.pin
                .below(of: placeViewContainer, aligned: .left)
                .marginTop(2 * Constants.DefaultPadding.topBottomPadding)
                .horizontally()
                .height(2 * Constants.ScoreImage.radius)
        } else {
            scoreViewContainer.pin
                .after(of: placeViewContainer, aligned: .bottom)
                .marginLeft(Constants.DefaultPadding.leftRightPadding)
                .right()
                .height(2 * Constants.ScoreImage.radius)
        }
        
        openButton.pin
            .bottom()
            .horizontally()
            .height(Constants.OpenButton.height)
        
        placeMarkViewContainer.pin
            .top()
            .left()
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.AddressLabel.fontSize)
        
        placeMarkImage.pin
            .left()
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.AddressLabel.fontSize / Constants.LocationPoint.ratio)
        
        placeAddressLabel.pin
            .after(of: placeMarkViewContainer, aligned: .top)
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.Display.blockWidth - Constants.AddressLabel.fontSize)
        
        scoreImage[0].pin
            .left()
            .top()
            .height(2 * Constants.ScoreImage.radius)
            .width(2 * Constants.ScoreImage.radius)
        for i in 1...4 {
            scoreImage[i].pin
                .height(2 * Constants.ScoreImage.radius)
                .width(2 * Constants.ScoreImage.radius)
                .after(of: scoreImage[i-1])
                .marginLeft(4)
                .vCenter()
        }
        
        scoreLabel.pin
            .height(2 * Constants.ScoreImage.radius)
            .after(of: scoreImage[4], aligned: .top)
            .right()
            .marginLeft(Constants.ScoreImage.betweenPadding)
    }
    
    @objc
    private func tapDeleteButton() {
        delegate?.deleteCell(sender: self)
    }
    
    private func setupScoreImage() {
        for _ in 0...4 {
            let temp = UIView()
            temp.backgroundColor = .white
            temp.layer.cornerRadius = Constants.ScoreImage.radius
            temp.layer.borderWidth = Constants.ScoreImage.borderWidth
            temp.layer.borderColor = UIColor.defaultRedColor.cgColor
            scoreImage.append(temp)
        }
    }
    
    private func configureScoreImage(number: Int, color: UIColor) {
        for i in 0..<number {
            scoreImage[i].backgroundColor = color
        }
    }
    
    @objc func didTapOpenButton() {
        openDelegate?.didTapOpen(sender: self)
    }
}

// MARK: - Constants

extension MyAccountPostCell {
    struct Constants {
        struct Header {
            static let height: CGFloat = 70
        }
        
        struct OpenButton {
            static let cornerRadius: CGFloat = 8
            static let fontSize: CGFloat = 14
            static let height: CGFloat = 40
        }
        
        struct DeleteButton {
            static let sideSize: CGFloat = 18
            static let rigthPadding: CGFloat = 20
        }
        
        struct NumberOfImagesLabel {
            static let bottomPadding: CGFloat = 4
            static let rightPadding: CGFloat = 4
            static let width: CGFloat = 60
            static let fontSize: CGFloat = 16
            static let heightAdd: CGFloat = 8
            static let cornerRadius: CGFloat = 5
        }
        
        struct UserImage {
            static let radius: CGFloat = 25
            static let borderWidth: CGFloat = 1
            static let topPadding: CGFloat = 12
        }
        
        struct UserName {
            static let leftPadding: CGFloat = 8
            static let fontSize: CGFloat = 18
            static let betweenPadding: CGFloat = 8
        }
        
        struct Date {
            static let fontSize: CGFloat = 14
            static let month: [Int: String] = [
                1: " января ",
                2: " февраля ",
                3: " марта ",
                4: " апреля ",
                5: " мая ",
                6: " июня ",
                7: " июля ",
                8: " августа ",
                9: " сентября ",
                10: " октября ",
                11: " ноября ",
                12: " декабря "
            ]
        }
        
        struct Display {
            static let blockWidth : CGFloat = UIScreen.main.bounds.width / 2 - 1.5 * 12
        }
        
        struct DefaultPadding {
            static let topBottomPadding: CGFloat = 12
            static let leftRightPadding: CGFloat = 12
        }
        
        struct AddressLabel {
            static let fontSize: CGFloat = 14
        }
        
        struct MainTitleLabel {
            static let fontSize: CGFloat = 18
        }
        
        struct LocationPoint {
            // Высота / ширина
            static let ratio: CGFloat = 17 / 10
        }
        
        struct ScoreImage {
            static let quantity: Int = 5
            static let radius: CGFloat = 9
            static let betweenPadding: CGFloat = 6
            static let borderWidth: CGFloat = 2
        }
        
        struct HeaderLine {
            static let width: CGFloat = 1
        }
        
        struct MainImage {
            static let cornerRadius: CGFloat = 8
            static let topPadding: CGFloat = 12
        }
        
        struct SeparatorLine {
            static let height: CGFloat = 8
        }
    }
}
