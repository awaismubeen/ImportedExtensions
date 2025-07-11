//
//  Extensions.swift
//  NoteBook
//
//  Created by AM on 11/07/2025.
//

import Foundation

#if os(macOS)
import AppKit

extension NSView {
    @available(OSX 10.13, *)
    @IBInspectable var TopLeft: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMaxYCorner]
        }
    }
    @IBInspectable var BottomLeftRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    @IBInspectable var TopLeftRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
    @available(OSX 10.13, *)
    @IBInspectable var TopRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }
    
    @available(OSX 10.13, *)
    @IBInspectable var BottomLeft: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    @available(OSX 10.13, *)
    @IBInspectable var BottomRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMaxXMinYCorner]
        }
    }
    @IBInspectable var bgColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: NSColor? {
        get {
            if let colorRef = self.layer?.shadowColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set{
            self.wantsLayer = true
            self.shadow = NSShadow()
            self.layer?.shadowOpacity = 0.5
            self.layer?.shadowColor = newValue?.cgColor
            self.layer?.shadowOffset = NSMakeSize(1, -1)
            self.layer?.shadowRadius = 3
        }
    }
    @IBInspectable var cRadius: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set{
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
        }
    }
    @IBInspectable var borderW: CGFloat {
        get{
            return self.layer?.borderWidth ?? 0.0
        }set{
            self.wantsLayer = true
            self.layer?.borderWidth = newValue
        }
    }
    @IBInspectable var borderColour: NSColor? {
        get{
            if let colorRef = self.layer?.borderColor {
                return NSColor(cgColor: colorRef)
            }else{
                return nil
            }
        }set {
            self.wantsLayer = true
            self.layer?.borderColor = newValue?.cgColor
        }
    }
}
@objc extension NSView {
    var center: CGPoint {
        get { return CGPoint(x: NSMidX(frame), y: NSMidY(frame)) }
        set {setFrameOrigin(CGPoint(x: newValue.x - frame.width / 2.0, y: newValue.y - frame.height / 2.0))}
    }
    func setAnchorPoint (anchorPoint:CGPoint){
        if let layer = self.layer{
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())
            var position = layer.position
            position.x -= oldPoint.x
            position.x += newPoint.x
            position.y -= oldPoint.y
            position.y += newPoint.y
            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
}
extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        
        return image
    }
    convenience init?(gradientColors: [NSColor], imageSize: NSSize,_ angle:CGFloat? = 0.0) {
        guard let gradient = NSGradient(colors: gradientColors) else { return nil }
        let rect = NSRect(origin: CGPoint.zero, size: imageSize)
        self.init(size: rect.size)
        let path = NSBezierPath(rect: rect)
        self.lockFocus()
        gradient.draw(in: path, angle: angle ?? 10.0)
        self.unlockFocus()
    }
    func resizeTo(width: CGFloat, height: CGFloat) -> NSImage {
        let ratioX = width / size.width
        let ratioY = height / size.height
        let ratio = ratioX < ratioY ? ratioX : ratioY
        let newHeight = size.height * ratio
        let newWidth = size.width * ratio
        let canvasSize = CGSize(width: newWidth, height: newHeight)
        let img = NSImage(size: canvasSize)
        img.lockFocus()
        let context = NSGraphicsContext.current
        context?.imageInterpolation = .high
        draw(in: NSRect(origin: .zero, size: NSSize(width: newWidth,height: newHeight)), from: NSRect(origin: .zero, size: size) , operation: .copy, fraction: 1)
        img.unlockFocus()
        return img
    }
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    var jpegData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    func jpegWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try jpegData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension NSView {
    func addShimmerAnimation(shimmerColor: NSColor = .orange) {
        self.wantsLayer = true
        guard let layer = self.layer else { return }
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: -0.02)
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*3, height: self.bounds.size.height)
        let lowerAlpha: CGFloat = 0.8
        let solid = shimmerColor.withAlphaComponent(1).cgColor
        let clear = shimmerColor.withAlphaComponent(lowerAlpha).cgColor
        gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
        gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]
        let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        theAnimation.duration = 1.5
        theAnimation.repeatCount = .infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = true
        theAnimation.fillMode = .forwards
        theAnimation.fromValue = -self.frame.size.width * 2
        theAnimation.toValue =  0
        gradient.add(theAnimation, forKey: "animateLayer")
        layer.mask = gradient
    }
}

extension NSImage {
    
