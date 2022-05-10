import Foundation
import UIKit

final class PostPreviewCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let postDateLabel = UILabel()
    private let lineView = UIView()
    private let containerPublicationInformationView = UIView()
    private let postImageView = UIImageView()
    private let numberOfPhotosView = UIView()
    private let numberOfPhotosLabel = UILabel()
    private let containerImageView = UIView()
    private let titleLabel = UILabel()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    private let markImageView: [UIImageView] = [UIImageView(),
                                                UIImageView(),
                                                UIImageView(),
                                                UIImageView(),
                                                UIImageView()]
    private let markLabel = UILabel()
    private let containerMarkView = UIView()
    private let openReviewButton = UIButton(type: .system)
    private let containerPostContentView = UIView()
    private let containerPublicationContentView = UIView()
    private let model: PostPreviewCellModel = PostPreviewCellModel()
    var delegateTapButton: PostPreviewButtonTapDelegate? = nil
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        usernameLabel.text = nil
        postDateLabel.text = nil
        numberOfPhotosLabel.text = nil
        titleLabel.text = nil
        locationLabel.text = nil
        markLabel.text = nil
        
        markImageView.forEach {
            $0.image = UIImage(systemName: "circle")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerPublicationInformationView.pin
            .horizontally()
            .height(Constants.ContainerPublicationInformationView.containerPublicationInformationViewHeight)
         
        avatarImageView.pin
            .top(Constants.ContainerPublicationInformationView.avatarImageViewTop)
            .left(Constants.ContainerPublicationInformationView.avatarImageViewLeft)
            .width(Constants.ContainerPublicationInformationView.avatarImageViewSize.width)
            .height(Constants.ContainerPublicationInformationView.avatarImageViewSize.height)
        
        usernameLabel.pin
            .topRight()
            .after(of: avatarImageView)
            .margin(Constants.ContainerPublicationInformationView.usernameLabelMargin)
            .height(Constants.ContainerPublicationInformationView.usernameLabelHeight)
        
        postDateLabel.pin
            .below(of: usernameLabel)
            .after(of: avatarImageView)
            .right(Constants.ContainerPublicationInformationView.postDateLabelRight)
            .marginLeft(Constants.ContainerPublicationInformationView.postDateLabelMarginLeft)
            .height(Constants.ContainerPublicationInformationView.postDateLabelHeight)
        
        lineView.pin
            .horizontally()
            .bottom()
            .height(Constants.ContainerPublicationInformationView.lineViewHeight)
        

        markImageView[0].pin
            .top(Constants.ContainerMarkView.markImageViewTop)
            .left()
            .height(Constants.ContainerMarkView.markImageViewSize.height)
            .width(Constants.ContainerMarkView.markImageViewSize.width)
        
        markImageView[1].pin
            .top(Constants.ContainerMarkView.markImageViewTop)
            .after(of: markImageView[0])
            .height(Constants.ContainerMarkView.markImageViewSize.height)
            .width(Constants.ContainerMarkView.markImageViewSize.width)
        
        markImageView[2].pin
            .top(Constants.ContainerMarkView.markImageViewTop)
            .after(of: markImageView[1])
            .height(Constants.ContainerMarkView.markImageViewSize.height)
            .width(Constants.ContainerMarkView.markImageViewSize.width)
        
        markImageView[3].pin
            .top(Constants.ContainerMarkView.markImageViewTop)
            .after(of: markImageView[2])
            .height(Constants.ContainerMarkView.markImageViewSize.height)
            .width(Constants.ContainerMarkView.markImageViewSize.width)
        
        markImageView[4].pin
            .top(Constants.ContainerMarkView.markImageViewTop)
            .after(of: markImageView[3])
            .height(Constants.ContainerMarkView.markImageViewSize.height)
            .width(Constants.ContainerMarkView.markImageViewSize.width)
        
        markLabel.pin
            .top()
            .after(of: markImageView[4])
            .marginLeft(Constants.ContainerMarkView.markLabelMarginLeft)
            .height(Constants.ContainerMarkView.markLabelSize.height)
            .width(Constants.ContainerMarkView.markLabelSize.width)
        
        if postImageView.image == nil {
            
            containerImageView.isHidden = true
                        
            containerPublicationContentView.pin
                 .below(of: containerPublicationInformationView)
                 .height(Constants.WithoutImage.containerPublicationContentViewHeight)
                 .horizontally()
            
            containerPostContentView.pin
                .top(Constants.WithoutImage.ContainerPostContentView.containerPostContentViewTop)
                .bottom(Constants.WithoutImage.ContainerPostContentView.containerPostContentViewBottom)
                .right(Constants.WithoutImage.ContainerPostContentView.containerPostContentViewRight)
                .left(Constants.WithoutImage.ContainerPostContentView.containerPostContentViewLeft)
            
            titleLabel.pin
                .top()
                .horizontally()
                .height(Constants.WithoutImage.ContainerPostContentView.titleLabelHeight)
            
            locationImageView.pin
                .below(of: titleLabel)
                .marginTop(Constants.WithoutImage.ContainerPostContentView.locationImageViewMarginTop)
                .left()
                .width(Constants.WithoutImage.ContainerPostContentView.locationImageViewSize.width)
                .height(Constants.WithoutImage.ContainerPostContentView.locationImageViewSize.height)
            
            locationLabel.pin
                .below(of: titleLabel)
                .after(of: locationImageView)
                .marginTop(Constants.WithoutImage.ContainerPostContentView.locationLabelMarginTop)
                .marginLeft(Constants.WithoutImage.ContainerPostContentView.locationLabelMarginLeft)
                .right(containerPublicationContentView.frame.width/2-10)
                .height(Constants.WithoutImage.ContainerPostContentView.locationLabelHeight)
            
            containerMarkView.pin
                .below(of: titleLabel)
                .marginTop(Constants.WithoutImage.ContainerPostContentView.containerMarkViewMarginTop)
                .left(containerPublicationContentView.frame.width/2)
                .right()
                .height(Constants.WithoutImage.ContainerPostContentView.containerMarkViewHeight)
            
            openReviewButton.pin
                .below(of: containerMarkView)
                .marginTop(Constants.WithoutImage.ContainerPostContentView.openReviewButtonMarginTop)
                .horizontally()
                .height(Constants.WithoutImage.ContainerPostContentView.openReviewButtonHeight)
        }
        else {

            containerPublicationContentView.pin
                 .below(of: containerPublicationInformationView)
                 .height(Constants.WithImage.containerPublicationContentViewHeight)
                 .horizontally()
            
            containerImageView.isHidden = false
            containerImageView.pin
                .vCenter()
                .height(Constants.WithImage.ContainerImageView.containerImageViewSize.height)
                .width(Constants.WithImage.ContainerImageView.containerImageViewSize.width)
                .left(Constants.WithImage.ContainerImageView.containerImageViewLeft)
            
            postImageView.pin
                .all()
            
            numberOfPhotosView.pin
                .right(Constants.WithImage.ContainerImageView.numberOfPhotosViewRight)
                .bottom(Constants.WithImage.ContainerImageView.numberOfPhotosViewBottom)
                .height(Constants.WithImage.ContainerImageView.numberOfPhotosViewSize.height)
                .width(Constants.WithImage.ContainerImageView.numberOfPhotosViewSize.width)
            
            numberOfPhotosLabel.pin
                .right(Constants.WithImage.ContainerImageView.numberOfPhotosLabelRight)
                .bottom(Constants.WithImage.ContainerImageView.numberOfPhotosLabelBottom)
                .height(Constants.WithImage.ContainerImageView.numberOfPhotosLabelSize.height)
                .width(Constants.WithImage.ContainerImageView.numberOfPhotosLabelSize.width)

            containerPostContentView.pin
                .top()
                .bottom()
                .right()
                .after(of: containerImageView)
                .margin(Constants.WithImage.ContainerPostContentView.containerPostContentViewMargin)
            
            titleLabel.pin
                .top()
                .horizontally()
                .height(Constants.WithImage.ContainerPostContentView.titleLabelHeight)
            
            locationImageView.pin
                .below(of: titleLabel)
                .marginTop(Constants.WithImage.ContainerPostContentView.locationImageViewMarginTop)
                .left()
                .width(Constants.WithImage.ContainerPostContentView.locationImageViewSize.width)
                .height(Constants.WithImage.ContainerPostContentView.locationImageViewSize.height)
            
            locationLabel.pin
                .below(of: titleLabel)
                .after(of: locationImageView)
                .marginTop(Constants.WithImage.ContainerPostContentView.locationLabelMarginTop)
                .marginLeft(Constants.WithImage.ContainerPostContentView.locationLabelMarginLeft)
                .right()
                .height(Constants.WithImage.ContainerPostContentView.locationLabelHeight)
            
            containerMarkView.pin
                .below(of: locationLabel)
                .marginTop(Constants.WithImage.ContainerPostContentView.containerMarkViewMarginTop)
                .horizontally()
                .height(Constants.WithImage.ContainerPostContentView.containerMarkViewHeight)
            
            openReviewButton.pin
                .below(of: containerMarkView)
                .marginTop(Constants.WithImage.ContainerPostContentView.openReviewButtonMarginTop)
                .horizontally()
                .height(Constants.WithImage.ContainerPostContentView.openReviewButtonHeight)
        }

    }
    
    // MARK: - Private
    
    private func setupViews() {
        [avatarImageView, usernameLabel, postDateLabel, lineView].forEach {
            containerPublicationInformationView.addSubview($0)
        }
        addSubview(containerPublicationInformationView)
        
        [postImageView, numberOfPhotosView, numberOfPhotosLabel].forEach {
            containerImageView.addSubview($0)
        }

        [markImageView[0], markImageView[1], markImageView[2], markImageView[3], markImageView[4], markLabel].forEach {
            containerMarkView.addSubview($0)
        }

        [titleLabel, locationImageView, locationLabel, containerMarkView, openReviewButton].forEach {
            containerPostContentView.addSubview($0)
        }

        [containerImageView, containerPostContentView].forEach {
            containerPublicationContentView.addSubview($0)
        }
        
        contentView.addSubview(containerPublicationContentView)
        
        setupViewsProperties()
    }
    
    private func setupViewsProperties() {
        lineView.backgroundColor = .lineViewColor
        usernameLabel.font = .usernameLabelFont
        usernameLabel.textColor = .usernameLabelColor
        postDateLabel.font = .postDateLabelFont
        postDateLabel.textColor = .postDateLabelColor
        containerPublicationInformationView.backgroundColor = .containerPublicationInformationViewColor
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.image = UIImage(systemName: "person.crop.circle")
        
        containerImageView.layer.cornerRadius = 10
        postImageView.layer.masksToBounds = true
        postImageView.contentMode = .scaleAspectFill
        postImageView.layer.cornerRadius = 10
        numberOfPhotosView.backgroundColor = .numberOfPhotosViewColor
        numberOfPhotosView.layer.cornerRadius = 5
        numberOfPhotosLabel.textColor = .numberOfPhotosLabelColor
        numberOfPhotosLabel.font = .numberOfPhotosLabelFont
        
        titleLabel.font = .titleLabelFont
        titleLabel.textColor = .titleLabelColor
        locationImageView.image = UIImage(named: "LocationPointer")
        locationImageView.tintColor = .locationImageViewColor
        locationImageView.contentMode = .scaleAspectFill

        openReviewButton.backgroundColor = .openReviewButtonColor
        openReviewButton.setTitle("Открыть отзыв", for: .normal)
        openReviewButton.setTitleColor(.white, for: .normal)
        openReviewButton.layer.cornerRadius = 10
        openReviewButton.titleLabel?.font = .openReviewButtonFont
        openReviewButton.addTarget(self, action: #selector(didTapReviewButton), for: .touchUpInside)
        locationLabel.font = .locationLabelFont
        locationLabel.textColor = .locationLabelColor
        markLabel.textColor = .markLabelColor
        
        containerPublicationContentView.backgroundColor = .containerPublicationContentViewColor
    }
    
    func configure(post: PostPreviewModel) {
        if let avatarData = post.avatarData {
            avatarImageView.image = UIImage(data: avatarData)
        }
        
        usernameLabel.text = post.username
        postDateLabel.text = post.postDate
        
        if let previewPostImage = post.postImage {
            postImageView.image = UIImage(data: previewPostImage)
        }

        titleLabel.numberOfLines = 2

        if post.numberOfImages != 0 {
            numberOfPhotosLabel.text = String(post.numberOfImages) + " фото"
            numberOfPhotosLabel.textAlignment = .center
        }

        titleLabel.text = post.title
        locationLabel.text = post.location
        
        markImageView.forEach {
            $0.image = UIImage(systemName: "circle")
            $0.tintColor = .markImageViewColor
        }
        markLabel.text = String(post.mark) + "/5"

        if post.mark != 0 {
            for i in 0..<post.mark {
                markImageView[i].image = UIImage(systemName: "circle.fill")
            }
        }
    }
    
    @objc private func didTapReviewButton() {
        print("tapBUUUTTTTOOON")
        delegateTapButton?.didTapOpenButton(sender: self)
    }
}


