//
//  PerceptronTests.swift
//  PerceptronTests
//
//  Created by Erk Ekin on 20/03/16.
//  Copyright © 2016 Erk Ekin. All rights reserved.
//

import XCTest
@testable import Perceptron

class PerceptronTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        let perceptron = Perceptron()
        
        var exampleInput = [[Double]]()
        exampleInput.append([-1.0, -1.0])
        exampleInput.append([-1.0,  1.0])
        exampleInput.append([ 1.0, -1.0])
        exampleInput.append([ 1.0,  1.0])
        
        
        var exampleOutput = [Double]()
        exampleOutput.append(-1.0)
        exampleOutput.append(-1.0)
        exampleOutput.append(-1.0)
        exampleOutput.append( 1.0)
        
        perceptron.train(inputs: exampleInput, outputs: exampleOutput, learningRate: 0.5, epsilon: 0.0001)
        
        for i in exampleInput.indices {
            
            let input = exampleInput[i]
            let expected = exampleOutput[i]
            let output = perceptron.test(input)
            XCTAssert(expected == output, "Should be equal")
        }
        
        perceptron.test([1,-1])
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
