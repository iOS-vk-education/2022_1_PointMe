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
    
    var delegate: CellDeleteDelegate!
    
    var openDelegate: CellTapButtonDelegate!
    
    required init?(code aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserImage()
        setupUserName()
        setupDateLabel()
        setupDeleteButton()
        setupHeaderLine()
        setupMainTitleLabel()
        setupOpenButton()
        setupMainImage()
        setupNumberOfImagesLabel()
        setupPlaceMarkImage()
        setupPlaceAddressLabel()
        setupScoreImage()
        setupScoreLabel()
        
        configureView()
        
        backgroundColor = .defaultBackgroundColor
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        mainImage.image = .none
        userImage.image = .none
        numberOfImagesLabel.text = ""
        mainTitleLabel.text = ""
        placeAddressLabel.text = ""
        scoreLabel.text = ""
        configureScoreImage(number: 5, color: .defaultWhiteColor)
    }
    
    override func layoutSubviews() {
        setupHeadViewContainerConstraint()
        setupContentViewContainerConstraint()

        setupUserImageConstraint()
        setupUserNameConstraint()
        setupDateLabelConstraint()
        setupDeleteButtonConstraint()
        setupHeaderLineConstraint()
        
        setupMainImageContainerConstraint()

        setupDescriptionViewContainerConstraint()
        setupMainTitleLabelConstraint()
        setupPlaceViewContainerConstraint()

        setupScoreViewContainerConstraint()

        setupOpenButtonConstraint()
        setupMainImageConstraint()
        setupNumberOfImagesLabelConstraint()
        setupPlaceMarkViewContainer()
        setupPlaceMarkImageConstraint()
        setupPlaceAddressLabelConstraint()
        setupScoreImageConstraint()
        setupScoreLabelConstraint()
    }
    
    func configure(data: MyAccountPost) {
        if let imageData = data.userImageData {
            userImage.image = UIImage(data: imageData)
        } else {
            userImage.image = UIImage(named: data.userImage)
        }
        userName.text = data.userName
        dateLabel.text = "\(data.date.day) марта \(data.date.year) года"
        
        if let mainImageData = data.mainImage {
            mainImage.image = UIImage(data: mainImageData)
        } else {
            mainImage.image = nil
        }
        numberOfImagesLabel.text = "\(data.numberOfImages) фото"
        
        mainTitleLabel.text = data.mainTitle
        
        placeAddressLabel.text = data.address
        
        scoreLabel.text = "\(data.mark)/5"
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
    
    private func setupHeadViewContainerConstraint() {
        headViewContainer.backgroundColor = .defaultWhiteColor
        headViewContainer.pin
            .top(Constants.SeparatorLine.width)
            .horizontally()
            .height(70)
    }
    
    private func setupUserImage() {
        userImage.layer.cornerRadius = Constants.UserImage.radius
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = Constants.UserImage.borderWidth
    }
    
    private func setupUserImageConstraint() {
        userImage.pin
            .left(14)
            .vCenter()
            .height(2 * Constants.UserImage.radius)
            .width(2 * Constants.UserImage.radius)
    }
    
    private func setupUserName() {
        userName.tintColor = .defaultBlackColor
        userName.font = .postUserNameLabel
        userName.textAlignment = .left
    }
    
    private func setupUserNameConstraint() {
        userName.pin
            .after(of: userImage)
            .height(Constants.UserName.fontSize)
            .vCenter((-Constants.UserName.betweenPadding - Constants.UserName.fontSize) / 2)
            .horizontally()
            .marginLeft(Constants.UserName.leftPadding)
    }
    
    private func setupDateLabel() {
        dateLabel.tintColor = .defaultBlackColor
        dateLabel.font = .postDateLabel
        dateLabel.textAlignment = .left
    }
    
    private func setupDateLabelConstraint() {
        dateLabel.pin
            .after(of: userImage)
            .height(Constants.Date.fontSize)
            .vCenter((Constants.UserName.betweenPadding + Constants.Date.fontSize) / 2)
            .marginLeft(Constants.UserName.leftPadding)
            .horizontally()

        
    }
    
    private func setupDeleteButton() {
        deleteButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .defaultBlackColor
        deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
    }
    
    @objc
    private func tapDeleteButton() {
        delegate.deleteCell(sender: self)
    }
    
    private func setupDeleteButtonConstraint() {
        deleteButton.pin
            .right(Constants.DeleteButton.rigthPadding)
            .vCenter()
            .height(Constants.DeleteButton.sideSize)
            .width(Constants.DeleteButton.sideSize)
    }
    
    private func setupHeaderLineConstraint() {
        headerLine.pin
            .horizontally()
            .bottom()
            .height(Constants.HeaderLine.width)
    }
    
    private func setupHeaderLine() {
        headerLine.backgroundColor = .defaultBlackColor
    }
    
    private func setupContentViewContainerConstraint() {
        contentViewContainer.backgroundColor = .defaultWhiteColor
        contentViewContainer.pin
            .below(of: headViewContainer)
            .left()
            .horizontally()
            .bottom()
    }
    
    
    private func setupMainImageContainerConstraint() {
        if mainImage.image != nil {
        mainImageContainer.pin
            .left(Constants.DefaultPadding.leftRightPadding)
            .vCenter()
            .width(Constants.Display.blockWidth)
            .height(Constants.Display.blockWidth)
        } else {
            mainImageContainer.pin
                .left()
                .top()
                .width(0)
                .height(0)
        }
    }
    
    private func setupMainImage() {
        mainImage.layer.cornerRadius = Constants.MainImage.cornerRadius
        mainImage.layer.masksToBounds = true
    }
    
    private func setupMainImageConstraint() {
        mainImage.pin
            .all()

    }
    
    private func setupNumberOfImagesLabel() {
        
        numberOfImagesLabel.layer.cornerRadius = 5
        numberOfImagesLabel.textColor = .defaultWhiteColor
        numberOfImagesLabel.font = .postNumbersOfImagesLabel
        numberOfImagesLabel.textAlignment = .center
        numberOfImagesLabel.backgroundColor = .numberOfImagesColor
        
    }
    
    private func setupNumberOfImagesLabelConstraint() {
        if numberOfImagesLabel.text != "0" {
        numberOfImagesLabel.pin
            .bottom(Constants.NumberOfImagesLabel.bottomPadding)
            .right(Constants.NumberOfImagesLabel.rightPadding)
            .width(Constants.NumberOfImagesLabel.width)
            .height(Constants.NumberOfImagesLabel.fontSize + Constants.NumberOfImagesLabel.heightAdd)
        } else {
            numberOfImagesLabel.pin
                .bottom()
                .right()
                .width(0)
                .height(0)
        }
    }
    
    func setupDescriptionViewContainerConstraint() {
        descriptionViewContainer.pin
            .after(of: mainImageContainer)
            .top(Constants.DefaultPadding.topBottomPadding)
            .marginLeft(Constants.DefaultPadding.leftRightPadding)
            .right(Constants.DefaultPadding.leftRightPadding)
            .bottom(Constants.DefaultPadding.topBottomPadding)
    }
    
    
    private func setupMainTitleLabel() {
        mainTitleLabel.tintColor = .defaultBlackColor
        mainTitleLabel.font = .postMainTitleLabel
        mainTitleLabel.textAlignment = .left
        
    }
    
    private func setupMainTitleLabelConstraint() {
        mainTitleLabel.pin
            .left()
            .top()
            .horizontally()
            .height(Constants.MainTitleLabel.fontSize)
    }
    
    private func setupPlaceViewContainerConstraint() {
        placeViewContainer.pin
            .below(of: mainTitleLabel, aligned: .left)
            .marginTop(Constants.DefaultPadding.topBottomPadding)
            .width(Constants.Display.blockWidth)
            .height(Constants.AddressLabel.fontSize)
    }

    private func setupScoreViewContainerConstraint() {
        if numberOfImagesLabel.text != "0 фото" {
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
    }
    
    private func setupOpenButton() {
        openButton.tintColor = .defaultWhiteColor
        openButton.layer.cornerRadius = Constants.OpenButton.cornerRadius
        openButton.backgroundColor = .defaultBlackColor
        openButton.setTitle("Открыть обзор", for: .normal)
        openButton.addTarget(self, action: #selector(didTapOpenButton), for: .touchUpInside)
    }
    
    private func setupOpenButtonConstraint() {
        openButton.pin
            .bottom()
            .horizontally()
            .height(40)
    }
    
    private func setupPlaceMarkImage() {
        placeMarkImage.image = UIImage(named: "LocationPointer")
    }
    
    private func setupPlaceMarkImageConstraint() {
        placeMarkImage.pin
            .left()
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.AddressLabel.fontSize / Constants.LocationPoint.ratio)
    }
    
    private func setupPlaceMarkViewContainer() {
        placeMarkViewContainer.pin
            .top()
            .left()
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.AddressLabel.fontSize)
    }
    
    private func setupPlaceAddressLabel() {
        placeAddressLabel.tintColor = .defaultBlackColor
        placeAddressLabel.font = .postPlaceAddressLabel
        placeAddressLabel.textAlignment = .left
    }
    
    private func setupPlaceAddressLabelConstraint() {
        placeAddressLabel.pin
            .after(of: placeMarkViewContainer, aligned: .top)
            .left()
            .height(Constants.AddressLabel.fontSize)
            .width(Constants.Display.blockWidth - Constants.AddressLabel.fontSize)
    }
    
    private func setupScoreImage() {
        for _ in 0...4 {
            let temp = UIView()
            temp.backgroundColor = .white
            temp.layer.cornerRadius = 9
            temp.layer.borderWidth = 2
            temp.layer.borderColor = UIColor.defaultRedColor.cgColor
            scoreImage.append(temp)
        }
    }
    
    private func setupScoreImageConstraint() {
        scoreImage[0].pin
            .left()
            .top()
            .height(2 * Constants.ScoreImage.radius)
            .width(2 * Constants.ScoreImage.radius)
        for i in 1...4 {
            scoreImage[i].pin
                .height(2 * Constants.ScoreImage.radius)
                .width(2 * Constants.ScoreImage.radius)
                .after(of: scoreImage[i-1], aligned: .top)
                .marginLeft(4)
                .vCenter()
        }
    }
    
    private func configureScoreImage(number: Int, color: UIColor) {
        for i in 0..<number {
            scoreImage[i].backgroundColor = color
        }
    }
    
    private func setupScoreLabel() {
        scoreLabel.tintColor = .defaultBlackColor
        scoreLabel.font = .postScoreLabel
        scoreLabel.textAlignment = .left
    }
    
    private func setupScoreLabelConstraint() {
        scoreLabel.pin
            .height(2 * Constants.ScoreImage.radius)
            .after(of: scoreImage[4], aligned: .top)
            
            .horizontally()
            .marginLeft(Constants.ScoreImage.betweenPadding)
    }
    
    @objc func didTapOpenButton() {
        openDelegate.didTapOpen(sender: self)
    }
}

extension MyAccountPostCell {
    struct Constants {
        
        struct OpenButton {
            static let cornerRadius: CGFloat = 8
            static let fontSize: CGFloat = 14
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
            static let cornerRadius: CGFloat = 4
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
            static let radius: CGFloat = 9
            static let betweenPadding: CGFloat = 6
        }
        
        struct HeaderLine {
            static let width: CGFloat = 1
        }
        
        struct MainImage {
            static let cornerRadius: CGFloat = 8
            static let topPadding: CGFloat = 12
        }
        
        struct SeparatorLine {
            static let width: CGFloat = 8
        }
    }
}
