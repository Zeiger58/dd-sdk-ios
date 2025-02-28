/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

@testable import Datadog

// MARK: - Configuration Mocks

extension TrackingConsent {
    static func mockRandom() -> TrackingConsent {
        return [.granted, .notGranted, .pending].randomElement()!
    }

    static func mockRandom(otherThan consent: TrackingConsent? = nil) -> TrackingConsent {
        while true {
            let randomConsent: TrackingConsent = .mockRandom()
            if randomConsent != consent {
                return randomConsent
            }
        }
    }
}

extension ConsentProvider {
    static func mockAny() -> ConsentProvider {
        return ConsentProvider(initialConsent: .mockRandom())
    }
}

extension Datadog.Configuration {
    static func mockAny() -> Datadog.Configuration { .mockWith() }

    static func mockWith(
        rumApplicationID: String? = .mockAny(),
        clientToken: String = .mockAny(),
        environment: String = .mockAny(),
        loggingEnabled: Bool = false,
        tracingEnabled: Bool = false,
        rumEnabled: Bool = false,
        crashReportingPlugin: DDCrashReportingPluginType? = nil,
        datadogEndpoint: DatadogEndpoint? = nil,
        customLogsEndpoint: URL? = nil,
        customTracesEndpoint: URL? = nil,
        customRUMEndpoint: URL? = nil,
        logsEndpoint: LogsEndpoint = .us,
        tracesEndpoint: TracesEndpoint = .us,
        rumEndpoint: RUMEndpoint = .us,
        serviceName: String? = .mockAny(),
        firstPartyHosts: Set<String>? = nil,
        rumSessionsSamplingRate: Float = 100.0,
        rumUIKitViewsPredicate: UIKitRUMViewsPredicate? = nil,
        rumUIKitActionsTrackingEnabled: Bool = false,
        rumResourceAttributesProvider: URLSessionRUMAttributesProvider? = nil,
        batchSize: BatchSize = .medium,
        uploadFrequency: UploadFrequency = .average,
        additionalConfiguration: [String: Any] = [:],
        internalMonitoringClientToken: String? = nil
    ) -> Datadog.Configuration {
        return Datadog.Configuration(
            rumApplicationID: rumApplicationID,
            clientToken: clientToken,
            environment: environment,
            loggingEnabled: loggingEnabled,
            tracingEnabled: tracingEnabled,
            rumEnabled: rumEnabled,
            crashReportingPlugin: crashReportingPlugin,
            datadogEndpoint: datadogEndpoint,
            customLogsEndpoint: customLogsEndpoint,
            customTracesEndpoint: customTracesEndpoint,
            customRUMEndpoint: customRUMEndpoint,
            logsEndpoint: logsEndpoint,
            tracesEndpoint: tracesEndpoint,
            rumEndpoint: rumEndpoint,
            serviceName: serviceName,
            firstPartyHosts: firstPartyHosts,
            rumSessionsSamplingRate: rumSessionsSamplingRate,
            rumUIKitViewsPredicate: rumUIKitViewsPredicate,
            rumUIKitActionsTrackingEnabled: rumUIKitActionsTrackingEnabled,
            rumResourceAttributesProvider: rumResourceAttributesProvider,
            batchSize: batchSize,
            uploadFrequency: uploadFrequency,
            additionalConfiguration: additionalConfiguration,
            internalMonitoringClientToken: internalMonitoringClientToken
        )
    }
}

typealias BatchSize = Datadog.Configuration.BatchSize

extension BatchSize: CaseIterable {
    public static var allCases: [Self] { [.small, .medium, .large] }

    static func mockRandom() -> Self {
        allCases.randomElement()!
    }
}

typealias UploadFrequency = Datadog.Configuration.UploadFrequency

extension UploadFrequency: CaseIterable {
    public static var allCases: [Self] { [.frequent, .average, .rare] }

    static func mockRandom() -> Self {
        allCases.randomElement()!
    }
}

extension BundleType: CaseIterable {
    public static var allCases: [Self] { [.iOSApp, iOSAppExtension] }
}

