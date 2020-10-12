//
//  EditViewController.swift
//  Do Your Bars
//
//  Created by Liliana Terry on 1/1/19.
//  Copyright © 2019 Liliana Terry. All rights reserved.
//

import UIKit
import CoreData

protocol TextEditorDelegate: AnyObject {
    func addItem(newItem: String)
    func deleteSelected()
}

class EditViewController: UIViewController, TextEditorDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var delegate: MainViewController? = nil
    
    let toolKit = UIExtensions()
    
    @IBOutlet var navBar: UIView!
    var metadataView: UIView!
    var song: String!
    var artist: String!
    var album: String!
    var time: String!
    var songArtistLabel: UILabel!
    var albumTimeLabel: UILabel!
    var totalLabel: UILabel!
    var barLengthLabel: UILabel!
    var textView: UITextView!
    var keyboard: KeyboardView!
    var formViewController: AlertViewController!

    var barText: NSAttributedString = NSAttributedString()
    var currTextSize: CGFloat = 0.0
    var textViewBottomAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    var currColor: ColorKeyboardButton = ColorKeyboardButton()
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readCurrentState()
        setupKeyboard()
        setupMetaDataView()
        setupTextView()
        updateSongArtistLabel()
        updateAlbumTimeLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupKeyboard() {
        self.becomeFirstResponder()     // for keyboard
        let frame = self.view.frame
        keyboard = KeyboardView(frame: CGRect(x: 0, y: frame.maxY - (frame.height / 3.0), width: frame.width, height: frame.height / 3.0))
        
        keyboard.addTextViewDelegate(delegate: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//     MARK: - UITextFieldDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5){
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }

    @objc func keyboardWillShow(notification: Notification) {
       NSLayoutConstraint.activate([
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboard.frame.size.height),
        ])
    }

    private func setupMetaDataView()
    {
        let padding = 16.0 as CGFloat
        let internalPadding = 10.0 as CGFloat
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:
        #selector(EditViewController.handleTap))
        
        metadataView = UIView()
        metadataView.backgroundColor = UIExtensions().background
        metadataView.layer.cornerRadius = 10.0
        metadataView.addGestureRecognizer(tapRecognizer)

        totalLabel = UILabel()
        totalLabel.textColor = toolKit.header
        totalLabel.font = toolKit.metadataFont
        totalLabel.textAlignment = NSTextAlignment.left
        
        barLengthLabel = UILabel()
        barLengthLabel.textColor = toolKit.header
        barLengthLabel.font = toolKit.metadataFont
        barLengthLabel.textAlignment = NSTextAlignment.left

        songArtistLabel = UILabel()
        songArtistLabel.text = String(format: "%@%@%@", toolKit.placeholderSong, toolKit.placeholderDivider, toolKit.placeholderArtist)
        songArtistLabel.font = toolKit.metadataFont
        songArtistLabel.textColor = toolKit.headerDemp
        
        albumTimeLabel = UILabel()
        albumTimeLabel.text = String(format: "%@%@%@", toolKit.placeholderAlbum, toolKit.placeholderDivider, toolKit.placeholderTime)
        albumTimeLabel.font = toolKit.metadataFont
        albumTimeLabel.textColor = toolKit.headerDemp
        
        metadataView.addSubview(songArtistLabel)
        metadataView.addSubview(albumTimeLabel)
        metadataView.addSubview(barLengthLabel)
        metadataView.addSubview(totalLabel)
        self.view.addSubview(metadataView)

        metadataView.translatesAutoresizingMaskIntoConstraints = false
        barLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        songArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        albumTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            metadataView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            metadataView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            metadataView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: padding),
            songArtistLabel.leadingAnchor.constraint(equalTo: metadataView.leadingAnchor, constant: padding),
            songArtistLabel.trailingAnchor.constraint(equalTo: metadataView.trailingAnchor, constant: -padding),
            songArtistLabel.topAnchor.constraint(equalTo: metadataView.topAnchor, constant: padding),
            albumTimeLabel.topAnchor.constraint(equalTo: songArtistLabel.bottomAnchor, constant:internalPadding),
            albumTimeLabel.leadingAnchor.constraint(equalTo: songArtistLabel.leadingAnchor),
            albumTimeLabel.trailingAnchor.constraint(equalTo: songArtistLabel.trailingAnchor),
            totalLabel.leadingAnchor.constraint(equalTo:songArtistLabel.leadingAnchor),
            totalLabel.widthAnchor.constraint(equalTo: metadataView.widthAnchor, multiplier: 0.5),
            totalLabel.topAnchor.constraint(equalTo: albumTimeLabel.bottomAnchor, constant: internalPadding),
            barLengthLabel.widthAnchor.constraint(equalTo: metadataView.widthAnchor, multiplier: 0.5),
            barLengthLabel.trailingAnchor.constraint(equalTo:metadataView.trailingAnchor, constant: -padding),
            barLengthLabel.topAnchor.constraint(equalTo: albumTimeLabel.bottomAnchor, constant: internalPadding),
            metadataView.bottomAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: padding),
        ])
    }
    
    private func setupTextView() {
        let padding = 16.0 as CGFloat

        textView = UITextView()
        textView.backgroundColor = UIColor.white
        
        self.view.addSubview(textView)
        textView.delegate = self
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EditViewController.handleZoom(pinchRecognizer:)))

        textView.addGestureRecognizer(pinchRecognizer)
        textView.attributedText = barText
        textView.inputView = keyboard
        textView.inputView?.autoresizingMask = []
        updateBarTotal()
        updateBarLength()
        
        textView.becomeFirstResponder() // to pull up keyboard immediately
        currTextSize = toolKit.barSize
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            textView.topAnchor.constraint(equalTo: metadataView.bottomAnchor, constant: padding / 2),
        ])
    }
    
    func updateSongArtistLabel()
    {
        self.songArtistLabel.text = String(format: "%@%@%@", self.song ?? self.toolKit.placeholderSong, self.toolKit.placeholderDivider, self.artist ?? self.toolKit.placeholderArtist)
        if (self.song != nil || self.artist != nil) {
            self.songArtistLabel.textColor = self.toolKit.header
        } else {
            self.songArtistLabel.textColor = self.toolKit.headerDemp
        }
    }
    
    func updateAlbumTimeLabel()
    {
        self.albumTimeLabel.text = String(format: "%@%@%@", album ?? self.toolKit.placeholderAlbum, self.toolKit.placeholderDivider, time ?? self.toolKit.placeholderTime)
        
        if (self.album != nil  || self.time != nil ) {
            self.albumTimeLabel.textColor = self.toolKit.header
        } else {
            self.albumTimeLabel.textColor = self.toolKit.headerDemp
        }
    }
    
    @objc private func handleTap() {
        let alert = UIAlertController(title: "Track details", message: nil, preferredStyle: .alert)
        
        var song: UITextField!
        var artist: UITextField!
        var album: UITextField!
        var time: UITextField!
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) -> Void in
            let trimmedSong = song.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedArtist = artist.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedAlbum = album.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedTime = time.text?.trimmingCharacters(in: .whitespacesAndNewlines)

            self.song = trimmedSong != "" ? trimmedSong : nil
            self.artist = trimmedArtist != "" ? trimmedArtist : nil
            self.updateSongArtistLabel()
            
            self.album = trimmedAlbum != "" ? trimmedAlbum : nil
            self.time = trimmedTime != "" ? trimmedTime : nil
            self.updateAlbumTimeLabel()
            self.updateBarLength()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.toolKit.placeholderSong
            textField.text = self.song
            song = textField
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.toolKit.placeholderArtist
            textField.text = self.artist
            artist = textField
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.toolKit.placeholderAlbum
            textField.text = self.album
            album = textField
        })
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.toolKit.placeholderTime
            textField.text = self.time
            time = textField
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleZoom(pinchRecognizer: UIPinchGestureRecognizer) {
        currTextSize = toolKit.barSize * pinchRecognizer.scale
        let newBarText = NSMutableAttributedString()
        
        for (index, char) in textView.text.enumerated() {
            var fontSize: CGFloat
            if (char.isNumber || char == " " || char == "=") {
                fontSize = toolKit.nonBarRatio * currTextSize
            } else {
                fontSize = currTextSize
            }
          
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.bold),
                .foregroundColor: textView.attributedText.attribute(.foregroundColor, at: index, effectiveRange: nil) ?? UIColor.purple,
            ]
            let item: NSAttributedString = NSAttributedString(string: String(char), attributes: attributes)
            newBarText.append(item)
        }
        
        textView.attributedText = newBarText
    }
    
    @IBAction func cancelSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveSelected(_ sender: Any) {
        removeTrailingWhitespace()
        writeCurrentState(song: song, artist: artist, album: album, time: time)
        
        delegate?.barText = textView.attributedText
        delegate?.barTotal = textView.text.calculateBarTotal()
        delegate?.currBarCount = updateBarCount()
        
        delegate?.viewControllerDidFinishEditing(vc: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addItem(newItem: String) {
        let fontSize: CGFloat
        if (newItem.isNumber || newItem == " " || newItem == "=") {
            fontSize = toolKit.nonBarRatio * currTextSize
        } else {
            fontSize = currTextSize
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight:UIFont.Weight.bold),
            .foregroundColor: keyboard.currColor as Any,
        ]
        let item = NSMutableAttributedString(string: newItem, attributes: attributes)
        
        var currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let selection = textView.selectedRange
        
        if (selection.length > 0) {
            currString = deleteRange(range: selection)
        }
        
        currString.insert(item, at: selection.lowerBound)
        textView.attributedText = currString
        
        let newSelection = NSMakeRange(selection.lowerBound + 1, 0)
        textView.selectedRange = newSelection
        
        // update total
        updateBarTotal()
        updateBarLength()
    }
    
    func deleteSelected() {
        let selection = textView.selectedRange
        deleteRange(range: selection)
        updateBarTotal()
        updateBarLength()
    }
    
    func updateBarTotal()
    {
        let barTotal = textView.text.calculateBarTotal()
        totalLabel.text = toolKit.barTotal + String(barTotal)
    }
    
    func updateBarLength()
    {
        if time != nil && time.matches(#"^(?:|0|[0-9]\d*)(?:\:\d*)?$"#) {
            barLengthLabel.text = toolKit.barLength + calculateBarLength()
        } else {
            barLengthLabel.text = toolKit.barLengthPlaceholder
        }
    }
    
    func calculateBarLength() -> String
    {
        let barTotal = textView.text.calculateBarTotal()
        let timeComponents = time.components(separatedBy: ":")
        let totalTime = Float(timeComponents[0])! * 60 + Float(timeComponents[1])!
        return String(totalTime / barTotal)
    }
    
    @discardableResult private func deleteRange(range: NSRange) -> NSMutableAttributedString {
        let currString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        var deletionRange = range
        if range.length == 0 && range.lowerBound != 0 {
            deletionRange = NSMakeRange(range.lowerBound - 1, 1)
        }
        
        currString.deleteCharacters(in: deletionRange)
        textView.attributedText = currString
        
        let cursorPos = range.lowerBound > 0 ? NSMakeRange(range.lowerBound - 1, 0) : NSMakeRange(0, 0)
        textView.selectedRange = cursorPos
        
        return textView.attributedText.mutableCopy() as! NSMutableAttributedString
    }
    
    // Private
    
    private func updateBarCount() -> Int {
        var index = textView.text.count - 1
        guard index >= 0 else { return 0 }
        
        let text = textView.attributedText as NSAttributedString
        var currChar = text.last()
        var currColor = text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor
        let color = currColor

        var count = 0
        while (color == currColor && index > 0 && count < 4 && currChar.string != "=") {
            index -= 1
            count += 1
            
            currChar = text.attributedSubstring(from: NSMakeRange(index, 1))
            if (currChar.string == " ") {
                break
            }
            currColor = text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor
        }
        
        return count
    }
    
    private func removeTrailingWhitespace() {
        var lastChar = textView.text.suffix(1)
        
        while (lastChar == " ") {
            textView.attributedText = textView.attributedText.removeLast()
            lastChar = textView.text.suffix(1)
        }
    }
    
    private func writeCurrentState(song: String?, artist: String?, album: String?, time: String?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<SongMetadata>(entityName: "SongMetadata")
        request.predicate = NSPredicate(format: "song != nil && artist != nil && album != nil && time != nil")
        
        do {
            let result = try context.fetch(request)
            let state = result.last ?? SongMetadata(context: context)
            state.song = song ?? nil
            state.artist = artist ?? nil
            state.album = album ?? nil
            state.time = time ?? nil
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func readCurrentState() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<SongMetadata>(entityName: "SongMetadata")
        
        do {
            let result = try context.fetch(request)
            let storedState = result.last ?? nil
            if (storedState != nil) {
                self.song = storedState?.song != "" ? storedState?.song : nil
                self.artist = storedState?.artist != "" ? storedState?.artist : nil
                self.album = storedState?.album != "" ? storedState?.album : nil
                self.time = storedState?.time != "" ? storedState?.time : nil
            }
        } catch {
        }
    }
}
