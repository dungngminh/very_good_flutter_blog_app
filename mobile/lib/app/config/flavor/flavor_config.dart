enum Flavor { development, production, staging }

class FlavorValues {
  FlavorValues({required this.baseUrl});
  final String baseUrl;
  //Add other flavor specific values, e.g database name
}

class FlavorConfig {
  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    return _instance ??= FlavorConfig._(
      flavor: flavor,
      values: values,
    );
  }
  FlavorConfig._({required this.flavor, required this.values});

  final Flavor flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isDevelopment() => _instance!.flavor == Flavor.development;

  static bool isStaging() => _instance!.flavor == Flavor.staging;
}