private extension PostPreviewCell {
    struct Constants {
        struct ContainerPublicationInformationView {
            static let containerPublicationInformationViewHeight: CGFloat = 71
            
            static let avatarImageViewTop: CGFloat = 10
            static let avatarImageViewLeft: CGFloat = 10
            static let avatarImageViewSize: CGSize = CGSize(width: 50, height: 50)
            
            static let usernameLabelMargin: CGFloat = 10
            static let usernameLabelHeight: CGFloat = 30
            
            static let postDateLabelRight: CGFloat = 10
            static let postDateLabelMarginLeft: CGFloat = 10
            static let postDateLabelHeight: CGFloat = 20
            
            static let lineViewHeight: CGFloat = 1
        }
        
        struct ContainerMarkView {
            static let markImageViewTop: CGFloat = 5
            static let markImageViewSize: CGSize = CGSize(width: 20, height: 20)
            
            static let markLabelMarginLeft: CGFloat = 5
            static let markLabelSize: CGSize = CGSize(width: 30, height: 30)
        }
        
        struct WithoutImage {
            static let containerPublicationContentViewHeight: CGFloat = 125
            
            struct ContainerPostContentView {
                static let containerPostContentViewTop: CGFloat = 10
                static let containerPostContentViewBottom: CGFloat = 10
                static let containerPostContentViewRight: CGFloat = 10
                static let containerPostContentViewLeft: CGFloat = 10
                
