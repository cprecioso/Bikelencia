import ProjectDescription

let teamName = "design.precioso"
let productName = "Bikelencia"

let exportSketchAppIcon = {
  let inputFile = Path.relativeToRoot("Icon.sketch")
  let outputDir = Path.relativeToRoot("Bikelencia/Resources/Assets.xcassets/AppIcon.appiconset")

  return TargetScript.pre(
    path: "/Applications/Sketch.app/Contents/MacOS/sketchtool",
    arguments: [
      "export",
      "slices",
      inputFile.pathString,
      "--output=\(outputDir.pathString)",
      "--overwriting=YES",
    ],
    name: "Export Sketch App Icon",
    inputPaths: [.glob(inputFile)],
    outputPaths: [outputDir],
    basedOnDependencyAnalysis: true
  )
}()

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
    .package(url: "https://github.com/mergesort/Boutique", from: "2.4.2"),
  ],
  settings: .settings(base: [
    "DEVELOPMENT_TEAM": "K6ZPYZVLC6",
    "ENABLE_USER_SCRIPT_SANDBOXING": false,
    "SWIFT_EMIT_LOC_STRINGS": true,
    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
  ]),
  targets: [
    .target(
      name: "Bikelencia",
      destinations: [.iPhone, .iPad],
      product: .app,
      bundleId: "\(teamName).\(productName)",
      deploymentTargets: .iOS("16.4"),
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
      resources: ["Bikelencia/Resources/**"],
      entitlements: .dictionary([
        "com.apple.developer.team-identifier": "$(DEVELOPMENT_TEAM)",
        "com.apple.security.application-groups": ["group.\(teamName)"],
      ]),
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