    func saveImage(as fileName: String, fileType: NSBitmapImageRep.FileType = .jpeg, at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) -> Bool {
        guard let tiffRepresentation = tiffRepresentation, !fileName.isEmpty else {
            
            return false }
        do {
            try NSBitmapImageRep(data: tiffRepresentation)?
                .representation(using: fileType, properties: [:])?
                .write(to: directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension))
            return true
        } catch {
            
            return false
        }
    }
    
    func saveImage(asFileName fileName: String,
                   withFileType fileType: NSBitmapImageRep.FileType = .jpeg,
                   atDirectoryURL directory: URL) -> URL? {
        guard let tiffRepresentation = tiffRepresentation, !fileName.isEmpty else {
            return nil
        }
        do {
            let url = directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension)
            try NSBitmapImageRep(data: tiffRepresentation)?
                .representation(using: fileType, properties: [:])?
                .write(to: url)
            return url
        } catch {
            return nil
        }
    }
    
    func tintedImageWithColor(_ color: NSColor) -> NSImage {
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .destinationIn, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func tintedImageWithImage(_ image: NSImage) -> NSImage {
        
        let overlayImage = resizeImage(image: image, w: Int(size.width), h: Int(size.height))
        
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        
        newImage.drawRepresentation(overlayImage.representations.first!, in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .destinationIn, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func resizeImage(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.copy, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    /**
     Derives new size for an image constrained to a maximum dimension while keeping AR constant
     
     - parameter maxDimension: maximum horizontal or vertical dimension for new size
     
     - returns: new size
     */
    func aspectFitSizeForMaxDimension(_ maxDimension: CGFloat) -> NSSize {
        var width =  size.width
        var height = size.height
        if size.width > maxDimension || size.height > maxDimension {
            let aspectRatio = size.width/size.height
            width = aspectRatio > 0 ? maxDimension : maxDimension*aspectRatio
            height = aspectRatio < 0 ? maxDimension : maxDimension/aspectRatio
        }
        return NSSize(width: width, height: height)
    }
}
extension NSBitmapImageRep.FileType {
    var pathExtension: String {
        switch self {
        case .bmp:
            return "bmp"
        case .gif:
            return "gif"
        case .jpeg:
            return "jpg"
        case .jpeg2000:
            return "jp2"
        case .png:
            return "png"
        case .tiff:
            return "tif"
        @unknown default:
            return ""
        }
    }
}
extension String{
    func image() -> NSImage{
        return NSImage(named: self) ?? NSImage()
    }
    func SizeOf_String( font: NSFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size;
    }
    
    func width(forHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString()   }
        do {
            
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func height(width:CGFloat)->CGFloat{
        let font = NSFont.systemFont(ofSize: 16.0) // Specify the font

        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude) // Specify the width and a very large height
        let options = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) // Specify the options

        let attributes = [NSAttributedString.Key.font: font] // Specify the attributes

        let boundingRect = NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)

        let height = ceil(boundingRect.height) // Extract the height and round up to the nearest pixel
        
        return height + 8

    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Notification.Name{
    static let refreshPlans = Notification.Name("refreshPlans")
    static let minimizeSider = Notification.Name(rawValue: "minimizeSider")
    static let themeChanged = Notification.Name(rawValue: "themeChanged")
    static let showHUD = Notification.Name(rawValue: "showHUD")
    static let hideHUD = Notification.Name(rawValue: "hideHUD")
    static let apperanceChanged = Notification.Name(rawValue: "apperanceChanged")
    static let fbValuesFetched = Notification.Name(rawValue: "fbValuesFetched")
    static let internetIsBack = Notification.Name(rawValue: "internetIsBack")
}
//extension Notification.Name {
//    static let ClosedPremiumVC = Notification.Name("ClosedPremiumVC")
//    static let disableUI = Notification.Name("disableUI")
//    static let enableUI = Notification.Name("enableUI")
//    static let eBookGenerationCompleted = Notification.Name("eBookGenerationCompleted")
//    static let queryFromExtension = Notification.Name("queryFromExtension")
//
//
//}

extension NSColor {
    class func fromHex(hex: Int,_ alpha: Float = 1) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    func copyColor() -> NSColor {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    var toHex: String? {
        return toHex()
    }
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        if components.count >= 4 {
            a = Float(components[3])
        }
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension NSCollectionView{
    func hideVerticalScrollView(){
        self.enclosingScrollView?.verticalScroller?.alphaValue = 0.0
    }
    func hideHorizontalScrollView(){
        self.enclosingScrollView?.horizontalScroller?.alphaValue = 0.0
    }
}


extension NSViewController {
    
    func showToast(message: String, font: NSFont) {
        let padding: CGFloat = 20
        let maxWidth: CGFloat = 400
        let yOffset: CGFloat = 100

        // Create the label to measure text size
        let messageLabel = NSTextField()
        messageLabel.stringValue = message
        messageLabel.font = font
        messageLabel.isEditable = false
        messageLabel.isBezeled = false
        messageLabel.drawsBackground = false
        messageLabel.alignment = .center
        messageLabel.lineBreakMode = .byWordWrapping

        // Calculate text size
        let textSize = messageLabel.sizeThatFits(NSSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let labelWidth = min(textSize.width + padding, maxWidth)
        let labelHeight = textSize.height

        // Create toast container view
        let toastView = NSView(frame: CGRect(
            x: (self.view.frame.width - labelWidth - padding) / 2,
            y: yOffset,
            width: labelWidth + padding,
            height: labelHeight + padding / 2
        ))
        toastView.wantsLayer = true
        toastView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.85).cgColor
        toastView.layer?.cornerRadius = toastView.frame.height / 2

        // Recreate the label to add to the view
        let toastLabel = NSTextField(frame: CGRect(
            x: padding / 2,
            y: padding / 4,
            width: labelWidth,
            height: labelHeight
        ))
        toastLabel.stringValue = message
        toastLabel.font = font
        toastLabel.isEditable = false
        toastLabel.isBezeled = false
        toastLabel.drawsBackground = false
        toastLabel.textColor = .white
        toastLabel.alignment = .center
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.usesSingleLineMode = false
        toastLabel.stringValue = message
        toastView.addSubview(toastLabel)
        self.view.addSubview(toastView)

        // Initial alpha
        toastView.alphaValue = 1.0

        // Animate fade out and remove
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 2.5
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            toastView.animator().alphaValue = 0.0
        }, completionHandler: {
            toastView.removeFromSuperview()
        })
    }

}

extension NSApplication {
    var mainApplication: Bool {
        return (self.isActive && NSRunningApplication.current.bundleIdentifier == "com.ca.Chat-Bot")
    }
}


extension NSView {
    func addShadow(shadowColor: NSColor = .lightGray,
                   shadowOpacity: Float = 0.5,
                   shadowOffset: CGSize = CGSize(width: -6, height: 5),
                   shadowRadius: CGFloat = 5) {
        // Configure shadow properties
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layer?.shadowColor = shadowColor.cgColor
        self.layer?.shadowOpacity = shadowOpacity
        self.layer?.shadowOffset = shadowOffset
        self.layer?.shadowRadius = shadowRadius

        // Make sure to clip to bounds to ensure the shadow is visible
        
    }
    
    func updateShadowColor(color: NSColor) {
         // self.layer?.shadowColor = color.cgColor
    }
}

extension NSCollectionView {
    func scrollToLastItem() {
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
    }
    
    func scrollToFirstItem(){
        guard self.numberOfItems(inSection: 0) > 0 else {return}
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.scrollToItems(at: [firstIndexPath], scrollPosition: .top)
    }
    
    func scrollToLastItem(complition:@escaping()->()) {
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0 // Adjust the duration as needed
            self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
        }, completionHandler: {
            complition()
        })
    }
    
    func scrollToLastItemWithAnimation(complition:@escaping()->()){
        
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 3.0 // Adjust the duration as needed
            self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
        }, completionHandler: {
            complition()
        })
    }
}