extension Datadog.Configuration.DatadogEndpoint {
    static func mockRandom() -> Self {
        return [.us, .eu, .gov].randomElement()!
    }
}

extension Datadog.Configuration.LogsEndpoint {
    static func mockRandom() -> Self {
        return [.us, .eu, .gov, .custom(url: "http://example.com/api/")].randomElement()!
    }
}

extension Datadog.Configuration.TracesEndpoint {
    static func mockRandom() -> Self {
        return [.us, .eu, .gov, .custom(url: "http://example.com/api/")].randomElement()!
    }
}

extension Datadog.Configuration.RUMEndpoint {
    static func mockRandom() -> Self {
        return [.us, .eu, .gov, .custom(url: "http://example.com/api/")].randomElement()!
    }
}

extension FeaturesConfiguration {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        common: Common = .mockAny(),
        logging: Logging? = .mockAny(),
        tracing: Tracing? = .mockAny(),
        rum: RUM? = .mockAny(),
        crashReporting: CrashReporting = .mockAny(),
        urlSessionAutoInstrumentation: URLSessionAutoInstrumentation? = .mockAny(),
        internalMonitoring: InternalMonitoring? = nil
    ) -> Self {
        return .init(
            common: common,
            logging: logging,
            tracing: tracing,
            rum: rum,
            urlSessionAutoInstrumentation: urlSessionAutoInstrumentation,
            crashReporting: crashReporting,
            internalMonitoring: internalMonitoring
        )
    }
}

extension FeaturesConfiguration.Common {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        applicationName: String = .mockAny(),
        applicationVersion: String = .mockAny(),
        applicationBundleIdentifier: String = .mockAny(),
        serviceName: String = .mockAny(),
        environment: String = .mockAny(),
        performance: PerformancePreset = .init(batchSize: .medium, uploadFrequency: .average, bundleType: .iOSApp),
        source: String = .mockAny()
    ) -> Self {
        return .init(
            applicationName: applicationName,
            applicationVersion: applicationVersion,
            applicationBundleIdentifier: applicationBundleIdentifier,
            serviceName: serviceName,
            environment: environment,
            performance: performance,
            source: source
        )
    }
}

extension FeaturesConfiguration.Logging {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        common: FeaturesConfiguration.Common = .mockAny(),
        uploadURLWithClientToken: URL = .mockAny()
    ) -> Self {
        return .init(common: common, uploadURLWithClientToken: uploadURLWithClientToken)
    }
}

extension FeaturesConfiguration.Tracing {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        common: FeaturesConfiguration.Common = .mockAny(),
        uploadURLWithClientToken: URL = .mockAny(),
        spanEventMapper: SpanEventMapper? = nil
    ) -> Self {
        return .init(
            common: common,
            uploadURLWithClientToken: uploadURLWithClientToken,
            spanEventMapper: spanEventMapper
        )
    }
}

extension FeaturesConfiguration.RUM {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        common: FeaturesConfiguration.Common = .mockAny(),
        uploadURLWithClientToken: URL = .mockAny(),
        applicationID: String = .mockAny(),
        sessionSamplingRate: Float = 100.0,
        viewEventMapper: RUMViewEventMapper? = nil,
        resourceEventMapper: RUMResourceEventMapper? = nil,
        actionEventMapper: RUMActionEventMapper? = nil,
        errorEventMapper: RUMErrorEventMapper? = nil,
        autoInstrumentation: FeaturesConfiguration.RUM.AutoInstrumentation? = nil
    ) -> Self {
        return .init(
            common: common,
            uploadURLWithClientToken: uploadURLWithClientToken,
            applicationID: applicationID,
            sessionSamplingRate: sessionSamplingRate,
            viewEventMapper: viewEventMapper,
            resourceEventMapper: resourceEventMapper,
            actionEventMapper: actionEventMapper,
            errorEventMapper: errorEventMapper,
            autoInstrumentation: autoInstrumentation
        )
    }
}

