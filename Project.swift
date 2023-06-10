import ProjectDescription

let project = Project(
  name: "Bikelencia",
  organizationName: "Carlos Precioso",
  options: .options(
    textSettings: .textSettings(
      usesTabs: false,
      indentWidth: 2,
      wrapsLines: true
    )
  ),
  packages: [
    .local(path: "./ValenciaKit"),
    .package(url: "https://github.com/mergesort/Boutique.git", from: "2.2.0")
  ],
  settings: .settings(base: [
    "DEVELOPMENT_TEAM": "K6ZPYZVLC6"
  ]),
  targets: [
    Target(
      name: "Bikelencia",
      platform: .iOS,
      product: .app,
      productName: "Bikelencia",
      bundleId: "design.precioso.Bikelencia",
      deploymentTarget: .iOS(
        targetVersion: "16.4",
        devices: [.iphone, .ipad],
        supportsMacDesignedForIOS: false
      ),
      infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": "Launch Screen.storyboard",
        "NSLocationWhenInUseUsageDescription": "Bikelencia uses your location only to show where you are in the map",
        "NSLocationDefaultAccuracyReduced": false
      ]),
      sources: ["Bikelencia/Sources/**"],
      resources: ["Bikelencia/Resources/**"],
      entitlements: "./Bikelencia/Bikelencia.entitlements",
      dependencies: [
        .package(product: "ValenciaKit"),
        .package(product: "Boutique")
      ],
      settings: .settings(base: [
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor"
      ])
    ),
  ]
)