extension String{
    
    func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
}
extension Dictionary where Key: Comparable {
    func sortedByKey() -> [Key: Value] {
        return Dictionary(uniqueKeysWithValues: sorted { $0.key < $1.key })
    }
}

extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.value == value }?.key
    }
}

extension NSFont {
    func fontSizeThatFits(string: String, inLabelWidth tableWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: tableWidth, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: self]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let boundingRect = attributedString.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading])
        let requiredWidth = ceil(boundingRect.size.width)
        let availableWidth = tableWidth
        let scale = availableWidth / requiredWidth
        let scaledFontSize = self.pointSize * scale
        return scaledFontSize
    }
}

extension Date{
    func getTimeFromDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // "a" for AM/PM format
        let timeString = dateFormatter.string(from: self)
        return timeString
    }
}

extension String{
    
    func copyToPasteBoard(){
        let pasteboard = NSPasteboard.general
        // Clear the pasteboard
        pasteboard.clearContents()
        // Set the string you want to copy
        let stringToCopy = self
        // Write the string to the pasteboard
        pasteboard.writeObjects([stringToCopy as NSString])
    }
}

extension String{
    func maxConsecutiveNewlines() -> Int {
        var maxCount = 0
        var currentCount = 0
        
        for character in self {
            if character == "\n" {
                currentCount += 1
                if currentCount > maxCount {
                    maxCount = currentCount
                }
            } else {
                currentCount = 0
            }
        }
        
        return maxCount
    }

}

