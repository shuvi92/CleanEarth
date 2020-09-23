class ReportsStats {
  int cleaned = 0;
  int reported = 0;

  ReportsStats({this.cleaned, this.reported});

  ReportsStats.fromJson(Map<String, dynamic> json) {
    cleaned = json['cleaned'];
    reported = json['reported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cleaned'] = this.cleaned;
    data['reported'] = this.reported;
    return data;
  }
}
