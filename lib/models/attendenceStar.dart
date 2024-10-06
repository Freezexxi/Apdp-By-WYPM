class AttendenceStar {
  final String _attID;
  DateTime attDate;
  List<String> ListofStudentsStarID;
  String courseStarID;

  AttendenceStar(
      this._attID, this.attDate, this.courseStarID, this.ListofStudentsStarID);

  String get AttendenceStarID => _attID;
}