extension FeaturesConfiguration.CrashReporting {
    static func mockAny() -> Self {
        return mockWith()
    }

    static func mockWith(
        crashReportingPlugin: DDCrashReportingPluginType = CrashReportingPluginMock()
    ) -> Self {
        return .init(
            crashReportingPlugin: crashReportingPlugin
        )
    }
}

extension FeaturesConfiguration.URLSessionAutoInstrumentation {
    static func mockAny() -> Self { mockWith() }

    static func mockWith(
        userDefinedFirstPartyHosts: Set<String> = [],
        sdkInternalURLs: Set<String> = [],
        rumAttributesProvider: URLSessionRUMAttributesProvider? = nil,
        instrumentTracing: Bool = true,
        instrumentRUM: Bool = true
    ) -> Self {
        return .init(
            userDefinedFirstPartyHosts: userDefinedFirstPartyHosts,
            sdkInternalURLs: sdkInternalURLs,
            rumAttributesProvider: rumAttributesProvider,
            instrumentTracing: instrumentTracing,
            instrumentRUM: instrumentRUM
        )
    }
}

extension FeaturesConfiguration.InternalMonitoring {
    static func mockAny() -> Self {
        return mockWith()
    }

    static func mockWith(
        common: FeaturesConfiguration.Common = .mockAny(),
        sdkServiceName: String = .mockAny(),
        sdkEnvironment: String = .mockAny(),
        logsUploadURLWithClientToken: URL = .mockAny()
    ) -> Self {
        return .init(
            common: common,
            sdkServiceName: sdkServiceName,
            sdkEnvironment: sdkEnvironment,
            logsUploadURLWithClientToken: logsUploadURLWithClientToken
        )
    }
}

extension AppContext {
    static func mockAny() -> AppContext {
        return mockWith()
    }

    static func mockWith(
        bundleType: BundleType = .iOSApp,
        bundleIdentifier: String? = .mockAny(),
        bundleVersion: String? = .mockAny(),
        bundleName: String? = .mockAny()
    ) -> AppContext {
        return AppContext(
            bundleType: bundleType,
            bundleIdentifier: bundleIdentifier,
            bundleVersion: bundleVersion,
            bundleName: bundleName
        )
    }
}

// MARK: - PerformancePreset Mocks

struct StoragePerformanceMock: StoragePerformancePreset {
    let maxFileSize: UInt64
    let maxDirectorySize: UInt64
    let maxFileAgeForWrite: TimeInterval
    let minFileAgeForRead: TimeInterval
    let maxFileAgeForRead: TimeInterval
    let maxObjectsInFile: Int
    let maxObjectSize: UInt64

    static let noOp = StoragePerformanceMock(
        maxFileSize: 0,
        maxDirectorySize: 0,
        maxFileAgeForWrite: 0,
        minFileAgeForRead: 0,
        maxFileAgeForRead: 0,
        maxObjectsInFile: 0,
        maxObjectSize: 0
    )

    static let readAllFiles = StoragePerformanceMock(
        maxFileSize: .max,
        maxDirectorySize: .max,
        maxFileAgeForWrite: 0,
        minFileAgeForRead: -1, // make all files eligible for read
        maxFileAgeForRead: .distantFuture, // make all files eligible for read
        maxObjectsInFile: .max,
        maxObjectSize: .max
    )

    static let writeEachObjectToNewFileAndReadAllFiles = StoragePerformanceMock(
        maxFileSize: .max,
        maxDirectorySize: .max,
        maxFileAgeForWrite: 0, // always return new file for writting
        minFileAgeForRead: readAllFiles.minFileAgeForRead,
        maxFileAgeForRead: readAllFiles.maxFileAgeForRead,
        maxObjectsInFile: 1, // write each data to new file
        maxObjectSize: .max
    )
}

struct UploadPerformanceMock: UploadPerformancePreset {
    let initialUploadDelay: TimeInterval
    let defaultUploadDelay: TimeInterval
    let minUploadDelay: TimeInterval
    let maxUploadDelay: TimeInterval
    let uploadDelayChangeRate: Double

