//
//  Scanner.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 2/13/19.
//  Copyright © 2019 Wolox. All rights reserved.
//

// https://medium.com/programming-with-swift/how-to-read-a-barcode-or-qrcode-with-swift-programming-with-swift-10d4315141d2

import Foundation
import UIKit
import AVFoundation

class Scanner: NSObject {
    
    // MARK: - Properties
    private var _captureSession: AVCaptureSession?
    private var _viewController: UIViewController
    private var _codeOutputHandler: (_ code: String) -> Void
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Initializer
    
    /**
     Creates a Scanner that catchs different code types
     
     - Parameter viewController: The view controller that implements AVCaptureMetadataOutputObjectsDelegate
     - Parameter view: The view where the cam is going to be shown
     - Parameter codeOutputHandler: The closure that is executed when a code is scanned
     
     */
    init(withViewController viewController: UIViewController,
         view: UIView,
         codeOutputHandler: @escaping (String) -> Void) {
        
        _viewController = viewController
        _codeOutputHandler = codeOutputHandler
        
        super.init()
        
        if let captureSession = createCaptureSession() {
            _captureSession = captureSession
            let previewLayer = createPreviewLayer(with: captureSession, view: view)
            view.layer.addSublayer(previewLayer)
        }
    }
    
    // MARK: - Private methods
    private func createCaptureSession() -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metadataOutput = AVCaptureMetadataOutput()
            
            guard captureSession.canAddInput(deviceInput), captureSession.canAddOutput(metadataOutput) else {
                return nil
            }
            
            captureSession.addInput(deviceInput)
            captureSession.addOutput(metadataOutput)
            
            if let viewController = _viewController as? AVCaptureMetadataOutputObjectsDelegate {
                metadataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = metaObjectTypes()
            }
            
        } catch {
            return nil
        }
        
        return captureSession
    }
    
    private func createPreviewLayer(with captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        return previewLayer
    }
    
    // Select all the AVMetadataMachineReadableCodeObject objects you need  to scan
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.aztec,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .dataMatrix,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .qr,
                .upce]
    }
    
    // MARK: - Public methods
    func startCaptureSession() {
        if let captureSession = _captureSession, !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stopCaptureSession() {
        if let captureSession = _captureSession, captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Delegate methods
    func scannerDelegate(_ output: AVCaptureMetadataOutput,
                         didOutput metadataObjects: [AVMetadataObject],
                         from connection: AVCaptureConnection) {
        stopCaptureSession()
        
        guard !metadataObjects.isEmpty,
            let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue else {
            return
        }
        
        _codeOutputHandler(stringValue)
    }
}

func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
    switch orientation {
    case .landscapeLeft:
        return .landscapeLeft
    case .landscapeRight:
        return .landscapeRight
    case .portraitUpsideDown:
        return .portraitUpsideDown
    default:
        return .portrait
    }
}
