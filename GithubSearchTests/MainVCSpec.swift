//
//  MainVCSpec.swift
//  MainVCSpec
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
@testable import GithubSearch

class MainVCSpec: QuickSpec {
    
    override func spec() {
        // 모든 example가 실행되기 전에 실행.
        beforeSuite {
            
        }
        
        // 모든 example가 실행되고난 후에 실행.
        afterSuite {
            
        }
        
//        //비활성화, example이나 group 맨 앞에 x 추가
//        // 포커싱, example 앞에 f -> 일정 부분을 임시적 실행 (얘 있으면 이것만 실행됨)
//        describe("a initial state") {
//            //            var dolphin: Dolphin!
//            //            beforeEach { dolphin = Dolphin() }
//
//            describe("its click") {
//                context("when the dolphin is not near anything interesting") {
//                    it("is only emitted once") {
//                        //                        expect(dolphin.click().count).to(equal(1))
//                    }
//                }
//
//                context("when the dolphin is near something interesting") {
//                    beforeEach {
//                        //                        let ship = SunkenShip()
//                        //                        Jamaica.dolphinCove.add(ship)
//                        //                        Jamaica.dolphinCove.add(dolphin)
//                    }
//
//                    it("is emitted three times") {
//                        //                        expect(dolphin.click().count).to(equal(3))
//                    }
//
//
//                    // 실행될 예정인 example의 이름 제공.
//                    beforeEach { exampleMetadata in
//
//                        print("Example number \(exampleMetadata.exampleIndex) is about to be run.")
//                    }
//
//                    // 여태까지 실행되었던 example의 이름 제공.
//                    afterEach { exampleMetadata in
//                        print("Example number \(exampleMetadata.exampleIndex) has run.")
//                    }
//
//                }
//            }
//        }
//
//
//        it("is friendly") {
//            //          expect(Dolphin().isFriendly).to(beTruthy())
//        }
//
//        it("is smart") {
//            //          expect(Dolphin().isSmart).to(beTruthy())
//        }
//
//        //        var a = 1
//        //        expect(a).to(equal(2), description: "왜 실패가 안돼?")
    }
    
}
