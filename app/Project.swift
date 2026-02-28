import ProjectDescription

let teamName = "design.precioso"
let productName = "Bikelencia"
let marketingVersion = "1.3.1"
let bundleIdentifier = "\(teamName).\(productName)"

let destinations: Destinations = .iOS
let deploymentTargets: DeploymentTargets = .iOS("26.2")

let project = Project(
  name: productName,
  options: .options(
    defaultKnownRegions: ["en", "es", "ca"],
    developmentRegion: "en",
    textSettings: .textSettings(
      usesTabs: false,
      indentWidth: 2,
      wrapsLines: true
    )
  ),
  packages: [
    .local(path: "./ValenciaKit"),
    .package(url: "https://github.com/vospennikov/ClusterMap.git", from: "2.1.1"),
  ],
  settings: .settings(
    base: [
      "ENABLE_USER_SCRIPT_SANDBOXING": false,
      "ENABLE_MODULE_VERIFIER": true,
      "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
      "STRING_CATALOG_GENERATE_SYMBOLS": true,
      "SWIFT_EMIT_LOC_STRINGS": true,
      "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
    ]
    .automaticCodeSigning(devTeam: "K6ZPYZVLC6")
    .marketingVersion(marketingVersion)
    .swiftVersion("5.0")
  ),
  targets: [
    .target(
      name: "BikelenciaCore",
      destinations: destinations,
      product: .framework,
      bundleId: "\(bundleIdentifier).Core",
      deploymentTargets: deploymentTargets,
      sources: ["BikelenciaCore/**"],
      dependencies: [.package(product: "ValenciaKit")]
    ),
    .target(
      name: "Bikelencia",
      destinations: destinations,
      product: .app,
      bundleId: bundleIdentifier,
      deploymentTargets: deploymentTargets,
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "NSLocationTemporaryUsageDescriptionDictionary":
          "Bikelencia uses your location only to show where you are in the map.",
        "NSLocationWhenInUseUsageDescription":
          "Bikelencia uses your location to show where you are in the map.",
        "NSLocationDefaultAccuracyReduced": false,
        "UILaunchScreen": [
          "UIColorName": "MapsBackground"
        ],
        "UIRequiredDeviceCapabilities": ["arm64"],
        "LSApplicationCategoryType": "public.app-category.navigation",
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false
        ],
        "ITSAppUsesNonExemptEncryption": false,
        "BAManifestURL": "https://api.bikelencia.precioso.design/api/manifest",
        "BAMaxInstallSize": 2_000_000,
        "BAInitialDownloadRestrictions": [
          "BADownloadAllowance": 2_000_000,
          "BAEssentialDownloadAllowance": 2_000_000,
          "BADownloadDomainAllowList": ["api.bikelencia.precioso.design"],
        ],
      ]),
      sources: ["Bikelencia/Sources/**"],
      resources: [
        "Bikelencia/Resources/*",
        "../resources/AppIcon.icon",
      ],
      entitlements: .dictionary([
        "com.apple.developer.team-identifier": "$(DEVELOPMENT_TEAM)",
        "com.apple.security.application-groups": ["group.\(bundleIdentifier)"],
      ]),
      dependencies: [
        .target(name: "BikelenciaCore"),
        .target(name: "BikelenciaDownloader"),
        .package(product: "ClusterMap"),
        .package(product: "ClusterMapSwiftUI"),
      ],
      settings: .settings(base: [
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor"
      ])
    ),
    .target(
      name: "BikelenciaDownloader",
      destinations: destinations,
      product: .extensionKitExtension,
      bundleId: "\(bundleIdentifier).Downloader",
      deploymentTargets: deploymentTargets,
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
        "EXAppExtensionAttributes": [
          "EXExtensionPointIdentifier":
            "com.apple.background-asset-downloader-extension"
        ],
      ]),
      sources: ["BikelenciaDownloader/**"],
      entitlements: .dictionary([
        "com.apple.developer.team-identifier": "$(DEVELOPMENT_TEAM)",
        "com.apple.security.application-groups": ["group.\(bundleIdentifier)"],
      ]),
      dependencies: [
        .target(name: "BikelenciaCore")
      ]
    ),
  ]
)
