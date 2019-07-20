import Foundation

///
/// The StubbornNetwork provides access to a stubbed URLSession.
///
/// The StubbornURLSession can be used during tests to inject stubbed responses
/// into instances where normally a URLSession would be used to make network requests.
public struct StubbornNetwork {

    ///
    /// Use the `stubbedURLSession` to get an instance of StubbornURLSession
    ///
    /// Then stub requests:
    ///
    /// ```
    ///     let urlSession = StubbornNetwork.stubbedURLSession
    ///     urlSession.stub(request, data: stubbedData, response: nil, error: nil)
    /// ```
    public static var stubbedURLSession: StubbornURLSession {
        get {
            return URLSessionStub(configuration: .ephemeral)
        }
    }
}