    static let noOp = UploadPerformanceMock(
        initialUploadDelay: .distantFuture,
        defaultUploadDelay: .distantFuture,
        minUploadDelay: .distantFuture,
        maxUploadDelay: .distantFuture,
        uploadDelayChangeRate: 0
    )

    static let veryQuick = UploadPerformanceMock(
        initialUploadDelay: 0.05,
        defaultUploadDelay: 0.05,
        minUploadDelay: 0.05,
        maxUploadDelay: 0.05,
        uploadDelayChangeRate: 0
    )
}

extension PerformancePreset {
    static func combining(storagePerformance storage: StoragePerformanceMock, uploadPerformance upload: UploadPerformanceMock) -> PerformancePreset {
        PerformancePreset(
            maxFileSize: storage.maxFileSize,
            maxDirectorySize: storage.maxDirectorySize,
            maxFileAgeForWrite: storage.maxFileAgeForWrite,
            minFileAgeForRead: storage.minFileAgeForRead,
            maxFileAgeForRead: storage.maxFileAgeForRead,
            maxObjectsInFile: storage.maxObjectsInFile,
            maxObjectSize: storage.maxObjectSize,
            initialUploadDelay: upload.initialUploadDelay,
            defaultUploadDelay: upload.defaultUploadDelay,
            minUploadDelay: upload.minUploadDelay,
            maxUploadDelay: upload.maxUploadDelay,
            uploadDelayChangeRate: upload.uploadDelayChangeRate
        )
    }
}

// MARK: - Features Common Mocks

extension FeaturesCommonDependencies {
    static func mockAny() -> FeaturesCommonDependencies {
        return .mockWith()
    }

    /// Mocks features common dependencies.
    /// Default values describe the environment setup where data can be uploaded to the server (device is online and battery is full).
    static func mockWith(
        consentProvider: ConsentProvider = ConsentProvider(initialConsent: .granted),
        performance: PerformancePreset = .combining(
            storagePerformance: .writeEachObjectToNewFileAndReadAllFiles,
            uploadPerformance: .veryQuick
        ),
        mobileDevice: MobileDevice = .mockWith(
            currentBatteryStatus: {
                // Mock full battery, so it doesn't rely on battery condition for the upload
                return BatteryStatus(state: .full, level: 1, isLowPowerModeEnabled: false)
            }
        ),
        dateProvider: DateProvider = SystemDateProvider(),
        dateCorrector: DateCorrectorType = DateCorrectorMock(),
        userInfoProvider: UserInfoProvider = .mockAny(),
        networkConnectionInfoProvider: NetworkConnectionInfoProviderType = NetworkConnectionInfoProviderMock.mockWith(
            networkConnectionInfo: .mockWith(
                reachability: .yes, // so it always meets the upload condition
                availableInterfaces: [.wifi],
                supportsIPv4: true,
                supportsIPv6: true,
                isExpensive: true,
                isConstrained: false // so it always meets the upload condition
            )
        ),
        carrierInfoProvider: CarrierInfoProviderType = CarrierInfoProviderMock.mockAny(),
        launchTimeProvider: LaunchTimeProviderType = LaunchTimeProviderMock()
    ) -> FeaturesCommonDependencies {
        let httpClient: HTTPClient

        if let activeServer = ServerMock.activeInstance {
            httpClient = HTTPClient(session: activeServer.getInterceptedURLSession())
        } else {
            class AssertedHTTPClient: HTTPClient {
                // swiftlint:disable:next unavailable_function
                override func send(request: URLRequest, completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
                    preconditionFailure(
                        """
                        ⚠️ Request to \(request.url?.absoluteString ?? "null") was sent but there is no `ServerMock` instance set up for its interception.
                        All unit tests must be configured to either send data to mocked `FeatureStorage` (`XYZFeature.mockByRecordingXYZ(...)`)
                        or use `ServerMock` instance and `serverMock.getInterceptedURLSession()` for requests interception.
                        """
                    )
                }
            }

            httpClient = AssertedHTTPClient()
        }

        return FeaturesCommonDependencies(
            consentProvider: consentProvider,
            performance: performance,
            httpClient: httpClient,
            mobileDevice: mobileDevice,
            dateProvider: dateProvider,
            dateCorrector: dateCorrector,
            userInfoProvider: userInfoProvider,
            networkConnectionInfoProvider: networkConnectionInfoProvider,
            carrierInfoProvider: carrierInfoProvider,
            launchTimeProvider: launchTimeProvider
        )
    }

