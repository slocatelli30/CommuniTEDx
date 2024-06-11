class Talk {
  final String title;
  final String details;
  final String mainSpeaker;
  final String url;
  // title_next
  final List<String> watchNext;

  Talk.fromJSON(Map<String, dynamic> jsonMap) :
    title = jsonMap['title'],
    details = jsonMap['description'],
    mainSpeaker = (jsonMap['speakers'] ?? ""),
    url = (jsonMap['url'] ?? ""),
    // title_next
    watchNext = List<String>.from(jsonMap['title_next'] ?? "There are no related videos");
}