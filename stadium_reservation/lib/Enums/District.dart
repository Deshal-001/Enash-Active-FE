// District.dart
enum District {
  DISTRICT1,
  DISTRICT2,
  DISTRICT3,
  DISTRICT4,
  DISTRICT5,
  DISTRICT6,
  DISTRICT7,
  DISTRICT8,
  DISTRICT9,
  DISTRICT10,
  DISTRICT11,
  DISTRICT12,
  DISTRICT13,
  DISTRICT14,
  DISTRICT15,
  DISTRICT16,
  DISTRICT17,
  DISTRICT18,
  DISTRICT19,
  DISTRICT20,
  DISTRICT21,
  DISTRICT22,
  DISTRICT23,
  DISTRICT24,
  DISTRICT25,
}

extension DistrictExtension on District {
  String getDisplayName() {
    switch (this) {
      case District.DISTRICT1:
        return "Ampara";
      case District.DISTRICT2:
        return "Anuradhapura";
      case District.DISTRICT3:
        return "Badulla";
      case District.DISTRICT4:
        return "Batticaloa";
      case District.DISTRICT5:
        return "Colombo";
      case District.DISTRICT6:
        return "Galle";
      case District.DISTRICT7:
        return "Gampaha";
      case District.DISTRICT8:
        return "Hambantota";
      case District.DISTRICT9:
        return "Jaffna";
      case District.DISTRICT10:
        return "Kalutara";
      case District.DISTRICT11:
        return "Kandy";
      case District.DISTRICT12:
        return "Kegalle";
      case District.DISTRICT13:
        return "Kilinochchi";
      case District.DISTRICT14:
        return "Kurunegala";
      case District.DISTRICT15:
        return "Mannar";
      case District.DISTRICT16:
        return "Matale";
      case District.DISTRICT17:
        return "Matara";
      case District.DISTRICT18:
        return "Moneragala";
      case District.DISTRICT19:
        return "Mullaitivu";
      case District.DISTRICT20:
        return "Nuwara Eliya";
      case District.DISTRICT21:
        return "Polonnaruwa";
      case District.DISTRICT22:
        return "Puttalam";
      case District.DISTRICT23:
        return "Ratnapura";
      case District.DISTRICT24:
        return "Trincomalee";
      case District.DISTRICT25:
        return "Vavuniya";
      default:
        return "";
    }
  }
}