    /// Creates new instance of `FeaturesCommonDependencies` by replacing individual dependencies.
    func replacing(
        consentProvider: ConsentProvider? = nil,
        performance: PerformancePreset? = nil,
        httpClient: HTTPClient? = nil,
        mobileDevice: MobileDevice? = nil,
        dateProvider: DateProvider? = nil,
        dateCorrector: DateCorrectorType? = nil,
        userInfoProvider: UserInfoProvider? = nil,
        networkConnectionInfoProvider: NetworkConnectionInfoProviderType? = nil,
        carrierInfoProvider: CarrierInfoProviderType? = nil,
        launchTimeProvider: LaunchTimeProviderType? = nil
    ) -> FeaturesCommonDependencies {
        return FeaturesCommonDependencies(
            consentProvider: consentProvider ?? self.consentProvider,
            performance: performance ?? self.performance,
            httpClient: httpClient ?? self.httpClient,
            mobileDevice: mobileDevice ?? self.mobileDevice,
            dateProvider: dateProvider ?? self.dateProvider,
            dateCorrector: dateCorrector ?? self.dateCorrector,
            userInfoProvider: userInfoProvider ?? self.userInfoProvider,
            networkConnectionInfoProvider: networkConnectionInfoProvider ?? self.networkConnectionInfoProvider,
            carrierInfoProvider: carrierInfoProvider ?? self.carrierInfoProvider,
            launchTimeProvider: launchTimeProvider ?? self.launchTimeProvider
        )
    }
}

class FileWriterMock: Writer {
    var dataWritten: Encodable?

    func write<T>(value: T) where T: Encodable {
        dataWritten = value
    }
}

class NoOpFileWriter: AsyncWriter {
    var queue: DispatchQueue { DispatchQueue(label: .mockRandom()) }
    func write<T>(value: T) where T: Encodable {}
    func flushAndCancelSynchronously() {}
}

class NoOpFileReader: SyncReader {
    var queue: DispatchQueue { DispatchQueue(label: .mockRandom()) }
    func readNextBatch() -> Batch? { return nil }
    func markBatchAsRead(_ batch: Batch) {}
    func markAllFilesAsReadable() {}
}

class NoOpDataUploadWorker: DataUploadWorkerType {
    func flushSynchronously() {}
    func cancelSynchronously() {}
}

extension DataFormat {
    static func mockAny() -> DataFormat {
        return mockWith()
    }

    static func mockWith(
        prefix: String = .mockAny(),
        suffix: String = .mockAny(),
        separator: String = .mockAny()
    ) -> DataFormat {
        return DataFormat(
            prefix: prefix,
            suffix: suffix,
            separator: separator
        )
    }
}

/// `DateProvider` mock returning consecutive dates in custom intervals, starting from given reference date.
class RelativeDateProvider: DateProvider {
    private(set) var date: Date
    internal let timeInterval: TimeInterval
    private let queue = DispatchQueue(label: "queue-RelativeDateProvider-\(UUID().uuidString)")

    private init(date: Date, timeInterval: TimeInterval) {
        self.date = date
        self.timeInterval = timeInterval
    }

    convenience init(using date: Date = Date()) {
        self.init(date: date, timeInterval: 0)
    }

    convenience init(startingFrom referenceDate: Date = Date(), advancingBySeconds timeInterval: TimeInterval = 0) {
        self.init(date: referenceDate, timeInterval: timeInterval)
    }

