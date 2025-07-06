import ProjectDescription

let teamName = "design.precioso"
let productName = "Bikelencia"

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
    .local(path: "./ValenciaKit")
  ],
  settings: .settings(base: [
    "DEVELOPMENT_TEAM": "K6ZPYZVLC6",
    "ENABLE_USER_SCRIPT_SANDBOXING": false,
    "SWIFT_EMIT_LOC_STRINGS": true,
    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
    "SWIFT_VERSION": "5.0",
  ]),
  targets: [
    .target(
      name: "Bikelencia",
      destinations: [.iPhone, .iPad],
      product: .app,
      bundleId: "\(teamName).\(productName)",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [
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
      ]),
      sources: ["Bikelencia/Sources/**"],
      resources: ["Bikelencia/Resources/*"],
      entitlements: .dictionary([
        "com.apple.developer.team-identifier": "$(DEVELOPMENT_TEAM)",
        "com.apple.security.application-groups": ["group.\(teamName)"],
      ]),
      dependencies: [
        .package(product: "ValenciaKit")
      ],
      settings: .settings(base: [
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor"
      ])
    )
  ]
)
