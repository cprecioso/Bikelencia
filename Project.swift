import ProjectDescription

let exportSketchAppIcon = {
  let inputFile = Path.relativeToRoot("Icon.sketch")
  let outputDir = Path.relativeToRoot("Bikelencia/Resources/Assets.xcassets/AppIcon.appiconset")

  return TargetScript.pre(
    tool: "/Applications/Sketch.app/Contents/MacOS/sketchtool",
    arguments: [
      "export",
      "slices",
      inputFile.pathString,
      "--output=\(outputDir.pathString)",
      "--overwriting=YES",
    ],
    name: "Export Sketch App Icon",
    inputPaths: [inputFile],
    outputPaths: [outputDir],
    basedOnDependencyAnalysis: true
  )
}()

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
    .package(url: "https://github.com/mergesort/Boutique.git", from: "2.2.0"),
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
        "NSLocationWhenInUseUsageDescription":
          "Bikelencia uses your location only to show where you are in the map.",
        "NSLocationTemporaryUsageDescriptionDictionary":
          "Bikelencia uses your location to show where you are in the map.",
        "NSLocationDefaultAccuracyReduced": false,
        "UILaunchScreen": [
          "UIColorName": "MapsBackground"
        ],
        "UIRequiredDeviceCapabilities": [
          "armv7",
          "gps",
          "location-services",
          "magnetometer",
        ],
        "LSApplicationCategoryType": "public.app-category.navigation",
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false
        ],
      ]),
      sources: ["Bikelencia/Sources/**"],
      resources: ["Bikelencia/Resources/**"],
      entitlements: "./Bikelencia/Bikelencia.entitlements",
      scripts: [exportSketchAppIcon],
      dependencies: [
        .package(product: "ValenciaKit"),
        .package(product: "Boutique"),
      ],
      settings: .settings(base: [
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor"
      ])
    )
  ]
)