extension NSView {
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }

    func doGlowAnimation(withColor color: NSColor, withEffect effect: GlowEffect = .normal) {
        wantsLayer = true
        layer?.masksToBounds = false
        layer?.shadowColor = color.withAlphaComponent(0.5).cgColor
        layer?.shadowRadius = 0
        layer?.shadowOpacity = 1
        layer?.shadowOffset = .zero
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()+0.5
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        glowAnimation.isRemovedOnCompletion = true
        layer?.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
extension NSButton {
    func shake() {
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "position.x"
        shakeAnimation.values = [0, 10, -10, 10, 0]
        shakeAnimation.keyTimes = [0, NSNumber(value: 1.0 / 6.0), NSNumber(value: 3.0 / 6.0), NSNumber(value: 5.0 / 6.0), 1]
        shakeAnimation.duration = 0.3
        shakeAnimation.isAdditive = true
        
        self.layer?.add(shakeAnimation, forKey: "shake")
    }
}


extension String {
    func calculateWidth(_ font: NSFont = NSFont.systemFont(ofSize: 16), _ height:CGFloat = 40) -> CGFloat {
        let maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let rect = (self as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )
        print("Wrapped width: \(rect.width), height: \(rect.height)")
        return rect.width
    }
    
    func icon() -> NSImage?{
        NSImage(named: self)
    }
}


extension Date{
    func stringDate() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        return formatter.string(from: self)
    }
}

extension Notification.Name{
    static let windowDidResize = Notification.Name("windowDidResize")
    static let menuDidChange = Notification.Name("menuDidChange")
}

extension String {
    func truncated(afterWords count: Int) -> String {
        let words = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        guard words.count > count else { return self }
        return words.prefix(count).joined(separator: " ") + "..."
    }
    
    func sanitizedFileName() -> String {
        // Replace all characters that are NOT letters or numbers with underscores
        let pattern = "[^a-zA-Z0-9]+"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        
        let sanitized = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "_") ?? self
        
        // Optional: Remove consecutive underscores and trim leading/trailing underscores
        let collapsed = sanitized.replacingOccurrences(of: "_+", with: "_", options: .regularExpression)
        return collapsed.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }

}


extension Decimal {
    var toDouble: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

enum NoteBookError: Error {
    
    case fileNotFound
    case invalidInput(message: String)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "The requested file could not be found."
        case .invalidInput(let message):
            return message
        }
    }
}
#else
//Extensions IOS

import Foundation
import UIKit
import PDFKit

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
public extension Array where Element == Int {
    static func generateRandom(start:Int,size: Int) -> [Int] {
        guard size > 0 else {
            return [Int]()
        }
        return Array(start..<size).shuffled()
    }
}



extension UIView {
    func dropShadow(scale: Bool = true ,shadow:Float) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadow;
        layer.shadowRadius = 4.0;
        layer.masksToBounds = false;
    }
    func setRadiusWithShadow(_ radius: CGFloat? = nil) { // this method adds shadow to right and bottom side of button
        self.layer.cornerRadius = radius ?? 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func rads(rad:CGFloat) -> Void {
        layer.cornerRadius = rad
    }
    
}
extension UIView {
    