    /// Returns current date and advances next date by `timeInterval`.
    func currentDate() -> Date {
        defer {
            queue.async {
                self.date.addTimeInterval(self.timeInterval)
            }
        }
        return queue.sync {
            return date
        }
    }

    /// Pushes time forward by given number of seconds.
    func advance(bySeconds seconds: TimeInterval) {
        queue.async {
            self.date = self.date.addingTimeInterval(seconds)
        }
    }
}

extension DateCorrection {
    static var zero: DateCorrection {
        return DateCorrection(serverTimeOffset: 0)
    }
}

/// `DateCorrectorType` mock, correcting dates by adding predefined offset.
class DateCorrectorMock: DateCorrectorType {
    var correctionOffset: TimeInterval

    init(correctionOffset: TimeInterval = 0) {
        self.correctionOffset = correctionOffset
    }

    var currentCorrection: DateCorrection {
        return DateCorrection(serverTimeOffset: correctionOffset)
    }
}

struct LaunchTimeProviderMock: LaunchTimeProviderType {
    var launchTime: TimeInterval? = nil
}

extension UserInfo: AnyMockable, RandomMockable {
    static func mockAny() -> UserInfo {
        return mockEmpty()
    }

    static func mockEmpty() -> UserInfo {
        return UserInfo(id: nil, name: nil, email: nil, extraInfo: [:])
    }

    static func mockRandom() -> UserInfo {
        return .init(
            id: .mockRandom(),
            name: .mockRandom(),
            email: .mockRandom(),
            extraInfo: mockRandomAttributes()
        )
    }
}

extension UserInfo: EquatableInTests {}

extension UserInfoProvider {
    static func mockAny() -> UserInfoProvider {
        return mockWith()
    }

    static func mockWith(userInfo: UserInfo = .mockAny()) -> UserInfoProvider {
        let provider = UserInfoProvider()
        provider.value = userInfo
        return provider
    }
}

extension UploadURLProvider {
    static func mockAny() -> UploadURLProvider {
        return UploadURLProvider(
            urlWithClientToken: URL(string: "https://app.example.com/v2/api?abc-def-ghi")!,
            queryItemProviders: []
        )
    }
}

extension HTTPClient {
    static func mockAny() -> HTTPClient {
        return HTTPClient(session: URLSession())
    }
}

extension HTTPHeaders {
    static func mockAny() -> HTTPHeaders {
        return HTTPHeaders(headers: [])
    }
}

extension MobileDevice {
    static func mockAny() -> MobileDevice {
        return .mockWith()
    }

    static func mockWith(
        model: String = .mockAny(),
        osName: String = .mockAny(),
        osVersion: String = .mockAny(),
        enableBatteryStatusMonitoring: @escaping () -> Void = {},
        resetBatteryStatusMonitoring: @escaping () -> Void = {},
        currentBatteryStatus: @escaping () -> BatteryStatus = { .mockAny() }
    ) -> MobileDevice {
        return MobileDevice(
            model: model,
            osName: osName,
            osVersion: osVersion,
            enableBatteryStatusMonitoring: enableBatteryStatusMonitoring,
            resetBatteryStatusMonitoring: resetBatteryStatusMonitoring,
            currentBatteryStatus: currentBatteryStatus
        )
    }
}

extension BatteryStatus.State {
    static func mockRandom(within cases: [BatteryStatus.State] = [.unknown, .unplugged, .charging, .full]) -> BatteryStatus.State {
        return cases.randomElement()!
    }
}

extension BatteryStatus {
    static func mockAny() -> BatteryStatus {
        return mockWith()
    }

    static func mockWith(
        state: State = .charging,
        level: Float = 0.5,
        isLowPowerModeEnabled: Bool = false
    ) -> BatteryStatus {
        return BatteryStatus(state: state, level: level, isLowPowerModeEnabled: isLowPowerModeEnabled)
    }
}

struct BatteryStatusProviderMock: BatteryStatusProviderType {
    let current: BatteryStatus

