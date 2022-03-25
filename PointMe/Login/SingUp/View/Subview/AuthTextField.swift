import UIKit

final class AuthTextField: UITextField {
    
    private let widthUnderline: CGFloat = 1.0

    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        drawUnderline()
        setupFontInput()
        
    }
    
    
    private func setupFontInput() {
        font = .textFieldInput
        textColor = .textFieldInputColor
    }
      
    
    private func drawUnderline() {
        let underlineView: UIView = UIView()
        
        underlineView.frame = CGRect(
            x: 0,
            y: frame.size.height - widthUnderline,
            width: frame.size.width,
            height: widthUnderline
        )
        underlineView.backgroundColor = .black
        
        addSubview(underlineView)
    }
      
    
    override public func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        
        let placeholderLabel: UILabel = UILabel()
        placeholderLabel.font = .textFieldPlaceholderFont
        placeholderLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: rect.size.width,
            height: rect.size.height
        )
        
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .textFieldPlaceholderColor
        
        placeholder = nil
        
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }
      
    
    override public func drawText(in rect: CGRect) {
        textAlignment = .left
        contentVerticalAlignment = .bottom
    }
      
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = widthUnderline + 1.0
        let textInsetX: CGFloat = 1.5
        
        textAlignment = .left
        contentVerticalAlignment = .bottom
        
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }

    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = widthUnderline + 1.0
        let textInsetX: CGFloat = 1.5
        
        textAlignment = .left
        contentVerticalAlignment = .bottom
        
        return bounds.insetBy(dx: textInsetX, dy: insetForY)
    }
}