    var getPNGSnapshot: UIImage? {
        self.layer.isOpaque = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 2)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = image?.pngData() {
            return UIImage(data: imageData)
        }
        return nil
        
    }
    
    var getJPGSnapshot: UIImage? {
        //        var screenshotImage :UIImage?
        //        let layer = self.layer
        //        let scale = UIScreen.main.scale
        //        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        //        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        //        layer.render(in:context)
        //        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        return screenshotImage
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
        
    }
    func addMainLines() {
        if let parentView = self.superview{
            let sX = CGPoint(x: 0, y: parentView.bounds.height/2)
            let eX = CGPoint(x: parentView.bounds.width, y: parentView.bounds.height/2)
            let sY = CGPoint(x: parentView.bounds.width/2, y: 0)
            let eY = CGPoint(x: parentView.bounds.width/2, y: parentView.bounds.height)
            self.addLayer(parentView,startX: sX, endX: eX, startY: sY, endY: eY,name: "ca_main_line")
        }
    }
    private func addLayer(_ view:UIView,startX:CGPoint,endX:CGPoint,startY:CGPoint,endY:CGPoint,name:String) {
        let lineX = CAShapeLayer()
        let lineY = CAShapeLayer()
        let superView = view
        let linePath = UIBezierPath()
        linePath.move(to: startX)
        linePath.addLine(to: endX)
        lineX.path = linePath.cgPath
        lineX.strokeColor = UIColor.purple.cgColor
        lineX.lineWidth = 0.5
        lineX.lineJoin = CAShapeLayerLineJoin.round
        lineX.name = name
        superView.layer.addSublayer(lineX)
        
        let linePathY = UIBezierPath()
        linePathY.move(to: startY)
        linePathY.addLine(to: endY)
        lineY.path = linePathY.cgPath
        lineY.strokeColor = UIColor.purple.cgColor
        lineY.lineWidth = 0.5
        lineY.lineJoin = CAShapeLayerLineJoin.round
        lineY.name = name
        superView.layer.addSublayer(lineY)
    }
    
    func removeLines(view:UIView) {
        if let layers = view.layer.sublayers {
            for layer in layers {
                if(layer.name == "ca_main_line") {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func takeJPGScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context != nil{
            self.layer.render(in:context!)
        }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            
            return image!
        }
        return UIImage()
    }
    
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context != nil{
            self.layer.render(in:context!)
        }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            
            return image!
        }
        return UIImage()
    }
    func takeScreenshortWithFrame(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context != nil{
            self.layer.render(in:context!)
        }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            
            return image!
        }
        return UIImage()
    }
    
    func takeZDScreenshot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context != nil{
            //self.layer.render(in:context!)
        }
        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            
            return image!
        }
        return UIImage()
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    
    func snapshot(of rect: CGRect? = nil,isTransparentImage:Bool = false) -> UIImage?{
        // snapshot entire view
        let aspectRatio = self.frame.size.width/self.frame.size.height
        let h1 = CGFloat(1414.0)
        let w1 = aspectRatio * h1
        let imageSize : CGSize = CGSize(width: w1, height: h1)
        let imageRect = CGRect(x: 0, y: 0, width: w1, height: h1)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1.0)
        //        if(isTransparentImage) {
        //            self.layer.isOpaque = false
        //            self.layer.backgroundColor = UIColor.clear.cgColor
        //            self.backgroundColor = .clear
        //        }
        drawHierarchy(in: imageRect, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        let newX = rect.origin.x * (w1/self.frame.size.width)
        let newY = rect.origin.y * (h1/self.frame.size.height)
        let newWidth = rect.size.width * (w1/self.frame.size.width)
        let newHeight = rect.size.height * (h1/self.frame.size.height)
        //        if()
        // otherwise, grab specified `rect` of image
        let scale = image.scale
        let scaledRect = CGRect(x: newX * scale, y: newY * scale, width: newWidth * scale, height: newHeight * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        let temp =  UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        return temp
    }
    func applyGradient(colours: [UIColor], angle:Float) -> Void {
        self.applyGradient(colours: colours, locations: [0,0.75],angle:angle)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?,angle:Float ) -> Void {
        
        self.removeLayers()
        self.layer.sublayers?.removeAll()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0,y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0,y: 0.5)
        gradient.locations = [ 0.0, 1.0]//locations
        gradient.name = "GradientColorLayer"
        
        gradient.calculatePoints(for: angle * 360 )
        //        let x: Double! = Double(-angle) / 360.0
        //        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        //        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
        //        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
        //        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
        
        //      gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        //    gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        
        //    self.layer.insertSublayer(gradient, at: 0)
        
        self.layer.addSublayer(gradient)
    }
    func removeLayers()
    {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if(layer.name == "GradientColorLayer") {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    func removeLayer(temp: CALayer){
        
    }
    func getPixelColorAtPoint(point:CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var color: UIColor? = nil
        
        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context)
            
            color = UIColor(red: CGFloat(pixel[0])/255.0,
                            green: CGFloat(pixel[1])/255.0,
                            blue: CGFloat(pixel[2])/255.0,
                            alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate()
        }
        return color ?? UIColor.white
    }
}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func makeViewCentered(view: UIView, hConstant : CGFloat = 0.0, yConstant: CGFloat = 0.0 ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: hConstant))
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: yConstant))
    }
    func addSublines() {
        
        if let parentView = self.superview {
            if let layers = parentView.layer.sublayers {
                for layer in layers {
                    if(layer.name == "ca_line" ) {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            let sX2 = CGPoint(x: 0, y: self.center.y)
            let eX2 = CGPoint(x: parentView.bounds.width, y: self.center.y)
            let sY2 = CGPoint(x: self.center.x, y: 0)
            let eY2 = CGPoint(x: self.center.x, y: parentView.bounds.height)
            
            self.addLayer(startX: sX2, endX: eX2, startY: sY2, endY: eY2,name: "ca_line")
        }
    }
    
    func addLayer(startX:CGPoint,endX:CGPoint,startY:CGPoint,endY:CGPoint,name:String) {
        let lineX = CAShapeLayer()
        let lineY = CAShapeLayer()
        
        if let superView = self.superview {
            
            let linePath = UIBezierPath()
            
            linePath.move(to: startX)
            linePath.addLine(to: endX)
            lineX.path = linePath.cgPath
            lineX.strokeColor = UIColor.black.cgColor
            lineX.lineWidth = 1
            lineX.lineJoin = CAShapeLayerLineJoin.round
            lineX.name = name
            superView.layer.addSublayer(lineX)
            
            let linePathY = UIBezierPath()
            linePathY.move(to: startY)
            linePathY.addLine(to: endY)
            lineY.path = linePathY.cgPath
            lineY.strokeColor = UIColor.black.cgColor
            lineY.lineWidth = 1
            lineY.lineJoin = CAShapeLayerLineJoin.round
            lineY.name = name
            superView.layer.addSublayer(lineY)
        }
    }
    func removeLines() {
        if let layers = self.superview?.layer.sublayers {
            for layer in layers {
                if(layer.name == "ca_main_line" || layer.name == "ca_line" ) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
}
extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
}

extension UIColor {
    
    func borderColor() -> UIColor {
        return UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
    func bgColor() -> UIColor {
        return UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    }
    
    
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    func copyColor() -> UIColor {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r, green: g, blue: b, alpha: a)
        
    }
    func getImage(size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
}

public extension CAGradientLayer {
    
    /// Sets the start and end points on a gradient layer for a given angle.
    ///
    /// - Important:
    /// *0°* is a horizontal gradient from left to right.
    ///
    /// With a positive input, the rotational direction is clockwise.
    ///
    ///    * An input of *400°* will have the same output as an input of *40°*
    ///
    /// With a negative input, the rotational direction is clockwise.
    ///
    ///    * An input of *-15°* will have the same output as *345°*
    ///
    /// - Parameters:
    ///     - angle: The angle of the gradient.
    ///
    func calculatePoints(for angle: CGFloat) {
        
        
        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        
        if ang < 0 { ang = 360 + ang }
        
        let n: CGFloat = 0.5
        
        switch ang {
            
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            startPoint = a
            endPoint = b
            
        case 45...135:
            let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            startPoint = a
            endPoint = b
            
        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
            startPoint = a
            endPoint = b
            
        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            startPoint = a
            endPoint = b
            
        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            startPoint = a
            endPoint = b
            
        }
    }
    
    /// Private function to aid with the math when calculating the gradient angle
    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    
    
    // Overloads
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Int) {
        calculatePoints(for: CGFloat(angle))
    }
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Float) {
        calculatePoints(for: CGFloat(angle))
    }
    
    /// Sets the start and end points on a gradient layer for a given angle.
    func calculatePoints(for angle: Double) {
        calculatePoints(for: CGFloat(angle))
    }
    
}
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func lblSize(font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: 10000.0, height: 10000.0)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): font]), context: nil)
        
        return boundingBox.size
    }
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
extension CGFloat {
    //    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
    //        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    //        return result
    //    }
}
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

