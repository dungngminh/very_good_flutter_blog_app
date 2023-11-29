enum BlogCategory implements Enum {
  business,
  technology,
  fashion,
  travel,
  food,
  education;

  bool get isBusiness => this == BlogCategory.business;
  bool get isTechnology => this == BlogCategory.technology;
  bool get isFashion => this == BlogCategory.fashion;
  bool get isTravel => this == BlogCategory.travel;
  bool get isFood => this == BlogCategory.food;
  bool get isEducation => this == BlogCategory.education;
}
