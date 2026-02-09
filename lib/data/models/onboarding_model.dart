class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;
  final int index;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.index,
  });

  // Factory constructor from JSON
  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
      index: json['index'] as int,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_path': imagePath,
      'index': index,
    };
  }

  // Static list of onboarding screens
  static List<OnboardingModel> get screens => [
    const OnboardingModel(
      title: 'مرحباً بك في Lumo AI',
      description: 'منصتك الطبية الشاملة لرعاية أطفالك مع أفضل الأطباء',
      imagePath: 'assets/images/onboarding_1.png',
      index: 0,
    ),
    const OnboardingModel(
      title: 'تواصل مع الأطباء',
      description: 'تواصل مباشرة مع الأطباء المختصين واحصل على استشارات فورية',
      imagePath: 'assets/images/onboarding_2.png',
      index: 1,
    ),
    const OnboardingModel(
      title: 'تتبع صحة طفلك',
      description: 'راقب حالة طفلك الصحية واحصل على تحديثات مستمرة من طبيبك',
      imagePath: 'assets/images/onboarding_3.png',
      index: 2,
    ),
  ];

  @override
  String toString() {
    return 'OnboardingModel(title: $title, index: $index)';
  }
}