                static let titleLabelHeight: CGFloat = 25
                
                static let locationImageViewMarginTop: CGFloat = 10
                static let locationImageViewSize: CGSize = CGSize(width: 15, height: 15)
                
                static let locationLabelMarginTop: CGFloat = 7.5
                static let locationLabelMarginLeft: CGFloat = 10
                static let locationLabelHeight: CGFloat = 20
                
                static let containerMarkViewMarginTop: CGFloat = 5
                static let containerMarkViewHeight: CGFloat = 30
                
                static let openReviewButtonMarginTop: CGFloat = 5
                static let openReviewButtonHeight: CGFloat = 40
            }
        }
        
        struct WithImage {
            static let containerPublicationContentViewHeight: CGFloat = 170
            
            struct ContainerImageView {
                static let containerImageViewSize: CGSize = CGSize(width: 150, height: 150)
                static let containerImageViewLeft: CGFloat = 10
                
                static let numberOfPhotosViewRight: CGFloat = 10
                static let numberOfPhotosViewBottom: CGFloat = 10
                static let numberOfPhotosViewSize: CGSize = CGSize(width: 60, height: 20)
                
                static let numberOfPhotosLabelRight: CGFloat = 10
                static let numberOfPhotosLabelBottom: CGFloat = 10
                static let numberOfPhotosLabelSize: CGSize = CGSize(width: 60, height: 20)
                
            }
            
            struct ContainerPostContentView {
                static let containerPostContentViewMargin: CGFloat = 10
                
                static let titleLabelHeight: CGFloat = 45
                
                static let locationImageViewMarginTop: CGFloat = 5
                static let locationImageViewSize: CGSize = CGSize(width: 20, height: 20)
                
                static let locationLabelMarginTop: CGFloat = 5
                static let locationLabelMarginLeft: CGFloat = 10
                static let locationLabelHeight: CGFloat = 20
                
                static let containerMarkViewMarginTop: CGFloat = 5
                static let containerMarkViewHeight: CGFloat = 30
                
                static let openReviewButtonMarginTop: CGFloat = 5
                static let openReviewButtonHeight: CGFloat = 40
            }
        }
        
        
        
    }
}