    static func mockWith(status: BatteryStatus) -> BatteryStatusProviderMock {
        return BatteryStatusProviderMock(current: status)
    }
}

extension NetworkConnectionInfo.Reachability {
    static func mockAny() -> NetworkConnectionInfo.Reachability {
        return .maybe
    }

    static func mockRandom(
        within cases: [NetworkConnectionInfo.Reachability] = [.yes, .no, .maybe]
    ) -> NetworkConnectionInfo.Reachability {
        return cases.randomElement()!
    }
}

extension NetworkConnectionInfo.Interface: RandomMockable {
    static func mockRandom() -> NetworkConnectionInfo.Interface {
        return allCases.randomElement()!
    }
}

extension NetworkConnectionInfo: RandomMockable {
    static func mockAny() -> NetworkConnectionInfo {
        return mockWith()
    }

    static func mockWith(
        reachability: NetworkConnectionInfo.Reachability = .mockAny(),
        availableInterfaces: [NetworkConnectionInfo.Interface] = [.wifi],
        supportsIPv4: Bool = true,
        supportsIPv6: Bool = true,
        isExpensive: Bool = true,
        isConstrained: Bool = true
    ) -> NetworkConnectionInfo {
        return NetworkConnectionInfo(
            reachability: reachability,
            availableInterfaces: availableInterfaces,
            supportsIPv4: supportsIPv4,
            supportsIPv6: supportsIPv6,
            isExpensive: isExpensive,
            isConstrained: isConstrained
        )
    }

    static func mockRandom() -> NetworkConnectionInfo {
        return NetworkConnectionInfo(
            reachability: .mockRandom(),
            availableInterfaces: .mockRandom(),
            supportsIPv4: .random(),
            supportsIPv6: .random(),
            isExpensive: .random(),
            isConstrained: .random()
        )
    }
}

class NetworkConnectionInfoProviderMock: NetworkConnectionInfoProviderType, WrappedNetworkConnectionInfoProvider {
    private let queue = DispatchQueue(label: "com.datadoghq.NetworkConnectionInfoProviderMock")
    private var _current: NetworkConnectionInfo?

    init(networkConnectionInfo: NetworkConnectionInfo?) {
        _current = networkConnectionInfo
    }

    func set(current: NetworkConnectionInfo?) {
        queue.async { self._current = current }
    }

    // MARK: - NetworkConnectionInfoProviderType

    var current: NetworkConnectionInfo? {
        queue.sync { _current }
    }

    func subscribe<Observer: NetworkConnectionInfoObserver>(_ subscriber: Observer) where Observer.ObservedValue == NetworkConnectionInfo? {
    }

    // MARK: - Mocking

    static func mockAny() -> NetworkConnectionInfoProviderMock {
        return mockWith()
    }

    static func mockWith(
        networkConnectionInfo: NetworkConnectionInfo? = .mockAny()
    ) -> NetworkConnectionInfoProviderMock {
        return NetworkConnectionInfoProviderMock(networkConnectionInfo: networkConnectionInfo)
    }
}

extension CarrierInfo.RadioAccessTechnology: RandomMockable {
    static func mockAny() -> CarrierInfo.RadioAccessTechnology { .LTE }

    static func mockRandom() -> CarrierInfo.RadioAccessTechnology {
        return allCases.randomElement()!
    }
}

extension CarrierInfo: RandomMockable {
    static func mockAny() -> CarrierInfo {
        return mockWith()
    }

    static func mockWith(
        carrierName: String? = .mockAny(),
        carrierISOCountryCode: String? = .mockAny(),
        carrierAllowsVOIP: Bool = .mockAny(),
        radioAccessTechnology: CarrierInfo.RadioAccessTechnology = .mockAny()
    ) -> CarrierInfo {
        return CarrierInfo(
            carrierName: carrierName,
            carrierISOCountryCode: carrierISOCountryCode,
            carrierAllowsVOIP: carrierAllowsVOIP,
            radioAccessTechnology: radioAccessTechnology
        )
    }

