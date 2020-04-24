//
//  WolmoCoreTests.swift
//  WolmoCoreTests
//
//  Created by Guido Marucci Blas on 5/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//
import Foundation

import Nimble
import Quick
import WolmoCore

public class StringSpec: QuickSpec {
    
    override public func spec() {
        
        describe("localized()") {
            // Don't know how to test it, since Bundle.main in simulator
            // is not the one where the strings file is.
        }
        
        describe("#localized(bundle:)") {
            
            it("should localize the string according to main bundle") {
                let key = "some.example.key"
                let localized = key.localized(bundle: Bundle(for: StringSpec.self))
                expect(localized).to(equal("This is my localized string."))
            }
            
        }
        
        describe("#localized(withArguments:)") {
            // Don't know how to test it, since Bundle.main in simulator
            // is not the one where the strings file is.
        }
        
        describe("#localized(withArguments:bundle:)") {
            
            it("should localize the string and then format it with the arguments passed") {
                let key = "some.example.formatting_key"
                let result = key.localized(withArguments: 5, "Test", bundle: Bundle(for: StringSpec.self))
                expect(result).to(equal("The number is 5, and my name Test."))
            }
            
        }
        
        describe("#format(with:)") {
            
            it("should returned the formatted string as expected") {
                let string = "%@ is %.3d %@ long"
                let formatted = string.format(with: "Earth equator line", 25, "thousand miles")
                expect(formatted).to(equal("Earth equator line is 025 thousand miles long"))
            }
            
        }

        describe("#format(withAttributes:)") {

            it("should add the attributes to the string when the substring exists") {
                let string = "Come and check our interesting posts at Wolox."
                let attrs: [String: [NSAttributedString.Key: Any]] = ["Come and check our interesting posts at Wolox.":
                                [NSAttributedString.Key.font: "Helvetica-Regular"],
                             "Wolox":
                                [NSAttributedString.Key.link: URL(string: "www.wolox.com.ar")!,
                                 NSAttributedString.Key.foregroundColor: UIColor.blue],
                             "posts":
                                [NSAttributedString.Key.foregroundColor: UIColor.red],
                             "and some more":
                                [NSAttributedString.Key.foregroundColor: UIColor.green]]
                let attrString: NSAttributedString = string.format(withAttributes: attrs)
                attrString.enumerateAttributes(in: NSRange(location: 0, length: attrString.length),
                                               using: { (attributes, range, _) in
                    let nsString = string as NSString
                    if nsString.substring(with: range) == "Come and check our interesting " ||
                       nsString.substring(with: range) == " at " ||
                       nsString.substring(with: range) == "." {
                        expect(attributes.count).to(equal(1))
                        expect(attributes[NSAttributedString.Key.font] as? String).to(equal("Helvetica-Regular"))
                    } else if nsString.substring(with: range) == "Wolox" {
                        expect(attributes.count).to(equal(3))
                        expect(attributes[NSAttributedString.Key.font] as? String).to(equal("Helvetica-Regular"))
                        expect(attributes[NSAttributedString.Key.link] as? URL).to(equal(URL(string: "www.wolox.com.ar")))
                        expect(attributes[NSAttributedString.Key.foregroundColor] as? UIColor).to(equal(UIColor.blue))
                    } else if nsString.substring(with: range) == "posts" {
                        expect(attributes.count).to(equal(2))
                        expect(attributes[NSAttributedString.Key.font] as? String).to(equal("Helvetica-Regular"))
                        expect(attributes[NSAttributedString.Key.foregroundColor] as? UIColor).to(equal(UIColor.red))
                    } else {
                        fail()
                    }
                })

            }

        }
        
        describe("#url") {
            
            context("When it is a valid url") {
                
                it("should return the url") {
                    let string = "https://www.google.com.ar/"
                    expect(string.url).toNot(beNil())
                }
            }
            
            context("When it is an invalid url") {
                
                it("should return nil") {
                    let string = "this is invalid"
                    expect(string.url).to(beNil())
                }
            }
        }
        
        describe("#hasSpaces") {
            
            context("When the string doesn't have spaces") {
                
                it("should return false") {
                    let string = "stringwithoutspaces"
                    expect(string.hasSpaces).to(beFalse())
                }
            }
            
            context("When the string has spaces") {
                
                it("should return true") {
                    let string = "string with spaces"
                    expect(string.hasSpaces).to(beTrue())
                }
            }
        }
        
        describe("#isValidEmail") {
            
            context("When the email isn't valid") {
                
                context("When the email doesn't contains @") {
                    
                    it("should return false") {
                        let email = "myemailgmail.com"
                        expect(email.isValidEmail()).to(beFalse())
                    }
                }
                
                context("When the email doesn't contains anything after @") {
                    
                    it("should return false") {
                        let email = "myemail@"
                        expect(email.isValidEmail()).to(beFalse())
                    }
                }
                
                context("When the email doesn't contains anything after .") {
                    
                    it("should return false") {
                        let email = "email@wolox."
                        expect(email.isValidEmail()).to(beFalse())
                    }
                }
            }
            
            context("When the email is valid") {
                
                it("should return true") {
                    let email = "myemail@gmail.com"
                    expect(email.isValidEmail()).to(beTrue())
                }
                
                context("With any provider") {
                    
                    it("should return true") {
                        let email = "some@email.com"
                        expect(email.isValidEmail()).to(beTrue())
                    }
                }
            }
        }
        
        describe("#trimmed") {
            
            context("When the string has whitespaces") {
                
                var string: String!
                
                beforeEach {
                    string = "   te st@te st.com   "
                }
                
                it("removes leading and trailing whitespaces") {
                    let result = string.trimmed
                    expect(result).to(equal("te st@te st.com"))
                }
                
                it("maintains not leading or trailing spaces") {
                    let string = "This should remain the same"
                    expect(string.trimmed).to(equal(string))
                }
            }
        }
        
        describe("#replacing(with:)") {
            
            var string: String!
            var target: String!
            var replacement: String!
            
            context("When the string doesn't contain the target string to replace") {
                
                beforeEach {
                    string = "this is my string"
                    target = "hello"
                    replacement = "world"
                }
                
                it("should return the same string") {
                    let replaced = string.replacing(target, with: replacement)
                    expect(string).to(equal(replaced))
                }
            }
            
            context("When the string contains the target string to replace") {
                
                beforeEach {
                    string = "this is my string"
                    target = "this"
                    replacement = "that"
                }
                
                it("should return the string with the target replaced") {
                    let replaced = string.replacing(target, with: replacement)
                    expect(replaced).to(equal("that is my string"))
                }
                
                it("should not mutate the string") {
                    let _ = string.replacing(target, with: replacement)
                    expect(string).to(equal("this is my string"))
                }
            }
            
        }
        
        describe("#withoutWhiteSpaces") {
            
            context("When the string has whitespaces") {
                
                it("should remove them all") {
                    expect("has whitespaces".withoutWhiteSpaces).to(equal("haswhitespaces"))
                }
            }
            
            context("When the string doesn't have whitespaces") {
                
                it("should return the same string") {
                    expect("nowhitespaces".withoutWhiteSpaces).to(equal("nowhitespaces"))
                }
            }
            
            context("When the string contains leading or trailing whitespaces") {
                
                it("should remove them") {
                    let string = "   te st@te st.com   "
                    expect(string.withoutWhiteSpaces).to(equal("test@test.com"))
                }
            }
        }
        
        describe("#isNotEmpty") {
            
            var string: String!
            
            context("when string is empty") {
                
                beforeEach {
                    string = ""
                }
                
                it("returns false") {
                    expect(string.isNotEmpty).to(beFalse())
                }
                
            }
            
            context("when string is not empty") {
                
                beforeEach {
                    string = "something"
                }
                
                it("returns true") {
                    expect(string.isNotEmpty).to(beTrue())
                }
                
            }
            
        }
        
        describe("#remove(suffix:)") {
            
            var string: String!
            var suffix: String!
            
            beforeEach {
                string = "this is my string"
            }
            
            context("when the string has the string to remove as prefix") {
                
                beforeEach {
                    suffix = "this"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(suffix: suffix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string has the string to remove in the middle") {
                
                beforeEach {
                    suffix = " my s"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(suffix: suffix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string has the string to remove as suffix") {
                
                beforeEach {
                    suffix = "ring"
                }
                
                it("returns the  string without the suffix") {
                    let removed = string.remove(suffix: suffix)
                    expect(removed).to(equal("this is my st"))
                }
                
                it("doesn't change the original string") {
                    let _ = string.remove(suffix: suffix)
                    expect(string).to(equal("this is my string"))
                }
                
            }
            
            context("when the string hasn't got the string to remove as substring") {
                
                beforeEach {
                    suffix = "hello"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(suffix: suffix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string has the string to remove as suffix but case don't match") {
                
                beforeEach {
                    suffix = "riNg"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(suffix: suffix)
                    expect(removed).to(equal(string))
                }
                
            }
            
        }
        
        describe("#remove(prefix:)") {
            var string: String!
            var prefix: String!
            
            beforeEach {
                string = "this is my string"
            }
            
            context("when the string has the string to remove as prefix") {
                
                beforeEach {
                    prefix = "this"
                }
                
                it("returns the string without the prefix") {
                    let removed = string.remove(prefix: prefix)
                    expect(removed).to(equal(" is my string"))
                }
                
                it("doesn't change the original string") {
                    let _ = string.remove(prefix: prefix)
                    expect(string).to(equal("this is my string"))
                }
                
            }
            
            context("when the string has the string to remove in the middle") {
                
                beforeEach {
                    prefix = " my"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(prefix: prefix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string has the string to remove as suffix") {
                
                beforeEach {
                    prefix = "ring"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(prefix: prefix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string hasn't got the string to remove as substring") {
                
                beforeEach {
                    prefix = "hello"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(prefix: prefix)
                    expect(removed).to(equal(string))
                }
                
            }
            
            context("when the string has the string to remove as prefix but case don't match") {
                
                beforeEach {
                    prefix = "This"
                }
                
                it("returns the same string as before") {
                    let removed = string.remove(prefix: prefix)
                    expect(removed).to(equal(string))
                }
                
            }
            
        }
        
        describe("#*(lhs:rhs:)") {
            
            var string: String!
            var numberOfTimes: Int!
            
            context("when the string is empty") {
                
                beforeEach {
                    string = ""
                    numberOfTimes = 3
                }
                
                it("should return an empty string") {
                    expect(string * numberOfTimes).to(equal(""))
                }
                
            }
            
            context("when the string is on the left side") {
                
                beforeEach {
                    string = "something"
                    numberOfTimes = 3
                }
                
                it("should return the original string repeated three times") {
                    expect(string * numberOfTimes).to(equal("somethingsomethingsomething"))
                }
                
            }
            
            context("when the string is on the right side") {
                
                beforeEach {
                    string = "something"
                    numberOfTimes = 3
                }
                
                it("should return the original string repeated three times") {
                    expect(numberOfTimes * string).to(equal("somethingsomethingsomething"))
                }
                
            }
        }
        
    }
    // swiftlint:enable function_body_length

}