extension UIColor {
    // MARK: - Initialization
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    // MARK: - Computed Properties
    var toHex: String? {
        return toHex()
    }
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        if components.count >= 4 {
            a = Float(components[3])
        }
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension UITableViewController {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIButton {
    func setTintColor(color: UIColor) {
        let templateImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = color
        self.setImage(templateImage, for: .normal)
        
    }
}
//extension FileManager {
//    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
//        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
//        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
//        return fileURLs
//    }
//}
extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var viewShadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    }
}
extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}
extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? "temp"
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    func lastPathComponent(withExtension: Bool = true) -> String {
        let lpc = self.nsString.lastPathComponent
        return withExtension ? lpc : lpc.nsString.deletingPathExtension
    }
    var nsString: NSString {
        return NSString(string: self)
    }
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString()  }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
internal let DEFAULT_MIME_TYPE = "application/octet-stream"

internal let mimeTypes = [
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "epub": "application/epub+zip",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

internal func MimeType(ext: String?) -> String {
    return mimeTypes[ext?.lowercased() ?? "" ] ?? DEFAULT_MIME_TYPE
}

extension NSURL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension URL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension NSString {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension String {
    public func mimeType() -> String {
        return (self as NSString).mimeType()
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let count =  self.countConsecutiveOccurrences(of: "\n")
        let lineHeight = 20
        return ceil(boundingBox.height + CGFloat(count * lineHeight))
    }
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func countOccurrences(of character: Character) -> Int {
            return self.reduce(0) { $1 == character ? $0 + 1 : $0 }
        }
    
    func countConsecutiveOccurrences(of character: Character) -> Int {
            var consecutiveCount = 0
            var maxConsecutiveCount = 0
            
            for char in self {
                if char == character {
                    consecutiveCount += 1
                    maxConsecutiveCount = max(maxConsecutiveCount, consecutiveCount)
                } else {
                    consecutiveCount = 0
                }
            }
            
            return maxConsecutiveCount
        }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension URL {
    func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
extension FileManager {
    
    enum ContentDate {
        case created, modified, accessed
        
        var resourceKey: URLResourceKey {
            switch self {
            case .created: return .creationDateKey
            case .modified: return .contentModificationDateKey
            case .accessed: return .contentAccessDateKey
            }
        }
    }
    
    func contentsOfDirectory(atURL url: URL, sortedBy: ContentDate, ascending: Bool = false, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [URL]? {
        
        let key = sortedBy.resourceKey
        
        var files = try contentsOfDirectory(at: url, includingPropertiesForKeys: [key], options: options)
        
        try files.sort {
            
            let values1 = try $0.resourceValues(forKeys: [key])
            let values2 = try $1.resourceValues(forKeys: [key])
            
            if let date1 = values1.allValues.first?.value as? Date, let date2 = values2.allValues.first?.value as? Date {
                
                return date1.compare(date2) == (ascending ? .orderedAscending : .orderedDescending)
            }
            return true
        }
        return files
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
extension Double {
    func round(to places: Int) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = places
        numberFormatter.maximumFractionDigits = places
        numberFormatter.roundingMode = .down
        let num = numberFormatter.string(from: NSNumber(value: self)) ?? "0.0"
        
        return Double(num) ?? self
        
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension UIImage{
    func convertImageToPDF(Complition:@escaping(Bool,URL?)->()){
        DispatchQueue.global(qos: .userInitiated).async {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pdfDocument = PDFDocument()
                
                
                // Load or create your UIImage
                // Create a PDF page instance from your image
                let pdfPage = PDFPage(image: self)
                // Insert the PDF page into your document
                pdfDocument.insert(pdfPage!, at: 0)
                
                
                // Get the raw data of your PDF document
                if let data = pdfDocument.dataRepresentation(){
                    let fileName = "\(Date.currentTimeStamp).pdf"
                    // The url to save the data to
                    let uniqueFileName = fileName.getTheUniqueFileName()
                    
                    let url = URL(fileURLWithPath: documentDirectory.appendingPathComponent(uniqueFileName).path)
                    print(url)
                    // Save the data to the url
                    do{
                        try? data.write(to: url)
                        DispatchQueue.main.async {
                            Complition(true,url)
                        }
                    }catch{
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                            Complition(false,nil)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        Complition(false,nil)
                    }
                }
            }
        }
    }
}

extension String{
    func getTheUniqueFileName()->String{
        var newName = self
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var count = 0
        if let dirContents = try? fileManager.contentsOfDirectory(atPath: documentsPath){
            for dirContent in dirContents {
                if dirContent.contains(self){
                    count += 1
                }
            }
        }
        if count == 0{
            return newName
        }else{
            return "\(self)\(count)"
        }
    }
}

extension NSAttributedString {
    func rtf() throws -> Data {
        try data(from: .init(location: 0, length: length),
                 documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf,
                                      .characterEncoding: String.Encoding.utf8])
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension UIColor {
    
    var redComponent: CGFloat {
        var red: CGFloat = 0.0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        
        return red
    }
    
    var greenComponent: CGFloat {
        var green: CGFloat = 0.0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        
        return green
    }
    
    var blueComponent: CGFloat {
        var blue: CGFloat = 0.0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        
        return blue
    }
    
    var alphaComponent: CGFloat {
        var alpha: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        
        return alpha
    }
}

extension Notification.Name{
    static let refreshCategories = Notification.Name("refreshCategories")
    static let resetViews = Notification.Name("resetViews")
    static let subscriptionResults = Notification.Name("subscriptionResults")
}
extension CALayer {
    func getImageOfLayer() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.render(in: UIGraphicsGetCurrentContext()!)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
        UIGraphicsEndImageContext()
        return img
    }
}
extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
extension UIView {
    var snapshotImage: UIImage {
        return asImage()
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


extension NSMutableAttributedString{
    
    func textColor (_ color : UIColor) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .foregroundColor : color
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func letterSpacing(_ sapcing : CGFloat) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .kern : sapcing
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func verticalLineSpacing(_ spacing : CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing // Whatever line spacing you want in points
        let attributes:[NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraphStyle
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func bold(fontSize : CGFloat = 14) -> NSMutableAttributedString {
        
        let boldFont : UIFont = .boldSystemFont(ofSize: fontSize)
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func bold(fontName : String, fontSize : CGFloat = 14) -> NSMutableAttributedString {
        
        var boldFont : UIFont = .boldSystemFont(ofSize: fontSize)
        
        if let cFont = UIFont.init(name: fontName, size: fontSize){
            boldFont = cFont
        }
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        addAttributes(attributes)
        return self
    }
    
    /// Set Regular Style Text
    /// - Parameters:
    ///   - fontName: Name of font
    ///   - fontSize: Size of font
    func normal(fontName : String, fontSize : CGFloat = 14) -> NSMutableAttributedString {
        
        var normalFont : UIFont = .systemFont(ofSize: fontSize)
        
        if  let cFont = UIFont.init(name: fontName, size: fontSize){
            normalFont = cFont
        }
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func applyFont(_ font : UIFont) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font
        ]
        
        addAttributes(attributes)
        return self
    }
    
    
    
    /// Set Regular Style Text
    /// - Parameter fontSize: Size of font
    func normal(fontSize : CGFloat = 14) -> NSMutableAttributedString {
        
        let normalFont : UIFont = .systemFont(ofSize: fontSize)
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func textAlignment (_ alignment : NSTextAlignment) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let attributes:[NSAttributedString.Key : Any] = [
            .paragraphStyle : paragraphStyle
        ]
        addAttributes(attributes)
        return self
    }
    
    /// Text draw margin from Top/Bottom
    /// - Parameter offset: -ive value margins from top, +ive value margins from bottom
    func baseLineOffset (_ offset : CGFloat)  -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .baselineOffset : offset
        ]
        addAttributes(attributes)
        return self
    }
    
    func underLine (style : NSUnderlineStyle) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .underlineStyle : style.rawValue
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func underLine (style : NSUnderlineStyle, withColor color : UIColor) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .underlineStyle : style.rawValue,
            .underlineColor : color
            
        ]
        
        addAttributes(attributes)
        return self
    }
    
    func strikeThrough (style : NSUnderlineStyle) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .strikethroughStyle : style.rawValue
        ]
        
        addAttributes(attributes)
        return self
    }
    fileprivate func addAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        self.addAttributes(attributes, range: NSRange.init(location: 0, length: length))
    }
}
extension UIImage{
    //    func saveImage(as fileName: String, fileType: NSBitmapImageRep.FileType = .jpeg, at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) -> Bool {
    //        guard let tiffRepresentation = tiffRepresentation, !fileName.isEmpty else {
    //
    //            return false }
    //        do {
    //            try NSBitmapImageRep(data: tiffRepresentation)?
    //                .representation(using: fileType, properties: [:])?
    //                .write(to: directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension))
    //            return true
    //        } catch {
    //
    //            print(error)
    //            return false
    //        }
    //    }
    func saveImage(as fileName: String,at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) -> Bool {
        var directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        directoryPath = directory.appendingPathComponent("\(fileName).png")
        if !FileManager.default.fileExists(atPath: directoryPath.path) {
            do {
                try self.pngData()!.write(to: directoryPath as URL)
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
extension UIImage {
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try self.pngData()?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    func jpegWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try  self.jpegData(compressionQuality: 1.0)?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
extension UIViewController {
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
extension UIView {
    
    // ->1
    enum ShimmerDirection: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: ShimmerDirection = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
}

extension UIView {
    func addShadowToBottomEdge(color: UIColor = .lightGray, opacity: Float = 0.4, offset: CGSize = CGSize(width: 0, height: 4), radius: CGFloat = 4) {
        // Add shadow to the bottom edge
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}

extension UIImage {
    
    func toBase64String() -> String? {
        guard let pngData = self.pngData() else { return nil }
        return pngData.base64EncodedString()
    }
    
    func toSVGWrapper(width: CGFloat, height: CGFloat) -> String? {
        guard let base64String = self.toBase64String() else { return nil }
        
        let svg = """
        <svg width="\(Int(width))" height="\(Int(height))" xmlns="http://www.w3.org/2000/svg">
          <image href="data:image/png;base64,\(base64String)" width="\(Int(width))" height="\(Int(height))"/>
        </svg>
        """
        return svg
    }
}


#endif