    static func mockRandom() -> CarrierInfo {
        return CarrierInfo(
            carrierName: .mockRandom(),
            carrierISOCountryCode: .mockRandom(),
            carrierAllowsVOIP: .random(),
            radioAccessTechnology: .mockRandom()
        )
    }
}

class CarrierInfoProviderMock: CarrierInfoProviderType, WrappedCarrierInfoProvider {
    private let queue = DispatchQueue(label: "com.datadoghq.CarrierInfoProviderMock")
    private var _current: CarrierInfo?

    init(carrierInfo: CarrierInfo?) {
        _current = carrierInfo
    }

    func set(current: CarrierInfo?) {
        queue.async { self._current = current }
    }

    // MARK: - CarrierInfoProviderType

    var current: CarrierInfo? {
        queue.sync { _current }
    }

    func subscribe<Observer: CarrierInfoObserver>(_ subscriber: Observer) where Observer.ObservedValue == CarrierInfo? {
    }

    // MARK: - Mocking

    static func mockAny() -> CarrierInfoProviderMock {
        return mockWith()
    }

    static func mockWith(
        carrierInfo: CarrierInfo = .mockAny()
    ) -> CarrierInfoProviderMock {
        return CarrierInfoProviderMock(carrierInfo: carrierInfo)
    }
}

extension AppStateListener {
    static func mockAny() -> AppStateListener {
        return AppStateListener(dateProvider: SystemDateProvider())
    }
}

extension EncodableValue {
    static func mockAny() -> EncodableValue {
        return EncodableValue(String.mockAny())
    }
}

extension ValuePublisher where Value: AnyMockable {
    static func mockAny() -> ValuePublisher {
        return .init(initialValue: .mockAny())
    }
}

extension ValuePublisher {
    /// Publishes `newValue` using `publishSync(:_)` or `publishAsync(:_)`.
    func publishSyncOrAsync(_ newValue: Value) {
        if Bool.random() {
            publishSync(newValue)
        } else {
            publishAsync(newValue)
        }
    }
}

internal class ValueObserverMock<Value>: ValueObserver {
    typealias ObservedValue = Value

    private(set) var onValueChange: ((Value, Value) -> Void)?
    private(set) var lastChange: (oldValue: Value, newValue: Value)?

    init(onValueChange: ((Value, Value) -> Void)? = nil) {
        self.onValueChange = onValueChange
    }

    func onValueChanged(oldValue: Value, newValue: Value) {
        lastChange = (oldValue, newValue)
        onValueChange?(oldValue, newValue)
    }
}

// MARK: - Attributes Mock

/// Creates randomized `[String: Encodable]` attributes
func mockRandomAttributes() -> [String: Encodable] {
    struct Foo: Encodable {
        let bar: String = .mockRandom()
        let bizz = Bizz()

        struct Bizz: Encodable {
            let buzz: String = .mockRandom()
        }
    }

    return [
        "string-attribute": String.mockRandom(),
        "int-attribute": Int.mockRandom(),
        "uint64-attribute": UInt64.mockRandom(),
        "double-attribute": Double.mockRandom(),
        "bool-attribute": Bool.random(),
        "int-array-attribute": [Int].mockRandom(),
        "dictionary-attribute": [String: Int].mockRandom(),
        "url-attribute": URL.mockRandom(),
        "encodable-struct-attribute": Foo()
    ]
}

extension DDError: RandomMockable {
    static func mockRandom() -> DDError {
        return DDError(
            type: .mockRandom(),
            message: .mockRandom(),
            stack: .mockRandom()
        )
    }
}

// MARK: - Global Dependencies Mocks

/// Mock which can be used to intercept messages printed by `developerLogger` or
/// `userLogger` by overwriting `Datadog.consolePrint` function:
///
///     let printFunction = PrintFunctionMock()
///     consolePrint = printFunction.print
///
class PrintFunctionMock {
    private(set) var printedMessages: [String] = []
    var printedMessage: String? { printedMessages.last }

    func print(message: String) {
        printedMessages.append(message)
    }
}
