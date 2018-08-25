//
//  MockServer.swift
//  PhotoUploaderTests
//
//  Created by Bassel Ezzeddine on 04/08/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import GCDWebServer

class MockServer {
    
    // MARK: - Properties
    let webServer = GCDWebServer()
    
    // MARK: - Methods
    func start() {
        do {
            try webServer.start(options: [
                GCDWebServerOption_AutomaticallySuspendInBackground: false,
                GCDWebServerOption_Port: 8080,
                GCDWebServerOption_BindToLocalhost: true])
            print("Started mock server on port 8080")
        }
        catch let error {
            print("Mock server could not start : \(error)")
        }
    }
    
    func stop() {
        webServer.stop()
        reset()
    }
    
    func reset() {
        webServer.removeAllHandlers()
    }
    
    func getDataFromFile(fileName: String, type: String) throws -> Data {
        let path = Bundle(for: MockServer.self).path(forResource: fileName, ofType: type)
        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.mappedIfSafe)
        return data
    }
    
    func respondToFetchPhotoListWithSuccess(mockFileName: String = "photoListWithThreeItems") {
        URLCache.shared.removeAllCachedResponses()
        webServer.addHandler(forMethod: "GET", path: "/images/download", request: GCDWebServerRequest.self, processBlock: { request in
            var data: Data!
            do {
                data = try self.getDataFromFile(fileName: mockFileName, type: "json")
            }
            catch _ {}
            return GCDWebServerDataResponse(data: data, contentType: "json")
        })
    }
    
    func respondToFetchPhotoListWithFailure(statusCode: Int = 500) {
        URLCache.shared.removeAllCachedResponses()
        webServer.addHandler(forMethod: "GET", path: "/images/download", request: GCDWebServerRequest.self, processBlock: { request in
            let errorResponse = GCDWebServerErrorResponse(data: Data(), contentType: "json")
            errorResponse.statusCode = statusCode
            return errorResponse
        })
    }
}
